module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Accordion exposing (closeTab, openTab)
import Css exposing (auto, backgroundColor, displayFlex, em, fill, flexShrink, height, int, marginRight, middle, pct, verticalAlign, width)
import Helpers exposing (extractId, getClass, getSitesInCategories, isArticleInSites, isSelected)
import Html
import Html.Styled exposing (Html, a, article, button, div, h2, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import Html.Styled.Lazy exposing (lazy, lazy3)
import Models exposing (Article, Category, DeleteMsg(..), EditCategoryMsg(..), EditSiteMsg(..), Id, Model, Msg(..), Selected, Site)
import PanelsManager exposing (PanelsState, getPanelClass, getPanelState)
import PartialViews.DeleteActions exposing (deleteActions)
import PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon, folderIcon)
import PartialViews.UiKit exposing (badge, categoryWrapper, input, sidebarRow, sidebarSelectionBtn, tabContentOuter, theme)
import Time exposing (Time)


renderCategory : ( List Site, List Article, Time, PanelsState ) -> Category -> Html.Html Msg
renderCategory ( sites, articles, lastRefreshTime, panelsState ) category =
    let
        domId =
            "cat_" ++ toString category.id

        selected =
            category.isSelected

        triggerOpenTab =
            if selected then
                openTab ("#" ++ domId)
            else
                closeTab ("#" ++ domId)

        sitesInCategory =
            getSitesInCategories [ category.id ] sites

        newArticlesInCategory =
            countNewArticlesInCategory sitesInCategory articles lastRefreshTime
    in
    toUnstyled <|
        categoryWrapper
            [ class "tab"
            , id domId
            ]
            [ deleteActions (getPanelState domId panelsState |> getPanelClass "is-hidden" "deletePanelOpen" "deletePanelClosed") category (extractId sitesInCategory)
            , sidebarRow selected
                [ class <|
                    "tabTitle sidebarRow"
                        ++ (if selected then
                                " is-selected"
                            else
                                ""
                           )
                ]
                (if category.isBeingEdited then
                    renderEditCategory category
                 else
                    renderCategoryName category newArticlesInCategory
                )
            , tabContentOuter selected
                [ class "tabContentOuter" ]
                [ styled ul
                    []
                    [ class "category-sitesInCategory tabContentInner" ]
                    (sitesInCategory
                        |> List.map (lazy3 renderSiteEntry articles lastRefreshTime)
                    )
                ]
            ]


renderCategoryName : Category -> Int -> List (Html Msg)
renderCategoryName category newArticlesInCategory =
    [ sidebarSelectionBtn
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
            [ text <| toString newArticlesInCategory ]
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
            , id <| "editCategoryName-" ++ toString category.id
            , value category.name
            , onInput <| EditCategoryMsg << UpdateCategoryName category
            ]
            []
        , iconButton (checkIcon []) ( "ok", False ) [ onClick <| EditCategoryMsg EndCategoryEditing ]
        ]
    ]


renderSiteEntry : List Article -> Time -> Site -> Html.Html Msg
renderSiteEntry articles lastRefreshTime site =
    let
        selected =
            site.isSelected

        newArticlesInSite =
            countNewArticlesInSite site.id articles lastRefreshTime
    in
    toUnstyled <|
        li
            [ class "category-siteInCategory " ]
            [ sidebarRow selected
                [ class <|
                    "sidebarRow"
                        ++ (if selected then
                                " is-selected"
                            else
                                ""
                           )
                ]
                ([ sidebarSelectionBtn
                    [ class "siteInCategoryBtn"
                    , onClick <| ToggleSelectSite site.id
                    ]
                    [ badge
                        [ class "site-numberOfArticles" ]
                        [ text <| toString newArticlesInSite ]
                    , span
                        []
                        [ site.name |> text ]
                    ]
                 ]
                    ++ (if selected then
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


countNewArticlesInCategory : List Site -> List Article -> Time -> Int
countNewArticlesInCategory sitesInCategory articles lastRefreshTime =
    articles
        |> List.filter (\article -> (article.date > lastRefreshTime) && List.any (\site -> site.id == article.siteId) sitesInCategory)
        |> List.length


countNewArticlesInSite : Id -> List Article -> Time -> Int
countNewArticlesInSite siteId articles lastRefreshTime =
    articles
        |> List.filter (\article -> (article.date > lastRefreshTime) && (article.siteId == siteId))
        |> List.length
