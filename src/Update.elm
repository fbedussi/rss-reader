module Update exposing (createNewCategory, createNewSite, update)

import Browser.Dom exposing (focus)
import GetFeeds exposing (getFeeds)
import Helpers exposing (closeModal, countNewArticlesInSite, dateDescending, delay, getDataToSaveInDb, getNextId, mergeArticles, openModal, sendMsg, toggleSelected)
import Import exposing (executeImport)
import Models exposing (Article, Category, ErrorBoxMsg(..), Id, InfoForOutside(..), Modal, Model, Msg(..), Panel(..), Site, createEmptySite, panelToString)
import Murmur3 exposing (hashString)
import OutsideInfo exposing (sendInfoOutside, switchInfoForElm)
import PanelsManager exposing (PanelsState, closeAllPanels, closePanel, closePanelsFuzzy, getPanelState, initPanel, isPanelOpen, openPanel)
import Task
import Time exposing (millisToPosix)
import Update.Delete exposing (handleDeleteMsgs)
import Update.EditCategory exposing (handleEditCategoryMsgs)
import Update.EditSite exposing (handleEditSiteMsgs)
import Update.ErrorBox exposing (handleErrorBoxMsgs)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetMouseNavigation ->
            ( { model | keyboardNavigation = False }, Cmd.none )

        VerifyKeyboardNavigation keyCode ->
            ( { model | keyboardNavigation = keyCode == '\t' }, Cmd.none )

        ToggleSelectedCategory categoryId ->
            ( { model
                | categories = toggleSelected model.categories categoryId
                , currentPage = 1
                , sites = model.sites |> List.map (\site -> { site | isSelected = False })
              }
            , Cmd.none
            )

        ToggleSelectSite siteId ->
            ( { model
                | sites = toggleSelected model.sites siteId
                , currentPage = 1
              }
            , Cmd.none
            )

        ToggleDeleteActions categoryId ->
            let
                panelId =
                    "cat_" ++ String.fromInt categoryId

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
                    getPanelState (panelToString panel) model.panelsState |> isPanelOpen

                updatedPanelsState =
                    if isOpen then
                        closePanel (panelToString panel) model.panelsState

                    else
                        openPanel (panelToString panel) model.panelsState
            in
            ( { model | panelsState = updatedPanelsState }, Cmd.none )

        ToggleMenu ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        CloseMenu ->
            ( { model | menuOpen = False }, Cmd.none )

        OpenImportPanel ->
            ( { model | panelsState = model.panelsState |> closePanel (panelToString PanelSettings) |> openPanel (panelToString PanelImport) }, Cmd.none )

        StoreImportData importData ->
            ( { model | importData = importData }, Cmd.none )

        ExecuteImport ->
            let
                newModel =
                    executeImport model
            in
            ( newModel, getDataToSaveInDb newModel |> SaveAllData |> sendInfoOutside )

        DeleteMsg msgToDelete ->
            handleDeleteMsgs model msgToDelete

        AddNewCategory ->
            let
                newCategory =
                    createNewCategory model.categories
            in
            ( { model
                | categories = List.append model.categories [ newCategory ]
              }
            , Cmd.batch
                [ focus ("editCategoryName-" ++ String.fromInt newCategory.id) |> Task.attempt (\_ -> NoOp)
                , AddCategoryInDb newCategory |> sendInfoOutside
                ]
            )

        EditCategoryMsg editCategoryMsg ->
            handleEditCategoryMsgs model editCategoryMsg

        EditSiteMsg editSiteMsg ->
            handleEditSiteMsgs model editSiteMsg

        AddNewSite ->
            let
                newSite =
                    createNewSite model.sites
            in
            ( { model
                | sites = List.append model.sites [ newSite ]
                , siteToEditForm = newSite
                , panelsState = openPanel (panelToString PanelEditSite) model.panelsState
              }
            , AddSiteInDb newSite |> sendInfoOutside
            )

        GetArticles siteId rssResult ->
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
                                        }
                                    )

                        mergedArticles =
                            mergeArticles rssArticles model.articles

                        updatedSites =
                            model.sites
                                |> List.map
                                    (\site ->
                                        if site.id == siteId then
                                            { site | numberOfNewArticles = countNewArticlesInSite site.id rssArticles model.lastRefreshTime }

                                        else
                                            site
                                    )
                    in
                    ( { updatedModel
                        | articles = List.sortWith dateDescending mergedArticles
                        , sites = updatedSites
                      }
                    , InitReadMoreButtons |> sendInfoOutside
                    )

                Err err ->
                    let
                        errorMsgId =
                            hashString 1234 err |> String.fromInt

                        updatedPanelsState =
                            initPanel errorMsgId model.panelsState
                    in
                    ( { updatedModel
                        | panelsState = updatedPanelsState
                        , errorMsgs = List.filter (\errorMsg -> errorMsg /= err) model.errorMsgs ++ [ err ]
                      }
                    , delay (millisToPosix 1000) <| ErrorBoxMsg <| OpenErrorMsg errorMsgId
                    )

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
            ( model, SaveLastRefreshedTime time |> sendInfoOutside )

        Outside infoForElm ->
            switchInfoForElm infoForElm model

        UpdateSearch searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        CloseAllPanels ->
            ( { model
                | panelsState = closeAllPanels model.panelsState
                , menuOpen = False
              }
            , Cmd.none
            )

        ChangePage pageNumber ->
            ( { model | currentPage = pageNumber }, ScrollToTopViaJs |> sendInfoOutside )

        ChangeNumberOfArticlesPerPage newArticlesPerPage ->
            let
                options =
                    model.options

                updatedOptions =
                    { options | articlesPerPage = newArticlesPerPage }
            in
            ( { model
                | options = updatedOptions
              }
            , SaveOptions updatedOptions |> sendInfoOutside
            )

        ChangePreviewHeight rows ->
            let
                options =
                    model.options

                updatedOptions =
                    { options | articlePreviewHeightInEm = String.toFloat rows |> Maybe.withDefault options.articlePreviewHeightInEm }
            in
            ( { model | options = updatedOptions }, Cmd.none )

        -- OnTouchStart touchEvent ->
        --     ( { model | touchData = ( touchEvent.clientX, touchEvent.clientY ) }, Cmd.none )
        ToggleExcerpt articleId domId toOpen ->
            let
                updatedArticles =
                    model.articles
                        |> List.map
                            (\article ->
                                if article.id == articleId then
                                    { article | isOpen = toOpen }

                                else
                                    article
                            )
            in
            ( { model | articles = updatedArticles }, ToggleExcerptViaJs domId toOpen model.options.articlePreviewHeightInEm |> sendInfoOutside )

        ScrollToTop ->
            ( model, ScrollToTopViaJs |> sendInfoOutside )

        ErrorBoxMsg errorBoxMsg ->
            handleErrorBoxMsgs model errorBoxMsg

        SignOut ->
            ( model, SignOutViaJs |> sendInfoOutside )

        NoOp ->
            ( model, Cmd.none )


createNewCategory : List Category -> Category
createNewCategory categories =
    let
        nextId =
            getNextId categories
    in
    Category
        nextId
        "New Category"
        True
        True


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
        False
        0
