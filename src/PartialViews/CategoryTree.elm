module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Accordion exposing (closeTab, openTab)
import Css exposing (auto, backgroundColor, em, fill, flexShrink, height, int, marginRight, middle, verticalAlign, pct, width, displayFlex)
import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites, isSelected)
import Html.Styled exposing (Html, a, article, button, div, h2, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site, Selected)
import Msgs exposing (..)
import PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)
import PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon, folderIcon)
import PartialViews.UiKit exposing (badge, categoryWrapper, input, sidebarRow, sidebarSelectionBtn, tabContentOuter, theme)


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

        sitesInCategory =
            getSitesInCategory category.id model.sites

        articlesInCategory =
            countArticlesInCategory sitesInCategory model.articles
    in
    categoryWrapper
        [ class "tab"
        , id domId
        ]
        [ deleteActions model.transitionStore category (extractId sitesInCategory)
        , sidebarRow selected
            [ class "tabTitle" ]
            (case model.categoryToEditId of
                Just categoryToEditId ->
                    if categoryToEditId == category.id then
                        renderEditCategory category
                    else
                        renderCaregoryName category selected articlesInCategory

                Nothing ->
                    renderCaregoryName category selected articlesInCategory
            )
        , tabContentOuter selected
            [ class "tabContentOuter" ]
            [ styled ul
                []
                [ class "category-sitesInCategory tabContentInner" ]
                (sitesInCategory
                    |> List.map (renderSiteEntry model.selectedSiteId)
                )
            ]
        ]

renderCaregoryName : Category -> Selected -> Int -> List (Html Msg)
renderCaregoryName category selected articlesInCategory =
    [ sidebarSelectionBtn
        [ class "categoryBtn"
        , onClick <| ToggleSelectedCategory category.id
        ]
        [ styled span
            [ verticalAlign middle
            , marginRight (em 0.5)
            ]
            [ class "icon folderIcon" ]
            [ folderIcon [ Css.fill theme.colorPrimary ] selected
            ]
        , badge
            [ class "category-numberOfArticles" ]
            [ articlesInCategory
                |> toString
                |> text
            ]
        , styled span
            [ verticalAlign middle ]
            [ class "category-name" ]
            [ text (" " ++ category.name) ]
        ]
    ]
        ++ (if selected then
                [ span
                    [ class "category-action" ]
                    [ iconButtonNoStyle (editIcon [ fill theme.white ]) ( "edit", False ) [ onClick <| EditCategoryId category.id ]
                    , iconButtonNoStyle (deleteIcon [ fill theme.white ]) ( "delete", False ) [ onClick <| ToggleDeleteActions category.id ]
                    ]
                ]
            else
                []
           )


renderEditCategory : Category -> List (Html Msg)
renderEditCategory category =
    [ styled div
        [ displayFlex
        , width (pct 100)]
        [ class "editCategoryName" ]
        [ styled input
            [ Css.flex (Css.int 1) ]
            [ class "editCategoryName-input"
            , id <| "editCategoryName-" ++ toString category.id
            , value category.name
            , onInput <| UpdateCategoryName category.id
            ]
            []
        , iconButton (checkIcon []) ( "ok", False ) [ onClick EndCategoryEditing ]
        ]
    ]


renderSiteEntry : SelectedSiteId -> Site -> Html Msg
renderSiteEntry selectedSiteId site =
    let
        selected =
            isSelected selectedSiteId site.id
    in
    li
        [ class "category-siteInCategory " ]
        [ sidebarRow selected
            []
            ([ sidebarSelectionBtn
                [ class "siteInCategoryBtn"
                , onClick <| SelectSite site.id
                ]
                [ site.name |> text ]
             ]
                ++ (if selected then
                        [ renderSiteButtons site.id ]
                    else
                        []
                   )
            )
        ]


renderSiteButtons : Id -> Html Msg
renderSiteButtons siteId =
    styled span
        [ flexShrink (int 0) ]
        [ class "siteInCategory-actions button-group" ]
        [ iconButtonNoStyle (editIcon [ fill theme.white ]) ( "edit", False ) [ onClick <| ChangeEditSiteId <| Just siteId ]
        , iconButtonNoStyle (deleteIcon [ fill theme.white ]) ( "delete", False ) [ onClick <| DeleteSites [ siteId ] ]
        ]


countArticlesInCategory : List Site -> List Article -> Int
countArticlesInCategory sitesInCategory articles =
    let
        articlesInCategory =
            List.filter (isArticleInSites sitesInCategory) articles
    in
    List.length articlesInCategory
