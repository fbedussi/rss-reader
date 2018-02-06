module PartialViews.CategoryTree exposing (deleteSiteButton, renderCategory, renderSiteEntry)

import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites)
import Html exposing (Html, a, article, button, div, h2, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryButtons exposing (categoryButtons)


renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    li
        [ class ("accordion-item category " ++ getClass "is-selected" model.selectedCategoryId category.id)
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
                [ class "category-numberOfArticles badge primary" ]
                [ articlesInCategory
                    |> toString
                    |> text
                ]
            , span
                [ class "category-name" ]
                [ text (" " ++ category.name) ]
            ]
        , categoryButtons model category sitesInCategory
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
        [ class ("category-siteInCategory " ++ getClass "is-selected" selectedSiteId site.id) ]
        [ button
            [ class "siteInCategoryBtn"
            , onClick (SelectSite site.id)
            ]
            [ site.name |> text ]
        , renderSiteButtons site.id
        ]


renderSiteButtons : Id -> Html Msg
renderSiteButtons siteId =
    span
        [ class "siteInCategory-actions button-group" ]
        [ button
            [ class "button"
            , onClick (ChangeEditSiteId siteId)
            ]
            [ text "Edit" ]
        , deleteSiteButton siteId
        ]


deleteSiteButton : Id -> Html Msg
deleteSiteButton siteId =
    button
        [ class "button alert"
        , onClick (DeleteSites [ siteId ])
        ]
        [ text "Delete" ]


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
