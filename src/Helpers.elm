module Helpers exposing (closeModal, countNewArticlesInSite, createErrorMsg, dateDescending, delay, extractId, getArticleSite, getArticlesInSites, getClass, getDataToSaveInDb, getInnerTabId, getMaxId, getNextId, getOuterTabId, getSelectedArticles, getSiteToEdit, getSitesInCategories, idPrefix, incrementMaxId, isArticleInSites, isSelected, isSiteInCategories, lessThanOneDayDifference, mergeArticles, onKeyDown, openModal, sendMsg, toggleSelected)

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (keyCode, on)
import Http
import Json.Decode as Json
import Models exposing (Article, Category, ErrorMsg, Id, Model, Msg, Panel(..), SelectedCategoryId, SelectedSiteId, Site, createEmptySite, panelToString)
import Murmur3 exposing (hashString)
import PanelsManager exposing (PanelsState, closePanel, openPanel)
import Process
import Task
import Time exposing (posixToMillis)


getSitesInCategories : List Id -> List Site -> List Site
getSitesInCategories categoryIds sites =
    List.filter (isSiteInCategories categoryIds) sites


isSiteInCategories : List Id -> Site -> Bool
isSiteInCategories categoryIds site =
    site.categoriesId
        |> List.any (\siteCategoryId -> List.member siteCategoryId categoryIds)


isArticleInSites : List Site -> Article -> Bool
isArticleInSites sites article =
    List.any (\site -> site.id == article.siteId) sites


getSelectedArticles : List Category -> List Site -> List Article -> List Article
getSelectedArticles categories sites articles =
    let
        selectedCategories =
            categories
                |> List.filter (\category -> category.isSelected)

        sitesInSelectedCategory =
            if List.isEmpty selectedCategories then
                sites

            else
                getSitesInCategories (extractId selectedCategories) sites

        selectedSiteIds =
            sites
                |> List.filter (\site -> site.isSelected)
                |> extractId

        articlesSelected =
            if List.isEmpty selectedSiteIds then
                articles
                    |> getArticlesInSites (sitesInSelectedCategory |> extractId)

            else
                getArticlesInSites selectedSiteIds articles
    in
    articlesSelected


extractId : List { a | id : Int } -> List Int
extractId =
    List.map (\entity -> entity.id)


getMaxId : List Int -> Maybe Int
getMaxId ids =
    List.sort ids
        |> List.reverse
        |> List.head


incrementMaxId : Maybe Int -> Int
incrementMaxId maxId =
    case maxId of
        Just id ->
            id + 1

        Nothing ->
            1


getNextId : List { a | id : Int } -> Int
getNextId entities =
    extractId entities
        |> getMaxId
        |> incrementMaxId


getArticlesInSites : List Int -> List Article -> List Article
getArticlesInSites sitesId articles =
    articles
        |> List.filter (\article -> List.any (\siteId -> siteId == article.siteId) sitesId)


mergeArticles : List Article -> List Article -> List Article
mergeArticles baseArticles overrideArticles =
    let
        overrideArticleIds =
            extractId overrideArticles

        filteredBaseArticles =
            List.filter (\baseArticle -> not (List.member baseArticle.id overrideArticleIds)) baseArticles
    in
    List.append overrideArticles filteredBaseArticles


getClass : String -> Maybe Int -> Int -> String
getClass class selectedId id =
    case selectedId of
        Just selId ->
            if selId == id then
                class

            else
                ""

        Nothing ->
            ""


isSelected : Maybe Int -> Int -> Bool
isSelected selectedId id =
    case selectedId of
        Just selId ->
            selId == id

        Nothing ->
            False


getArticleSite : List Site -> Article -> Site
getArticleSite sites article =
    let
        selectedSite =
            sites |> List.filter (\site -> site.id == article.siteId) |> List.head
    in
    case selectedSite of
        Just site ->
            site

        Nothing ->
            createEmptySite


getSiteToEdit : Id -> List Site -> Maybe Site
getSiteToEdit siteToEditId sites =
    sites |> List.filter (\site -> site.id == siteToEditId) |> List.head


delay : Time.Posix -> msg -> Cmd msg
delay time msg =
    Process.sleep (posixToMillis time |> toFloat)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


onKeyDown : (Char -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map (\code -> tagger (Char.fromCode code)) keyCode)


sendMsg : Msg -> Cmd Msg
sendMsg msg =
    Task.perform (\_ -> msg) (Task.succeed 0)


closeModal : PanelsState -> PanelsState
closeModal panelsState =
    closePanel (panelToString PanelModal) panelsState


openModal : PanelsState -> PanelsState
openModal panelsState =
    openPanel (panelToString PanelModal) panelsState


getDataToSaveInDb : Model -> ( List Category, List Site, List Article )
getDataToSaveInDb model =
    ( model.categories, model.sites, model.articles |> List.filter (\article -> article.starred) )


dateDescending : Article -> Article -> Order
dateDescending article1 article2 =
    case compare (Time.posixToMillis article1.date) (Time.posixToMillis article2.date) of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


toggleSelected : List { c | id : b, isSelected : Bool } -> b -> List { c | id : b, isSelected : Bool }
toggleSelected items id =
    items
        |> List.map
            (\item ->
                if item.id == id then
                    { item | isSelected = not item.isSelected }

                else
                    { item | isSelected = False }
            )


countNewArticlesInSite : Id -> List Article -> Time.Posix -> Int
countNewArticlesInSite siteId articles lastRefreshTime =
    articles
        |> List.filter (\article -> (article.siteId == siteId) && lessThanOneDayDifference article.date lastRefreshTime)
        |> List.length


lessThanOneDayDifference : Time.Posix -> Time.Posix -> Bool
lessThanOneDayDifference articleDate lastRefreshTime =
    let
        difference =
            abs (posixToMillis articleDate - posixToMillis lastRefreshTime)
    in
    difference < 1000 * 60 * 60 * 25


createErrorMsg : String -> ErrorMsg
createErrorMsg text =
    { id = hashString 1234 text |> String.fromInt
    , text = text
    }


idPrefix =
    "cat_"


getOuterTabId : Id -> String
getOuterTabId categoryId =
    idPrefix ++ String.fromInt categoryId


getInnerTabId : Id -> String
getInnerTabId categoryId =
    idPrefix ++ String.fromInt categoryId ++ "_inner"
