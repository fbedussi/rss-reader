module Helpers exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (keyCode, on)
import Json.Decode as Json
import Models exposing (Article, Category, Id, Model, Msg, Panel(..), SelectedCategoryId, SelectedSiteId, Site, createEmptySite)
import PanelsManager exposing (PanelsState, closePanel, openPanel)
import Process
import Task
import Time exposing (Time)


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
        site =
            sites |> List.filter (\site -> site.id == article.siteId) |> List.head
    in
    case site of
        Just site ->
            site

        Nothing ->
            createEmptySite


getSiteToEdit : Id -> List Site -> Maybe Site
getSiteToEdit siteToEditId sites =
    sites |> List.filter (\site -> site.id == siteToEditId) |> List.head


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


sendMsg : Msg -> Cmd Msg
sendMsg msg =
    Task.perform (\_ -> msg) (Task.succeed 0)


closeModal : PanelsState -> PanelsState
closeModal panelsState =
    closePanel (toString PanelModal) panelsState


openModal : PanelsState -> PanelsState
openModal panelsState =
    openPanel (toString PanelModal) panelsState


getDataToSaveInDb : Model -> ( List Category, List Site, List Article )
getDataToSaveInDb model =
    ( model.categories, model.sites, model.articles |> List.filter (\article -> article.starred) )


dateDescending : Article -> Article -> Order
dateDescending article1 article2 =
    case compare article1.date article2.date of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


toggleSelected : List { c | id : b, isSelected : a } -> b -> List { c | id : b, isSelected : Bool }
toggleSelected items id =
    items
        |> List.map
            (\item ->
                if item.id == id then
                    { item | isSelected = True }
                else
                    { item | isSelected = False }
            )


countNewArticlesInSite : Id -> List Article -> Time -> Int
countNewArticlesInSite siteId articles lastRefreshTime =
    articles
        |> List.filter (\article -> lessThanOneDayDifference article.date lastRefreshTime && (article.siteId == siteId))
        |> List.length

lessThanOneDayDifference : Time -> Time -> Bool
lessThanOneDayDifference newerTime olderTime =
    let
        difference =
            newerTime - olderTime
    in
    difference > 0 && difference < 1000 * 60 * 60 * 25
