module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Accordion exposing (closeTab, openTab)
import Css exposing (auto, backgroundColor, displayFlex, em, fill, flexShrink, height, int, marginRight, middle, pct, verticalAlign, width)
import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites, isSelected)
import Html.Styled exposing (Html, a, article, button, div, h2, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Id, Model, Msg(..), Selected, SelectedCategoryId, SelectedSiteId, Site)
import PanelsManager exposing (getPanelClass, getPanelState)
import PartialViews.DeleteActions exposing (deleteActions)
import PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon, folderIcon)
import PartialViews.UiKit exposing (badge, categoryWrapper, input, sidebarRow, sidebarSelectionBtn, tabContentOuter, theme)
import Time exposing (Time)


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

        newArticlesInCategory =
            countNewArticlesInCategory sitesInCategory model.articles model.appData.lastRefreshTime
    in
    categoryWrapper
        [ class "tab"
        , id domId
        ]
        [ deleteActions (getPanelState domId model.panelsState |> getPanelClass "is-hidden" "slideRight" "slideLeft") category (extractId sitesInCategory)
        , sidebarRow selected
            [ class "tabTitle" ]
            (case model.categoryToEditId of
                Just categoryToEditId ->
                    if categoryToEditId == category.id then
                        renderEditCategory category
                    else
                        renderCaregoryName category selected newArticlesInCategory

                Nothing ->
                    renderCaregoryName category selected newArticlesInCategory
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
renderCaregoryName category selected newArticlesInCategory =
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
            [ newArticlesInCategory
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
        , width (pct 100)
        ]
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
                , onClick <| ToggleSelectSite site.id
                ]
                [ site.name |> text ]
             ]
                ++ (if selected then
                        [ styled span
                            [ flexShrink (int 0) ]
                            [ class "siteInCategory-actions button-group" ]
                            [ iconButtonNoStyle (editIcon [ fill theme.white ]) ( "edit", False ) [ onClick <| OpenEditSitePanel site.id ]
                            , iconButtonNoStyle (deleteIcon [ fill theme.white ]) ( "delete", False ) [ onClick <| RequestDeleteSites [ site.id ] ]
                            ]
                        ]
                    else
                        []
                   )
            )
        ]


countNewArticlesInCategory : List Site -> List Article -> Time -> Int
countNewArticlesInCategory sitesInCategory articles lastRefreshTime =
    let
        articlesInCategory =
            articles
                |> List.filter (\article -> article.date > lastRefreshTime)
                |> List.filter (isArticleInSites sitesInCategory)
    in
    List.length articlesInCategory
