module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Css exposing (auto, backgroundColor, batch, displayFlex, em, fill, flexShrink, height, int, marginRight, middle, pct, verticalAlign, width)
import Helpers exposing (extractId, getClass, getInnerTabId, getOuterTabId, getSitesInCategories, isArticleInSites, isSelected)
import Html
import Html.Styled exposing (Html, a, article, button, div, h2, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import Html.Styled.Lazy exposing (lazy)
import Models exposing (Article, Category, DeleteMsg(..), EditCategoryMsg(..), EditSiteMsg(..), Id, Model, Msg(..), Selected, Site)
import PanelsManager exposing (PanelsState, getPanelClass, getPanelState)
import PartialViews.DeleteActions exposing (deleteActions)
import PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon, folderIcon)
import PartialViews.UiKit exposing (badge, categoryWrapper, customCss, input, sidebarRow, sidebarSelectionBtn, tabContentOuter, theme)


renderCategory : List Site -> PanelsState -> Category -> Html Msg
renderCategory sites panelsState category =
    let
        domId =
            getOuterTabId category.id

        sitesInCategory =
            getSitesInCategories [ category.id ] sites

        newArticlesInCategory =
            countNewArticlesInCategory sitesInCategory
    in
    categoryWrapper
        [ class "tab"
        , id domId
        ]
        [ deleteActions (getPanelState domId panelsState |> getPanelClass "is-hidden" "deletePanelOpen" "deletePanelClosed") category (extractId sitesInCategory)
        , sidebarRow category.isSelected
            [ class "tabTitle sidebarRow" ]
            (if category.isBeingEdited then
                renderEditCategory category

             else
                renderCategoryName category newArticlesInCategory
            )
        , tabContentOuter category.height
            [ class "tabContentOuter" ]
            [ styled ul
                []
                [ class "category-sitesInCategory tabContentInner", id (getInnerTabId category.id) ]
                (sitesInCategory
                    |> List.map (renderSiteEntry |> lazy)
                )
            ]
        ]


renderCategoryName : Category -> Int -> List (Html Msg)
renderCategoryName category newArticlesInCategory =
    [ styled sidebarSelectionBtn
        [ if category.isSelected then
            batch []

          else
            customCss "padding-right" "calc(3.75rem + 2em)"
        ]
        [ class "categoryBtn"
        , onClick <| ToggleSelectedCategory category.id
        ]
        [ styled span
            [ verticalAlign middle
            , marginRight (em 0.5)
            ]
            [ class "icon folderIcon" ]
            [ folderIcon [ Css.fill theme.colorPrimary ] category.isSelected
            ]
        , badge
            [ class "category-numberOfArticles" ]
            [ text <| String.fromInt newArticlesInCategory ]
        , styled span
            [ verticalAlign middle ]
            [ class "category-name" ]
            [ text (" " ++ category.name) ]
        ]
    ]
        ++ (if category.isSelected then
                [ span
                    [ class "category-action" ]
                    [ iconButtonNoStyle (editIcon [ fill theme.white ]) ( "edit", False ) [ onClick <| EditCategoryMsg <| EditCategory category.id ]
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
        , width (pct 100)
        ]
        [ class "editCategoryName" ]
        [ styled input
            [ Css.flex (Css.int 1) ]
            [ class "editCategoryName-input"
            , id <| "editCategoryName-" ++ String.fromInt category.id
            , value category.name
            , onInput <| EditCategoryMsg << UpdateCategoryName category
            ]
            []
        , iconButton (checkIcon []) ( "ok", False ) [ onClick <| EditCategoryMsg EndCategoryEditing ]
        ]
    ]


renderSiteEntry : Site -> Html Msg
renderSiteEntry site =
    li
        [ class "category-siteInCategory " ]
        [ sidebarRow site.isSelected
            [ class "sidebarRow" ]
            ([ styled sidebarSelectionBtn
                [ if site.isSelected then
                    batch []

                  else
                    customCss "padding-right" "calc(3.75rem + 2em)"
                ]
                [ class "siteInCategoryBtn"
                , onClick <| ToggleSelectSite site.id
                ]
                [ badge
                    [ class "site-numberOfArticles" ]
                    [ text <| String.fromInt site.numberOfNewArticles ]
                , span
                    []
                    [ site.name |> text ]
                ]
             ]
                ++ (if site.isSelected then
                        [ styled span
                            [ flexShrink (int 0) ]
                            [ class "siteInCategory-actions button-group" ]
                            [ iconButtonNoStyle (editIcon [ fill theme.white ]) ( "edit", False ) [ onClick <| EditSiteMsg <| OpenEditSitePanel site ]
                            , iconButtonNoStyle (deleteIcon [ fill theme.white ]) ( "delete", False ) [ onClick <| DeleteMsg <| RequestDeleteSites [ site.id ] ]
                            ]
                        ]

                    else
                        []
                   )
            )
        ]


countNewArticlesInCategory : List Site -> Int
countNewArticlesInCategory sitesInCategory =
    List.foldl (\site numberOfNewArticlesTot -> numberOfNewArticlesTot + site.numberOfNewArticles) 0 sitesInCategory
