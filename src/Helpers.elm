module Helpers exposing (..)

import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site, createEmptySite)
import Msgs exposing (..)
import Transit


getSitesInCategory : Int -> List Site -> List Site
getSitesInCategory categoryId sites =
    List.filter (isSiteInCategory categoryId) sites


isSiteInCategory : Int -> Site -> Bool
isSiteInCategory categoryId site =
    List.any (\siteCategoryId -> siteCategoryId == categoryId) site.categoriesId


isArticleInSites : List Site -> Article -> Bool
isArticleInSites sites article =
    List.any (\site -> site.id == article.siteId) sites


getSelectedArticles : SelectedCategoryId -> SelectedSiteId -> List Site -> List Article -> List Article
getSelectedArticles selectedCategoryId selectedSiteId sites articles =
    let
        sitesInSelectedCategory =
            case selectedCategoryId of
                Just categoryId ->
                    getSitesInCategory categoryId sites

                Nothing ->
                    sites

        articlesSelected =
            case selectedSiteId of
                Just siteId ->
                    getArticlesInSites [ siteId ] articles

                Nothing ->
                    articles
                        |> getArticlesInSites (sitesInSelectedCategory |> extractId)
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
            if selId == id then
                True
            else
                False

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


manageTransitionClass : Transit.Transition -> Bool -> String
manageTransitionClass transition selected =
    let
        transitionStep =
            Transit.getStep transition
    in
    if selected && transitionStep /= Transit.Exit then
        " is-visible is-open"
    else if selected then
        " is-visible"
    else
        ""


isTransitionOver : Transit.Transition -> Bool
isTransitionOver transition =
    Transit.getStep transition == Transit.Done
