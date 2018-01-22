module View exposing (..)

import Html exposing (Html, a, article, button, div, h2, li, main_, span, text, ul)
import Html.Attributes exposing (class, href, src)
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "appWrapper grid-x" ]
        [ sidebar model
        , mainContent model
        ]


sidebar : Model -> Html Msg
sidebar model =
    div
        [ class "sidebar cell medium-3" ]
        [ div
            [ class "button-group" ]
            [ button
                [ class "button" ]
                [ text "add new category" ]
            , button
                [ class "button" ]
                [ text "add new site" ]
            ]
        , ul
            [ class "categories" ]
            (model.categories
                |> List.map (renderCategory model)
            )
        ]


renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    let
        sitesInCategory =
            getSitesInCategory category.id model.sites
    in
    li
        [ class ("category " ++ getSelectedCategoryClass model.selectedCategoryId category) ]
        [ button
            [ class "categoryBtn" ]
            [ span
                [ class "category-numberOfArticles" ]
                [ countArticlesInCategory sitesInCategory model.articles
                    |> toString
                    |> addParenthesis
                    |> text
                ]
            , span
                [ class "category-name" ]
                [ text category.name ]
            ]
        , span
            [ class "category-action button-group" ]
            [ button
                [ class "button" ]
                [ text "edit " ]
            , button
                [ class "button" ]
                [ text "delete " ]
            ]
        , ul
            [ class "category-sitesInCategory" ]
            (sitesInCategory
                |> List.map renderSiteInCategory
            )
        ]


renderSiteInCategory : Site -> Html Msg
renderSiteInCategory site =
    li
        [ class "category-siteInCategory" ]
        [ button
            [ class "siteInCategoryBtn" ]
            [ site.name |> text ]
        ]


getSitesInCategory : Int -> List Site -> List Site
getSitesInCategory categoryId =
    List.filter (isSiteInCategory categoryId)


getSelectedCategoryClass : Maybe Int -> Category -> String
getSelectedCategoryClass selectedCategoryId category =
    case selectedCategoryId of
        Just categoryId ->
            if categoryId == category.id then
                "selected"
            else
                ""

        Nothing ->
            ""


addParenthesis : String -> String
addParenthesis string =
    "(" ++ string ++ ")"


countArticlesInCategory : List Site -> List Article -> Int
countArticlesInCategory sitesInCategory articles =
    let
        articlesInCategory =
            List.filter (isArticleInSites sitesInCategory) articles
    in
    List.length articlesInCategory


isSiteInCategory : Int -> Site -> Bool
isSiteInCategory categoryId site =
    List.any (\siteCategoryId -> siteCategoryId == categoryId) site.categoriesId


isArticleInSites : List Site -> Article -> Bool
isArticleInSites sites article =
    List.any (\site -> site.id == article.siteId) sites


mainContent : Model -> Html Msg
mainContent model =
    main_
        [ class "mainContent cell medium-9" ]
        [ ul
            [ class "selectedArticles" ]
            (getSelectedArticles model.selectedCategoryId model.selectedSiteId model.sites model.articles
                |> List.map renderArticle
            )
        ]


getSelectedArticles : Maybe Int -> Maybe Int -> List Site -> List Article -> List Article
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
                        |> getArticlesInSites (sitesInSelectedCategory |> extractSitesId)
    in
    articlesSelected


extractSitesId : List Site -> List Int
extractSitesId =
    List.map (\site -> site.id)


getArticlesInSites : List Int -> List Article -> List Article
getArticlesInSites sitesId =
    List.filter (\article -> List.any (\siteId -> siteId == article.siteId) sitesId)


renderArticle : Article -> Html Msg
renderArticle articleToRender =
    let
        starredLabel =
            if articleToRender.starred then
                "starred"
            else
                ""
    in
    li
        []
        [ article
            [ class "article" ]
            [ h2
                [ class "article-title" ]
                [ a
                    [ class "article-link"
                    , href articleToRender.link
                    ]
                    [ articleToRender.title |> text ]
                , span
                    [ class "article-starred" ]
                    [ starredLabel |> text ]
                ]
            , div
                [ class "article-excerpt" ]
                [ articleToRender.excerpt |> text ]
            ]
        ]
