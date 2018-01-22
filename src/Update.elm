module Update exposing (..)

import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        DeleteCategories categoriesToDeleteId ->
            let
                updatedCategories =
                    deleteCategories model.categories categoriesToDeleteId
            in
            ( { model | categories = updatedCategories }, Cmd.none )

        DeleteSites sitesToDeleteId ->
            let
                updatedSites =
                    deleteSites model.sites sitesToDeleteId

                updatedArticles =
                    deleteSitesArticles model.articles sitesToDeleteId
            in
            ( { model
                | sites = updatedSites
                , articles = updatedArticles
              }
            , Cmd.none
            )

        DeleteCategoryAndSites categoriesToDeleteId sitesToDeleteId ->
            let
                updatedCategories =
                    deleteCategories model.categories categoriesToDeleteId

                updatedSites =
                    deleteSites model.sites sitesToDeleteId

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
                updatedCategories =
                    List.map
                        (\category ->
                            if category.id == categoryId then
                                { category | name = newName }
                            else
                                category
                        )
                        model.categories
            in
            ( { model | categories = updatedCategories }, Cmd.none )


deleteCategories : List Category -> List Int -> List Category
deleteCategories categories categoriesToDeleteId =
    List.filter (\category -> not (List.member category.id categoriesToDeleteId)) categories


deleteSites : List Site -> List Int -> List Site
deleteSites sites sitesToDeleteId =
    List.filter (\site -> not (List.member site.id sitesToDeleteId)) sites


deleteSitesArticles : List Article -> List Int -> List Article
deleteSitesArticles articles sitesToDeleteId =
    List.filter (\article -> not (List.member article.siteId sitesToDeleteId)) articles
