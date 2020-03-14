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
import PartialViews.IconButton exposing (iconButton, iconButtonNoStyle, iconButtonStyled)
import PartialViews.Icons exposing (cogIcon, plusIcon, arrowLeftIcon)
import PartialViews.SearchResult exposing (searchResult)
import PartialViews.UiKit exposing (input, onDesktop, sidebarBoxStyle, standardPadding, theme, transition)
import Swiper exposing (onSwipeEvents)


sidebar : List Site -> String -> List Category -> PanelsState -> Bool -> Html Msg
sidebar sites searchTerm categories panelsState sidebarCollapsed =
    let
        sitesWithoutCategory =
            sites
                |> List.filter (\site -> List.isEmpty site.categoriesId)

        searchInProgress =
            not <| String.isEmpty searchTerm
    in
    styled aside
        [ position fixed
        , display inlineBlock
        , verticalAlign top
        , top <| calc theme.headerHeight plus theme.hairlineWidth
        , height <| calc (Css.vh 100) minus (calc theme.headerHeight plus theme.hairlineWidth)
        , left zero
        , transition "transform 0.3s, width 0.3s, box-shadow 0.3s"
        , overflow auto
        , maxWidth (Css.rem 25)
        , backgroundColor theme.colorBackground
        , zIndex theme.zIndex.menu
        , onDesktop
            [ position relative
            , top zero
            , zIndex theme.zIndex.base
            , width <| if sidebarCollapsed then (Css.rem 1.5) else (Css.rem 25)
            , height auto
            , overflow visible
            , transforms []
            , boxShadow4 (Css.px 0) (Css.px 0) (Css.px 0) theme.colorHairline
            , hover [
                boxShadow4 (Css.px 3) (Css.px 0) (Css.px 5) theme.colorHairline
            ]
            ]
        ]
        ([ class <| "sidebar" ++ if sidebarCollapsed then " collapsed" else ""  ] ++ (onSwipeEvents Swiped |> List.map fromUnstyled))
        [ iconButtonStyled (arrowLeftIcon [ fill theme.colorPrimary 
            , width (Css.pct 100)
            , height (Css.pct 100)
            , transforms [rotate <| if sidebarCollapsed then (deg 180) else (deg 0)]
            ]) ("toggle siedebar", False)
            [position sticky
            , top (Css.rem 9)
            , width theme.buttonHeight
            , height theme.buttonHeight
            , borderRadius (Css.pct 50)
            , backgroundColor theme.colorBackground
            , overflow hidden
            , opacity (int 0)
            , transition "opacity 0.3s"
            , left (Css.rem 25)
            , zIndex (int 100)
            , marginRight (Css.rem -1.25)
            , boxShadow4 (Css.px 3) (Css.px 0) (Css.px 15) theme.colorHairline
            , fill theme.colorPrimary
            , border3 (Css.px 1) solid theme.colorHairline
            , padding zero
            ]
            [onClick ToggleSidebar, class "collapseSidebarBtn"]
        , styled div
            [onDesktop
                [ overflow hidden
                , transition "opacity 0.3s"
                , opacity <| if sidebarCollapsed then (int 0) else (int 1)
                ]]
            []
            [ styled div
                [width (Css.pct 100)
                , onDesktop 
                    [width (Css.rem 25)]
                ]
                []
                ([ renderSidebarToolbar
                , lazy renderSearchBox searchTerm
                , lazy2 searchResult sites searchTerm
                ]
                    ++ (if not searchInProgress then
                            [ lazy renderSitesWithoutCategory sitesWithoutCategory
                            , lazy3 renderCategories categories sites panelsState
                            ]

                        else
                            []
                    )

                )
            ]
        ]


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
