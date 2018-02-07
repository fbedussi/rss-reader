module PartialViews.CategoryTree exposing (deleteSiteButton, renderCategory, renderSiteEntry)

import DOM exposing (..)
import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites, isSelected, manageTransitionClass)
import Html exposing (Html, a, article, button, div, h2, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode exposing (Decoder)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryButtons exposing (categoryButtons)


renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    li
        [ class ("accordion-item category " ++ getClass "is-active" model.selectedCategoryId category.id)
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


onHeaderClick : (Float -> msg) -> Html.Attribute msg
onHeaderClick msg =
    on "click" (Json.Decode.map msg targetHeight)



-- A `Json.Decoder` for grabbing `event.target.currentTime`.


targetHeight : Decoder Float
targetHeight =
    target <| parentElement <| parentElement <| nextSibling <| childNode 0 offsetHeight


renderViewCategory : Model -> Category -> List (Html Msg)
renderViewCategory model category =
    let
        sitesInCategory =
            getSitesInCategory category.id model.sites

        articlesInCategory =
            countArticlesInCategory sitesInCategory model.articles

        deleting =
            isSelected model.categoryToDeleteId category.id
    in
    [ div
        [ class ("delete-actions" ++ manageTransitionClass model.transition deleting) ]
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
    , span
        [ class "categoryButtons accordion-title" ]
        [ button
            [ class "categoryBtn"
            , onHeaderClick (SelectCategory category.id)
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
        [ div
            [ class "accordion-content-inner" ]
            (sitesInCategory
                |> List.map (renderSiteEntry model.selectedSiteId)
            )
        ]
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
