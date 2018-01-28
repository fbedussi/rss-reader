module Update exposing (..)

import Dom exposing (focus)
import Helpers exposing (getNextId)
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)
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
            , Cmd.none
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
            ( { model | sites = updatedSites }, Cmd.none )

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
                    in
                    ( { model | articles = articles }, Cmd.none )

                Err err ->
                    ( model, Cmd.none )

        Outside infoForElm ->
            switchInfoForElm infoForElm model


deleteCategories : List Category -> List Int -> List Category
deleteCategories categories categoriesToDeleteId =
    List.filter (\category -> not (List.member category.id categoriesToDeleteId)) categories


deleteSites : List Site -> List Int -> List Site
deleteSites sites sitesToDeleteId =
    List.filter (\site -> not (List.member site.id sitesToDeleteId)) sites


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
