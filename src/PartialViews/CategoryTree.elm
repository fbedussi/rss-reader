module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Helpers exposing (extractId, getSitesInCategory, isArticleInSites)
import Html exposing (Html, a, article, button, div, h2, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)


renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    li
        [ class ("accordion-item category " ++ getSelectedClass model.selectedCategoryId category.id)
        , attribute "data-accordion-item" ""
        ]
        (case model.categoryToEditId of
            Just categoryToEditId ->
                if categoryToEditId == category.id then
                    renderEditCategory model category
                else
                    renderViewCategory model category

            Nothing ->
                renderViewCategory model category
        )


renderViewCategory : Model -> Category -> List (Html Msg)
renderViewCategory model category =
    let
        sitesInCategory =
            getSitesInCategory category.id model.sites

        articlesInCategory =
            countArticlesInCategory sitesInCategory model.articles
    in
    [ span
        [ class "categoryButtons accordion-title" ]
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
                [ class "button"
                , onClick (EditCategoryId category.id)
                ]
                [ text "edit " ]
            , span
                [ class "deleteButtonsWrapper" ]
                [ button
                    [ class "button"
                    , onClick (ToggleDeleteActions category.id)
                    ]
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
                        , onClick (DeleteCategoryAndSites [ category.id ] (extractId sitesInCategory))
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
        [ class "accordion-content category-sitesInCategory"
        , attribute "data-tab-content" ""
        ]
        (sitesInCategory
            |> List.map (renderSiteEntry model.selectedSiteId)
        )
    ]


renderEditCategory : Model -> Category -> List (Html Msg)
renderEditCategory model category =
    [ span
        [ class "editCategoryName accordion-title" ]
        [ input
            [ class "editCategoryName-input"
            , id ("editCategoryName-" ++ toString category.id)
            , value category.name
            , onInput (UpdateCategoryName category.id)
            ]
            []
        , button
            [ class "button editCategoryName-button"
            , onClick EndCategoryEditing
            ]
            [ text "ok" ]
        ]
    ]


renderSiteEntry : SelectedSiteId -> Site -> Html Msg
renderSiteEntry selectedSiteId site =
    li
        [ class ("category-siteInCategory " ++ getSelectedClass selectedSiteId site.id) ]
        [ button
            [ class "siteInCategoryBtn"
            , onClick (SelectSite site.id)
            ]
            [ site.name |> text ]
        , span
            [ class "siteInCategory-actions button-group" ]
            [ button
                [ class "button"
                , onClick (ChangeEditSiteId site.id)
                ]
                [ text "Edit site" ]
            , button
                [ class "button"
                , onClick (DeleteSites [ site.id ])
                ]
                [ text "Delete site" ]
            ]
        ]


getSelectedClass : Maybe Int -> Int -> String
getSelectedClass selectedId id =
    case selectedId of
        Just selId ->
            if selId == id then
                "is-active"
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
