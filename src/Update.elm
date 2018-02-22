module Update exposing (..)

import Dom exposing (focus)
import GetFeeds exposing (getFeeds)
import Helpers exposing (getNextId, mergeArticles)
import Import exposing (executeImport)
import Models exposing (Article, Category, Id, Model, Site, Msg(..), InfoForOutside(..), Modal)
import Murmur3 exposing (hashString)
import OutsideInfo exposing (sendInfoOutside, switchInfoForElm)
import Task
import PanelsManager exposing (PanelsOpen, closeAllPanels, openPanel, closePanel, isPanelOpen)

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
            ( { model | keyboardNavigation = if keyCode == 9 then True else False }, Cmd.none )
        
        ToggleSelectedCategory categoryId ->
            let
                newSelectedCategoryId = 
                    case model.selectedCategoryId of
                        Nothing ->
                            Just categoryId

                        Just id -> 
                            if id == categoryId
                            then
                                Nothing
                            else 
                                Just categoryId
            in
            ({ model
                | selectedCategoryId = newSelectedCategoryId
                , selectedSiteId = Nothing
            }                
            , Cmd.none
            )

        SelectSite siteId ->
            ( { model | selectedSiteId = Just siteId }, Cmd.none )

        ToggleDeleteActions categoryId ->
            --toggleState ({ model | selectedCategoryId = Just categoryId }) "cat"  (toString categoryId) TransitionStart TransitionEnd model.defaultTransitionDuration
            (model, Cmd.none)

        ToggleImportLayer ->
            let
                updatedPanelsOpen = 
                    if isPanelOpen "import" model.panelsOpen
                    then closePanel "import"
                    else openPanel "import"
            in
            ({model | panelsOpen = updatedPanelsOpen }, Cmd.none)


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
                modalData = Modal
                    True
                    "Are you sure you want to delete this category?"
                    (DeleteCategories categoryToDeleteIds)
                
            in
            ({model 
                | modal = modalData
                , panelsOpen = openModal model.panelsOpen
            }, Cmd.none)
        
        DeleteCategories categoryToDeleteIds ->
            let
                updatedCategories =
                    deleteContents model.categories categoryToDeleteIds
            in
            ( { model
                | categories = updatedCategories
                , panelsOpen = closeModal model.panelsOpen
              }
            , DeleteCategoriesInDb categoryToDeleteIds |> sendInfoOutside )

        RequestDeleteSites sitesToDeleteId ->
            let
                modalData = Modal
                    True
                    "Are you sure you want to delete this site?"
                    (DeleteSites sitesToDeleteId)
                
            in
            ({model 
                | modal = modalData
                , panelsOpen = openModal model.panelsOpen
            }, Cmd.none)
    
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
                , panelsOpen = closeModal model.panelsOpen
              }
            , Cmd.batch
                [ DeleteSitesInDb sitesToDeleteId |> sendInfoOutside
                , DeleteArticlesInDb articleToDeleteInDbIds |> sendInfoOutside
                ]
            )

        RequestDeleteCategoryAndSites categoryToDeleteIds sitesToDeleteId ->
            let
                modalData = Modal
                    True
                    "Are you sure you want to delete this category and all its sites?"
                    (DeleteCategoryAndSites categoryToDeleteIds sitesToDeleteId)
                
            in
            ({model
                | modal = modalData
                , panelsOpen = openModal model.panelsOpen
            }, Cmd.none)

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
                , panelsOpen = closeModal model.panelsOpen
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

        ChangeEditSiteId siteId ->
            ({ model 
                | siteToEditId = siteId 
                , panelsOpen = openModal model.panelsOpen
            }, Cmd.none)

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
            let
                updatedModel = {model | fetchingRss = False}
            in
            case rssResult of
                Ok feeds ->
                    let
                        rssArticles =
                            feeds
                                |> List.map (\article -> { article | id = hashString 12345 article.link })
                    in
                    ( { updatedModel | articles = mergeArticles rssArticles model.articles }, Cmd.none )

                Err err ->
                    ( { updatedModel | errorMsgs = model.errorMsgs ++ [ err ] }, Cmd.none )

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
            ( {model | fetchingRss = True}, getFeeds model.sites |> Cmd.batch )

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

        CloseAllPanels ->
            ( { model | panelsOpen = (True,[]) }, Cmd.none )

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


closeModal : PanelsOpen -> PanelsOpen
closeModal panelsOpen = 
    closePanel "modal" panelsOpen


openModal : PanelsOpen -> PanelsOpen
openModal panelsOpen = 
    openPanel "modal" panelsOpen