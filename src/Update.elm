module Update exposing (createNewCategory, createNewSite, update)

import Article exposing (getArticleExcerptDomId, setArticleInnerHeight, toggleArticle)
import Browser.Dom as Dom exposing (focus, getViewportOf)
import Css
import GetFeeds exposing (getFeeds)
import Helpers exposing (closeModal, countNewArticlesInSite, createErrorMsg, dateDescending, delay, getDataToSaveInDb, getNextId, mergeArticles, openModal, sendMsg, toggleSelected)
import Import exposing (executeImport)
import Models exposing (Article, Category, ErrorBoxMsg(..), Id, InfoForOutside(..), Modal, Model, Msg(..), Panel(..), Site, createEmptySite, panelToString)
import Murmur3 exposing (hashString)
import OutsideInfo exposing (sendInfoOutside, switchInfoForElm)
import PanelsManager exposing (PanelsState, closeAllPanels, closePanel, closePanelsFuzzy, getPanelState, initPanel, isPanelOpen, openPanel)
import Swiper
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
            , Task.attempt (OpenTab categoryId) (getViewportOf <| "cat_" ++ String.fromInt categoryId ++ "_inner")
            )

        OpenTab categoryId innerViewport ->
            case innerViewport of
                Ok height ->
                    ( { model | categories = updateCategoriesHeight (round height.viewport.height) categoryId model.categories }, Cmd.none )

                Err notFound ->
                    ( model, Cmd.none )

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
                                        }
                                    )

                        mergedArticles =
                            mergeArticles rssArticles model.articles |> List.sortWith dateDescending

                        ( updatedSites, sitesToResetFailures ) =
                            List.foldl
                                (\site ( updatedSites_, sitesToResetFailures_ ) ->
                                    if site.id == siteId then
                                        let
                                            updatedSite =
                                                { site | numberOfNewArticles = countNewArticlesInSite site.id rssArticles model.lastRefreshTime, numberOfFailures = 0 }

                                            newSitesToResetFailures =
                                                if site.numberOfFailures /= updatedSite.numberOfFailures then
                                                    sitesToResetFailures_ ++ [ updatedSite ]

                                                else
                                                    sitesToResetFailures_
                                        in
                                        ( updatedSites_ ++ [ updatedSite ], newSitesToResetFailures )

                                    else
                                        ( updatedSites_ ++ [ site ], sitesToResetFailures_ )
                                )
                                ( [], [] )
                                model.sites
                    in
                    ( { updatedModel
                        | articles = mergedArticles
                        , sites = updatedSites
                      }
                    , (sitesToResetFailures |> List.map (\site -> UpdateSiteInDb site |> sendInfoOutside))
                        ++ (mergedArticles |> List.map (\article -> Task.attempt (SetArticleInnerHeight article.id) (Dom.getViewportOf <| getArticleExcerptDomId article.id)))
                        |> Cmd.batch
                    )

                Err err ->
                    let
                        failedSite =
                            List.filter (\site -> site.id == siteId) model.sites |> List.head

                        updatedPanelsState =
                            initPanel errorMsg.id model.panelsState

                        errorBaseText =
                            "Error reading feeds for site: "

                        ( updateFailedSiteCmd, errorMsg ) =
                            case failedSite of
                                Just site ->
                                    ( incrementNumberOfFailures model.options.maxNumberOfFailures site |> UpdateSiteInDb |> sendInfoOutside, errorBaseText ++ site.name |> createErrorMsg )

                                Nothing ->
                                    ( Cmd.none, errorBaseText ++ String.fromInt siteId |> createErrorMsg )
                    in
                    ( { updatedModel
                        | panelsState = updatedPanelsState
                        , sites = findSiteAndIncrementNumberOfFailures model.options.maxNumberOfFailures model.sites siteId
                        , errorMsgs = List.filter (\e -> e.id /= errorMsg.id) model.errorMsgs ++ [ errorMsg ]
                      }
                    , Cmd.batch
                        [ delay (millisToPosix 1000) <| ErrorBoxMsg <| OpenErrorMsg errorMsg
                        , delay (millisToPosix 10000) <| ErrorBoxMsg <| RequestRemoveErrorMsg errorMsg
                        , updateFailedSiteCmd
                        ]
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
            ( { model | currentPage = pageNumber }, resetViewport )

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

        ChangeMaxNumberOfFailures newMax ->
            let
                newMaxInt =
                    String.toInt newMax |> Maybe.withDefault Models.defaultOptions.maxNumberOfFailures

                options =
                    model.options

                updatedOptions =
                    { options | maxNumberOfFailures = newMaxInt }
            in
            ( { model | options = updatedOptions }, Cmd.none )

        Swiped evt ->
            let
                ( newState, swipedRight ) =
                    Swiper.hasSwipedRight 100 evt model.swipingState
            in
            ( { model
                | swipingState = newState
                , userSwipedLeft = swipedRight
                , menuOpen = not swipedRight
              }
            , Cmd.none
            )

        ToggleExcerpt articleId domId toOpen ->
            if toOpen then
                ( model, Task.attempt (SetArticleHeight articleId domId toOpen) (Dom.getViewportOf <| getArticleExcerptDomId articleId) )

            else
                ( { model | articles = toggleArticle model.articles articleId toOpen model.options.articlePreviewHeightInEm }, Cmd.none )

        SetArticleHeight articleId domId toOpen viewport ->
            case viewport of
                Ok viewportData ->
                    ( { model | articles = toggleArticle model.articles articleId toOpen viewportData.viewport.height }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        SetArticleInnerHeight articleId viewport ->
            case viewport of
                Ok viewportData ->
                    ( { model | articles = setArticleInnerHeight model.articles articleId viewportData.viewport.height }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        ErrorBoxMsg errorBoxMsg ->
            handleErrorBoxMsgs model errorBoxMsg

        SignOut ->
            ( model, SignOutViaJs |> sendInfoOutside )

        ScrollToTop ->
            ( model, resetViewport )

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
        0


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
        True
        0


updateCategoriesHeight : Int -> Id -> List Category -> List Category
updateCategoriesHeight height id categories =
    categories
        |> List.map
            (\category ->
                let
                    newHeight =
                        if category.id == id then
                            height

                        else
                            0
                in
                { category | height = newHeight }
            )


incrementNumberOfFailures : Int -> Site -> Site
incrementNumberOfFailures maxNumberOfFailures site =
    let
        newNumberOfFailures =
            site.numberOfFailures + 1
    in
    { site
        | numberOfFailures = newNumberOfFailures
        , isActive =
            if newNumberOfFailures > maxNumberOfFailures then
                False

            else
                site.isActive
    }


findSiteAndIncrementNumberOfFailures : Int -> List Site -> Id -> List Site
findSiteAndIncrementNumberOfFailures maxNumberOfFailures sites siteId =
    List.map
        (\site ->
            if site.id == siteId then
                incrementNumberOfFailures maxNumberOfFailures site

            else
                site
        )
        sites


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
