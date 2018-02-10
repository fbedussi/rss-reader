module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Accordion exposing (closeTab, openTab)
import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites, isSelected, manageTransitionClass)
import Html exposing (Html, a, article, button, div, h2, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryButtons exposing (categoryButtons)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon)


renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    let
        domId =
            "cat_" ++ toString category.id

        selected =
            isSelected model.selectedCategoryId category.id

        triggerOpenTab =
            if selected then
                openTab ("#" ++ domId)
            else
                closeTab ("#" ++ domId)
    in
    li
        [ class
            ("accordion-item category "
                ++ (if selected then
                        "is-selected"
                    else
                        ""
                   )
            )
        , attribute "data-accordion-item" ""
        , id domId
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

        deleting =
            isSelected model.categoryToDeleteId category.id

        domId =
            "cat_" ++ toString category.id
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
    , div
        [ class "tabContentOuter" ]
        [ ul
            [ class "category-sitesInCategory tabContentInner" ]
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
        , iconButton checkIcon ( "ok", False ) [ onClick EndCategoryEditing ]
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
        [ iconButton editIcon ( "edit", False ) [ onClick (ChangeEditSiteId siteId) ]
        , iconButton deleteIcon ( "delete", False ) [ onClick (DeleteSites [ siteId ]) ]
        ]


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


selectCategory : Id -> String -> Msg
selectCategory id domSelector =
    let
        triggerOpenTab =
            openTab domSelector

        log =
            Debug.log "domSelector2" domSelector
    in
    SelectCategory id
