module Update.Delete exposing (handleDeleteMsgs)

import Helpers exposing (closeModal, openModal)
import Models exposing (Article, DeleteMsg(..), Id, InfoForOutside(..), Modal, Model, Msg(..), Panel(..))
import OutsideInfo exposing (sendInfoOutside)
import PanelsManager exposing (closePanel, openPanel)


handleDeleteMsgs : Model -> DeleteMsg -> ( Model, Cmd Msg )
handleDeleteMsgs model msg =
    case msg of
        RequestDeleteCategories categoryToDeleteIds ->
            let
                modalData =
                    Modal
                        "Are you sure you want to delete this category?"
                        (DeleteCategories categoryToDeleteIds |> DeleteMsg)
            in
            ( { model
                | modal = modalData
                , panelsState = openModal model.panelsState
              }
            , Cmd.none
            )

        DeleteCategories categoryToDeleteIds ->
            let
                updatedCategories =
                    deleteContents model.categories categoryToDeleteIds
            in
            ( { model
                | categories = updatedCategories
                , panelsState = closeModal model.panelsState
              }
            , DeleteCategoriesInDb categoryToDeleteIds |> sendInfoOutside
            )

        RequestDeleteSites sitesToDeleteId ->
            let
                modalData =
                    Modal
                        "Are you sure you want to delete this site?"
                        (DeleteSites sitesToDeleteId |> DeleteMsg)
            in
            ( { model
                | modal = modalData
                , panelsState = openModal model.panelsState
              }
            , Cmd.none
            )

        DeleteSites sitesToDeleteId ->
            let
                updatedSites =
                    deleteContents model.sites sitesToDeleteId

                ( updatedArticles, articleToDeleteInDbIds ) =
                    deleteSitesArticles model.articles sitesToDeleteId
            in
            ( { model
                | sites = updatedSites
                , articles = updatedArticles
                , panelsState = (closePanel (panelToString PanelEditSite) >> closeModal) model.panelsState
              }
            , Cmd.batch
                [ DeleteSitesInDb sitesToDeleteId |> sendInfoOutside
                , DeleteArticlesInDb articleToDeleteInDbIds |> sendInfoOutside
                ]
            )

        RequestDeleteCategoryAndSites categoryToDeleteIds sitesToDeleteId ->
            let
                modalData =
                    Modal
                        "Are you sure you want to delete this category and all its sites?"
                        (DeleteCategoryAndSites categoryToDeleteIds sitesToDeleteId |> DeleteMsg)
            in
            ( { model
                | modal = modalData
                , panelsState = openModal model.panelsState
              }
            , Cmd.none
            )

        DeleteCategoryAndSites categoryToDeleteIds sitesToDeleteId ->
            let
                updatedCategories =
                    deleteContents model.categories categoryToDeleteIds

                updatedSites =
                    deleteContents model.sites sitesToDeleteId

                ( updatedArticles, articleToDeleteInDbIds ) =
                    deleteSitesArticles model.articles sitesToDeleteId
            in
            ( { model
                | categories = updatedCategories
                , sites = updatedSites
                , articles = updatedArticles
                , panelsState = closeModal model.panelsState
              }
            , Cmd.batch
                [ DeleteSitesInDb sitesToDeleteId |> sendInfoOutside
                , DeleteCategoriesInDb categoryToDeleteIds |> sendInfoOutside
                , DeleteArticlesInDb articleToDeleteInDbIds |> sendInfoOutside
                ]
            )

        DeleteArticles articleToDeleteIds ->
            let
                updatedArticles =
                    List.map
                        (\article ->
                            if List.member article.id articleToDeleteIds then
                                { article | starred = False }

                            else
                                article
                        )
                        model.articles
            in
            ( { model | articles = updatedArticles }, DeleteArticlesInDb articleToDeleteIds |> sendInfoOutside )


deleteContents : List { a | id : Int } -> List Id -> List { a | id : Int }
deleteContents contents contentToDeleteIds =
    List.filter (\content -> not (List.member content.id contentToDeleteIds)) contents


deleteSitesArticles : List Article -> List Int -> ( List Article, List Id )
deleteSitesArticles articles sitesToDeleteId =
    List.foldl
        (\article ( articleToKeep, articleToDeleteInDbIds ) ->
            if List.member article.siteId sitesToDeleteId then
                if article.starred then
                    ( articleToKeep, articleToDeleteInDbIds ++ [ article.id ] )

                else
                    ( articleToKeep, articleToDeleteInDbIds )

            else
                ( articleToKeep ++ [ article ], articleToDeleteInDbIds )
        )
        ( [], [] )
        articles
