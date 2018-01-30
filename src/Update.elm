module Update exposing (..)

import Dom exposing (focus)
import Helpers exposing (getNextId)
import Models exposing (Article, Category, Id, Model, Site)
import Msgs exposing (..)
import Murmur3 exposing (hashString)
import OutsideInfo exposing (sendInfoOutside, switchInfoForElm)
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogErr err ->
            let
                log =
                    Debug.log "Error: " err
            in
            ( { model | errorMsg = err }, Cmd.none )

        SelectCategory categoryId ->
            ( { model
                | selectedCategoryId = Just categoryId
                , selectedSiteId = Nothing
              }
            , Cmd.none
            )

        SelectSite siteId ->
            ( { model | selectedSiteId = Just siteId }, Cmd.none )

        ToggleDeleteActions categoryId ->
            case model.categoryToDeleteId of
                Just id ->
                    ( { model | categoryToDeleteId = Nothing }, Cmd.none )

                Nothing ->
                    ( { model | categoryToDeleteId = Just categoryId }, Cmd.none )

        DeleteCategories categoryToDeleteIds ->
            let
                updatedCategories =
                    deleteContents model.categories categoryToDeleteIds
            in
            ( { model
                | categories = updatedCategories
              }
            , OutsideInfo.DeleteCategories categoryToDeleteIds |> sendInfoOutside
            )

        DeleteSites sitesToDeleteId ->
            let
                updatedSites =
                    deleteContents model.sites sitesToDeleteId

                updatedArticles =
                    deleteSitesArticles model.articles sitesToDeleteId
            in
            ( { model
                | sites = updatedSites
                , articles = updatedArticles
              }
            , OutsideInfo.DeleteSites sitesToDeleteId |> sendInfoOutside
            )

        DeleteCategoryAndSites categoriesToDeleteId sitesToDeleteId ->
            let
                updatedCategories =
                    deleteContents model.categories categoriesToDeleteId

                updatedSites =
                    deleteContents model.sites sitesToDeleteId

                updatedArticles =
                    deleteSitesArticles model.articles sitesToDeleteId
            in
            ( { model
                | categories = updatedCategories
                , sites = updatedSites
                , articles = updatedArticles
              }
            , Cmd.none
            )

        EditCategoryId categoryToEditId ->
            ( { model | categoryToEditId = Just categoryToEditId }, Cmd.none )

        EndCategoryEditing ->
            ( { model | categoryToEditId = Nothing }, Cmd.none )

        UpdateCategoryName categoryId newName ->
            let
                updateCategory =
                    Category
                        categoryId
                        newName

                updatedCategories =
                    List.map
                        (\category ->
                            if category.id == categoryId then
                                updateCategory
                            else
                                category
                        )
                        model.categories
            in
            ( { model | categories = updatedCategories }, OutsideInfo.UpdateCategory updateCategory |> sendInfoOutside )

        AddNewCategory ->
            let
                newCategory =
                    createNewCategory model.categories
            in
            ( { model
                | categories = List.append model.categories [ newCategory ]
                , categoryToEditId = Just newCategory.id
              }
            , Cmd.batch
                [ Dom.focus ("editCategoryName-" ++ toString newCategory.id) |> Task.attempt FocusResult
                , OutsideInfo.AddCategory newCategory |> sendInfoOutside
                ]
            )

        FocusResult result ->
            -- handle success or failure here
            case result of
                Err (Dom.NotFound id) ->
                    ( model, Cmd.none )

                Ok () ->
                    ( model, Cmd.none )

        ChangeEditSiteId siteId ->
            ( { model | siteToEditId = Just siteId }, Cmd.none )

        EndEditSite ->
            ( { model | siteToEditId = Nothing }, Cmd.none )

        AddNewSite ->
            let
                newSite =
                    createNewSite model.sites
            in
            ( { model
                | sites = List.append model.sites [ newSite ]
                , siteToEditId = Just newSite.id
              }
            , OutsideInfo.AddSite newSite |> sendInfoOutside
            )

        UpdateSite siteToUpdate ->
            let
                updatedSites =
                    List.map
                        (\site ->
                            if site.id == siteToUpdate.id then
                                siteToUpdate
                            else
                                site
                        )
                        model.sites
            in
            ( { model | sites = updatedSites }, OutsideInfo.UpdateSite siteToUpdate |> sendInfoOutside )

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
            ( { model | articles = updatedArticles }, OutsideInfo.DeleteArticles articleToDeleteIds |> sendInfoOutside )

        GetArticles rssResult ->
            let
                log =
                    Debug.log "rss" rssResult
            in
            case rssResult of
                Ok feeds ->
                    let
                        articles =
                            List.concat feeds
                                |> List.map (\article -> { article | id = hashString 12345 article.link })
                    in
                    ( { model | articles = articles }, Cmd.none )

                Err err ->
                    ( model, Cmd.none )

        SaveArticle articleToSave ->
            let
                updatedArticles =
                    List.map
                        (\article ->
                            if article.id == articleToSave.id then
                                { article | starred = True }
                            else
                                article
                        )
                        model.articles
            in
            ( { model | articles = updatedArticles }, OutsideInfo.AddArticle articleToSave |> sendInfoOutside )

        Outside infoForElm ->
            switchInfoForElm infoForElm model


deleteContents : List { a | id : Int } -> List Id -> List { a | id : Int }
deleteContents contents contentToDeleteIds =
    List.filter (\content -> not (List.member content.id contentToDeleteIds)) contents


deleteSitesArticles : List Article -> List Int -> List Article
deleteSitesArticles articles sitesToDeleteId =
    List.filter (\article -> not (List.member article.siteId sitesToDeleteId)) articles


createNewCategory : List Category -> Category
createNewCategory categories =
    let
        nextId =
            getNextId categories
    in
    Category
        nextId
        "New Category"


createNewSite : List Site -> Site
createNewSite sites =
    let
        nextId =
            getNextId sites
    in
    Site
        nextId
        []
        "New Site"
        ""
        ""
        False
