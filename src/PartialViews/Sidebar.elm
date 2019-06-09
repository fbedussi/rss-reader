module PartialViews.Sidebar exposing (renderCategories, renderSearchBox, renderSidebarToolbar, renderSitesWithoutCategory, sidebar)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Html
import Html.Styled exposing (Html, a, article, aside, button, div, h2, label, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, for, fromUnstyled, href, id, placeholder, src, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Html.Styled.Lazy exposing (lazy, lazy2, lazy3)
import Models exposing (Article, Category, Model, Msg(..), Panel(..), SelectedCategoryId, SelectedSiteId, Site)
import PanelsManager exposing (PanelsState)
import PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)
import PartialViews.IconButton exposing (iconButton, iconButtonNoStyle)
import PartialViews.Icons exposing (cogIcon, plusIcon)
import PartialViews.SearchResult exposing (searchResult)
import PartialViews.UiKit exposing (input, onDesktop, sidebarBoxStyle, standardPadding, theme, transition)
import Swiper exposing (onSwipeEvents)

sidebar : Model -> Html Msg
sidebar model =
    let
        sitesWithoutCategory =
            model.sites
                |> List.filter (\site -> List.isEmpty site.categoriesId)

        searchInProgress =
            not <| String.isEmpty model.searchTerm
    in
    styled aside
        [ position fixed
        , display inlineBlock
        , verticalAlign top
        , top <| calc theme.headerHeight plus theme.hairlineWidth
        , height <| calc (Css.vh 100) minus (calc theme.headerHeight plus theme.hairlineWidth)
        , left zero
        , transition "transform 0.3s"
        , overflow auto
        , width (pct 90)
        , backgroundColor theme.colorBackground
        , zIndex theme.zIndex.menu
        , onDesktop
            [ position static
            , zIndex theme.zIndex.base
            , width (pct 25)
            , height auto
            , minWidth (Css.rem 25)
            , overflow initial
            , transforms []
            ]
        ]
        ([ class "sidebar" ] ++ (onSwipeEvents Swiped |> List.map fromUnstyled))
        ([ renderSidebarToolbar
         , lazy renderSearchBox model.searchTerm
         , lazy2 searchResult model.sites model.searchTerm
         ]
            ++ (if not searchInProgress then
                    [ lazy renderSitesWithoutCategory sitesWithoutCategory
                    , lazy3 renderCategories model.categories model.sites model.panelsState
                    ]

                else
                    []
               )
        )


renderSidebarToolbar : Html Msg
renderSidebarToolbar =
    styled div
        [ padding theme.distanceXXS
        , displayFlex
        , justifyContent spaceBetween
        ]
        [ class "sidebar-toolbar" ]
        [ iconButton (plusIcon []) ( "new category", True ) [ onClick AddNewCategory ]
        , iconButton (plusIcon []) ( "new site", True ) [ onClick AddNewSite ]
        , iconButtonNoStyle (cogIcon [ fill theme.colorPrimary ]) ( "settings", False ) [ onClick <| TogglePanel PanelSettings ]
        ]


renderSearchBox : String -> Html Msg
renderSearchBox searchTerm =
    styled div
        [ displayFlex
        , standardPadding
        , alignItems stretch
        , flexDirection column
        ]
        [ class "searchWrapper" ]
        [ styled label
            [ marginBottom (em 0.5) ]
            [ for "searchInput" ]
            [ text "Search sites by name: " ]
        , input
            [ type_ "search"
            , id "searchInput"
            , placeholder "example.com"
            , onInput UpdateSearch
            , value searchTerm
            ]
            []
        ]


renderSitesWithoutCategory : List Site -> Html Msg
renderSitesWithoutCategory sitesWithoutCategory =
    styled ul
        [ sidebarBoxStyle ]
        [ class "sitesWithoutCategory" ]
        (sitesWithoutCategory
            |> List.map (lazy renderSiteEntry)
        )


renderCategories : List Category -> List Site -> PanelsState -> Html Msg
renderCategories categories sites panelsState =
    styled ul
        [ sidebarBoxStyle ]
        [ class "categories accordion"
        ]
        (categories
            |> List.map (lazy3 renderCategory sites panelsState)
        )
