module Helpers exposing (..)

import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site)


getSitesInCategory : Int -> List Site -> List Site
getSitesInCategory categoryId =
    List.filter (isSiteInCategory categoryId)


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
getArticlesInSites sitesId =
    List.filter (\article -> List.any (\siteId -> siteId == article.siteId) sitesId)
