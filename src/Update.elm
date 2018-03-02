module Update exposing (..)

import Dom exposing (focus)
import GetFeeds exposing (getFeeds)
import Helpers exposing (delay, getNextId, mergeArticles)
import Import exposing (executeImport)
import Models exposing (Article, Category, Id, InfoForOutside(..), Modal, Model, Msg(..), Site, Panel(..), AppData)
import Murmur3 exposing (hashString)
import OutsideInfo exposing (sendInfoOutside, switchInfoForElm)
import PanelsManager exposing (PanelsState, closePanelsFuzzy, closeAllPanels, closePanel, getPanelState, initPanel, isPanelOpen, openPanel)
import Task
import Time

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogErr err ->
            let
                log =
                    Debug.log "Error: " err
            in
            ( { model | errorMsgs = model.errorMsgs ++ [ toString err ] }, Cmd.none )

        SetMouseNavigation ->
            ( { model | keyboardNavigation = False }, Cmd.none )

        VerifyKeyboardNavigation keyCode ->
            ( { model
                | keyboardNavigation =
                    keyCode == 9
              }
            , Cmd.none
            )

        ToggleSelectedCategory categoryId ->
            let
                newSelectedCategoryId =
                    case model.selectedCategoryId of
                        Nothing ->
                            Just categoryId

                        Just id ->
                            if id == categoryId then
                                Nothing
                            else
                                Just categoryId
            in
            ( { model
                | selectedCategoryId = newSelectedCategoryId
                , currentPage = 1
                , selectedSiteId = Nothing
              }
            , Cmd.none
            )

        ToggleSelectSite siteId ->
            let
                newSelectedSiteId =
                    case model.selectedSiteId of
                        Nothing ->
                            Just siteId

                        Just id ->
                            if id == siteId then
                                Nothing
                            else
                                Just siteId
            in
            ( { model
                | selectedSiteId = newSelectedSiteId
                , currentPage = 1
              }
            , Cmd.none
            )

        ToggleDeleteActions categoryId ->
            let
                panelId =
                    "cat_" ++ toString categoryId

                isOpen =
                    getPanelState panelId model.panelsState |> isPanelOpen

                updatedPanelsState =
                    closePanelsFuzzy "cat_" model.panelsState
                        |> (if isOpen then
                                closePanel panelId
                            else
                                openPanel panelId
                           )
            in
            ( { model | panelsState = updatedPanelsState }, Cmd.none )

        TogglePanel panel ->
            let
                isOpen =
                    getPanelState (toString panel) model.panelsState |> isPanelOpen

                updatedPanelsState =
                    if isOpen then
                        closePanel (toString panel) model.panelsState
                    else
                        openPanel (toString panel) model.panelsState
            in
            ( { model | panelsState = updatedPanelsState }, Cmd.none )

        StoreImportData importData ->
            ( { model | importData = importData }, Cmd.none )

        ExecuteImport ->
            let
                newModel =
                    executeImport model
            in
            ( newModel, getDataToSaveInDb newModel |> SaveAllData |> sendInfoOutside )

        RequestDeleteCategories categoryToDeleteIds ->
            let
                modalData =
                    Modal
                        "Are you sure you want to delete this category?"
                        (DeleteCategories categoryToDeleteIds)
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
                        (DeleteSites sitesToDeleteId)
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
                , panelsState = (closePanel (toString PanelEditSite) >> closeModal) model.panelsState
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
                        (DeleteCategoryAndSites categoryToDeleteIds sitesToDeleteId)
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
            case result of
                Err (Dom.NotFound id) ->
                    ( model, Cmd.none )

                Ok () ->
                    ( model, Cmd.none )

        OpenEditSitePanel siteId ->
            ( { model
                | siteToEditId = siteId
                , panelsState = openPanel (toString PanelEditSite) model.panelsState
              }
            , Cmd.none
            )

        CloseEditSitePanel ->
            ( { model
                | panelsState = closePanel (toString PanelEditSite) model.panelsState
              }
            , Cmd.none
            )

        AddNewSite ->
            let
                newSite =
                    createNewSite model.sites
            in
            ( { model
                | sites = List.append model.sites [ newSite ]
                , siteToEditId = newSite.id
                , panelsState = openPanel (toString PanelEditSite) model.panelsState
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
            let
                updatedModel =
                    { model | fetchingRss = False }
            in
            case rssResult of
                Ok feeds ->
                    let
                        rssArticles =
                            feeds
                                |> List.map
                                    (\article ->
                                        { article
                                            | id = hashString 12345 article.link
                                            , excerpt =
                                            article.excerpt
                                                --String.dropLeft 1 article.excerpt
                                                -- if String.length article.excerpt > 1000 then
                                                --     String.left 1000 article.excerpt ++ "..."
                                                -- else
                                                --     article.excerpt
                                        }
                                    )

                        mergedArticles =
                            mergeArticles rssArticles model.articles
                    in
                    ( { updatedModel | articles = List.sortWith dateDescending mergedArticles }, Cmd.none )

                Err err ->
                    let
                        errorMsgId =
                            hashString 1234 err |> toString

                        updatedPanelsState =
                            initPanel errorMsgId model.panelsState
                    in
                    ( { updatedModel
                        | panelsState = updatedPanelsState
                        , errorMsgs = List.filter (\msg -> msg /= err) model.errorMsgs ++ [ err ]
                      }
                    , delay 1000 (OpenErrorMsg errorMsgId)
                    )

        OpenErrorMsg errorMsgId ->
            ( { model | panelsState = openPanel errorMsgId model.panelsState }, Cmd.none )

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
            ( { model | fetchingRss = True }, Task.perform RegisterTime Time.now :: getFeeds model.sites |> Cmd.batch )

        RegisterTime time ->
            let
                updatedAppData = AppData
                    time
                    model.appData.articlesPerPage
            in
            (model, SaveAppData updatedAppData |> sendInfoOutside)

        Outside infoForElm ->
            switchInfoForElm infoForElm model

        RequestRemoveErrorMsg msgToRemove ->
            let
                updatedPanelsState =
                    closePanel (hashString 1234 msgToRemove |> toString) model.panelsState
            in
            ( { model | panelsState = updatedPanelsState }, delay 1500 (RemoveErrorMsg msgToRemove) )

        RemoveErrorMsg msgToRemove ->
            let
                newErrorMsgs =
                    model.errorMsgs |> List.filter (\modelMsg -> modelMsg /= msgToRemove)
            in
            ( { model | errorMsgs = newErrorMsgs }, Cmd.none )

        UpdateSearch searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        CloseAllPanels ->
            ( { model | panelsState = closeAllPanels model.panelsState }, Cmd.none )

        ChangePage pageNumber ->
            ( { model | currentPage = pageNumber }, Cmd.none )

        ChangeNumberOfArticlesPerPage articlesPerPage ->
            let
                updatedAppData = AppData
                    model.appData.lastRefreshTime
                    articlesPerPage
            in
            ( { model | appData = updatedAppData }, SaveAppData updatedAppData |> sendInfoOutside )
        
        OnTouchStart touchEvent ->
            ({ model | touchData = (touchEvent.clientX, touchEvent.clientY)}, Cmd.none)

        OpenExcerpt domId ->
        (model, OpenExcerptViaJs domId model.articlePreviewHeight |> sendInfoOutside )

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


closeModal : PanelsState -> PanelsState
closeModal panelsState =
    closePanel (toString PanelModal) panelsState


openModal : PanelsState -> PanelsState
openModal panelsState =
    openPanel (toString PanelModal) panelsState


dateDescending : Article -> Article -> Order
dateDescending article1 article2 =
    case compare article1.date article2.date of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
