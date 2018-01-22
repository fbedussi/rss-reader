module PartialViews.Sidebar exposing (..)

import Helpers exposing (extractSitesId, getSitesInCategory, isArticleInSites)
import Html exposing (Html, a, article, button, div, h2, li, main_, span, text, ul)
import Html.Attributes exposing (class, disabled, href, src)
import Html.Events exposing (onClick)
import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)


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
            , button
                [ class "button" ]
                [ text "refresh" ]
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

        articlesInCategory =
            countArticlesInCategory sitesInCategory model.articles
    in
    li
        [ class ("category " ++ getSelectedClass model.selectedCategoryId category.id) ]
        [ span
            [ class "categoryButtons" ]
            [ button
                [ class "categoryBtn"
                , onClick (SelectCategory category.id)
                ]
                [ span
                    [ class "category-numberOfArticles" ]
                    [ articlesInCategory
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
                    [ class "button"
                    , onClick (ToggleDeleteActions category.id)
                    ]
                    [ span
                        []
                        [ text "delete " ]
                    , span
                        [ class ("delete-actions " ++ getSelectedClass model.categoryToDeleteId category.id) ]
                        [ button
                            [ class "button"
                            , onClick (DeleteCategories [ category.id ])
                            ]
                            [ text "Delete category only" ]
                        , button
                            [ class "button"
                            , onClick (DeleteCategoryAndSites [ category.id ] (extractSitesId sitesInCategory))
                            , disabled
                                (if List.isEmpty sitesInCategory then
                                    True
                                 else
                                    False
                                )
                            ]
                            [ text "Delete sites as well" ]
                        ]
                    ]
                ]
            ]
        , ul
            [ class "category-sitesInCategory" ]
            (sitesInCategory
                |> List.map (renderSiteInCategory model.selectedSiteId)
            )
        ]


renderSiteInCategory : SelectedSiteId -> Site -> Html Msg
renderSiteInCategory selectedSiteId site =
    li
        [ class ("category-siteInCategory " ++ getSelectedClass selectedSiteId site.id) ]
        [ button
            [ class "siteInCategoryBtn"
            , onClick (SelectSite site.id)
            ]
            [ site.name |> text ]
        ]


getSelectedClass : Maybe Int -> Int -> String
getSelectedClass selectedId id =
    case selectedId of
        Just selId ->
            if selId == id then
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
