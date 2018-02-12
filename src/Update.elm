module Update exposing (..)

import Dom exposing (focus)
import GetFeeds exposing (getFeeds)
import Helpers exposing (getNextId, mergeArticles)
import Import exposing (executeImport)
import Models exposing (AnimationState(..), Article, Category, CategoryPanelState, Id, Model, Site)
import Msgs exposing (..)
import Murmur3 exposing (hashString)
import OutsideInfo exposing (sendInfoOutside, switchInfoForElm)
import Process
import Task
import Time exposing (Time)
import Transit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogErr err ->
            let
                log =
                    Debug.log "Error: " err
            in
            ( { model | errorMsgs = model.errorMsgs ++ [ toString err ] }, Cmd.none )

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
            let
                updatedModel =
                    { model | selectedCategoryId = Just categoryId }
            in
            if isPanelOpen model.categoryPanelStates categoryId then
                ( { model | categoryPanelStates = setCategoryPanelState model.categoryPanelStates categoryId Open Closing }, delay 500 HideDeleteActionPanels )
            else
                ( { model | categoryPanelStates = setCategoryPanelState model.categoryPanelStates categoryId Hidden Opening }, delay 10 (OpenDeleteActionPanel categoryId) )

        TransitMsg a ->
            Transit.tick TransitMsg a model

        HideDeleteActionPanels ->
            let
                newPanelStates =
                    model.categoryPanelStates
                        |> List.map
                            (\panelState ->
                                let
                                    ( id, state ) =
                                        panelState
                                in
                                if state == Closing then
                                    ( id, Hidden )
                                else
                                    ( id, state )
                            )
            in
            ( { model | categoryPanelStates = newPanelStates }, Cmd.none )

        OpenDeleteActionPanel categoryId ->
            let
                newPanelStates =
                    model.categoryPanelStates
                        |> List.map
                            (\panelState ->
                                if panelState == ( categoryId, Opening ) then
                                    ( categoryId, Open )
                                else
                                    ( panelState |> Tuple.first, Closing )
                            )
            in
            ( { model | categoryPanelStates = newPanelStates }, delay 500 HideDeleteActionPanels )

        ToggleImportLayer ->
            ( { model
                | importLayerOpen = not model.importLayerOpen
                , importData = ""
              }
            , Cmd.none
            )

        StoreImportData importData ->
            ( { model | importData = importData }, Cmd.none )

        ExecuteImport ->
            let
                newModel =
                    executeImport model
            in
            ( { newModel | categoryPanelStates = newModel.categories |> List.map (\category -> ( category.id, Hidden )) }, getDataToSaveInDb newModel |> SaveAllData |> sendInfoOutside )

        DeleteCategories categoryToDeleteIds ->
            let
                updatedCategories =
                    deleteContents model.categories categoryToDeleteIds
            in
            ( { model
                | categories = updatedCategories
              }
            , DeleteCategoriesInDb categoryToDeleteIds |> sendInfoOutside
            )

        DeleteSites sitesToDeleteId ->
            let
                updatedSites =
                    deleteContents model.sites sitesToDeleteId

                ( updatedArticles, articleToDeleteInDbIds ) =
                    deleteSitesArticles model.articles sitesToDeleteId

                updatedSiteToEditId =
                    case model.siteToEditId of
                        Just id ->
                            if List.member id sitesToDeleteId then
                                Nothing
                            else
                                Just id

                        Nothing ->
                            Nothing
            in
            ( { model
                | sites = updatedSites
                , articles = updatedArticles
                , siteToEditId = updatedSiteToEditId
              }
            , Cmd.batch
                [ DeleteSitesInDb sitesToDeleteId |> sendInfoOutside
                , DeleteArticlesInDb articleToDeleteInDbIds |> sendInfoOutside
                ]
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
              }
            , Cmd.batch
                [ DeleteSitesInDb sitesToDeleteId |> sendInfoOutside
                , DeleteCategoriesInDb categoryToDeleteIds |> sendInfoOutside
                , DeleteArticlesInDb articleToDeleteInDbIds |> sendInfoOutside
                ]
            )

        EditCategoryId categoryToEditId ->
            ( { model
                | categoryToEditId = Just categoryToEditId
                , selectedCategoryId = Just categoryToEditId
              }
            , Cmd.none
            )

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
            ( { model | categories = updatedCategories }, UpdateCategoryInDb updateCategory |> sendInfoOutside )

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
                , AddCategoryInDb newCategory |> sendInfoOutside
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
            , AddSiteInDb newSite |> sendInfoOutside
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
            ( { model | sites = updatedSites }, UpdateSiteInDb siteToUpdate |> sendInfoOutside )

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

        GetArticles rssResult ->
            case rssResult of
                Ok feeds ->
                    let
                        rssArticles =
                            feeds
                                |> List.map (\article -> { article | id = hashString 12345 article.link })
                    in
                    ( { model | articles = mergeArticles rssArticles model.articles }, Cmd.none )

                Err err ->
                    ( { model | errorMsgs = model.errorMsgs ++ [ err ] }, Cmd.none )

        SaveArticle articleToSave ->
            let
                udatedArticleToSave =
                    { articleToSave | starred = True }

                updatedArticles =
                    List.map
                        (\article ->
                            if article.id == articleToSave.id then
                                udatedArticleToSave
                            else
                                article
                        )
                        model.articles
            in
            ( { model | articles = updatedArticles }, AddArticleInDb udatedArticleToSave |> sendInfoOutside )

        RefreshFeeds ->
            ( model, getFeeds model.sites |> Cmd.batch )

        Outside infoForElm ->
            switchInfoForElm infoForElm model

        RemoveErrorMsg msgToRemove ->
            let
                newErrorMsgs =
                    model.errorMsgs |> List.filter (\modelMsg -> modelMsg /= msgToRemove)
            in
            ( { model | errorMsgs = newErrorMsgs }, Cmd.none )

        UpdateSearch searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


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


getDataToSaveInDb : Model -> ( List Category, List Site, List Article )
getDataToSaveInDb model =
    ( model.categories, model.sites, model.articles |> List.filter (\article -> article.starred) )


isPanelOpen : List CategoryPanelState -> Id -> Bool
isPanelOpen categoryPanelStates categoryId =
    List.member ( categoryId, Open ) categoryPanelStates


setCategoryPanelState : List CategoryPanelState -> Id -> AnimationState -> AnimationState -> List CategoryPanelState
setCategoryPanelState panelStates categoryId oldState newState =
    panelStates
        |> List.map
            (\panelState ->
                let
                    ( catId, state ) =
                        panelState
                in
                if catId == categoryId && state == oldState then
                    ( catId, newState )
                else
                    panelState
            )


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
