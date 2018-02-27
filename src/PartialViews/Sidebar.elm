module PartialViews.Sidebar exposing (..)

import Css exposing (fixed, initial, verticalAlign, top, inlineBlock, display, static, absolute, alignItems, auto, backgroundColor, border3, calc, column, displayFlex, em, flexDirection, height, justifyContent, left, marginBottom, marginLeft, minWidth, minus, overflow, padding, pct, plus, position, px, rem, sticky, stretch, top, transforms, translateX, width, zIndex, zero)
import Css.Media exposing (only, screen, withMedia)
import Html.Styled exposing (Html, a, article, aside, button, div, h2, label, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, for, href, id, placeholder, src, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Model, Msg(..), Panel(..), SelectedCategoryId, SelectedSiteId, Site)
import PanelsManager exposing (getPanelState, isPanelOpen)
import PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (plusIcon)
import PartialViews.SearchResult exposing (searchResult)
import PartialViews.UiKit exposing (input, sidebarBoxStyle, standardPadding, theme, transition)


sidebar : Model -> Html Msg
sidebar model =
    let
        isOpen =
            getPanelState (toString PanelMenu) model.panelsState |> isPanelOpen
    in
    styled aside
        [ position fixed
        , display inlineBlock
        , verticalAlign top
        , top <| calc theme.headerHeight plus theme.hairlineWidth
        , height <| calc (Css.vh 100) minus (calc theme.headerHeight plus theme.hairlineWidth)
        , left zero
        , if isOpen then
            transforms [ translateX zero ]
          else
            transforms [ translateX (pct -100) ]
        , transition "transform 0.3s"
        , overflow auto
        , width (pct 90)
        , backgroundColor theme.colorBackground
        , zIndex theme.zIndex.menu
        , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
            [ position static
            , zIndex theme.zIndex.base
                , width (pct 25)
            , height auto
            , minWidth (Css.rem 25)
            , overflow initial
            , transforms []
            ]
        ]
        [ class "sidebar" ]
        [ styled div
            [ padding theme.distanceXXS
            , displayFlex
            , justifyContent stretch
            ]
            [ class "sidebar-toolbar" ]
            [ iconButton (plusIcon []) ( "new category", True ) [ onClick AddNewCategory ]
            , iconButton (plusIcon []) ( "new site", True ) [ onClick AddNewSite ]
            ]
        , styled div
            [ displayFlex
            , standardPadding
            , alignItems stretch
            , flexDirection column
            ]
            [ class "searchWrapper" ]
            [ styled label
                [ marginBottom (em 0.5) ]
                [ for "searchInput" ]
                [ text "Serch sites by name: " ]
            , input
                [ type_ "search"
                , id "searchInput"
                , placeholder "example.com"
                , onInput UpdateSearch
                , value model.searchTerm
                ]
                []
            ]
        , searchResult model.selectedSiteId model.sites model.searchTerm
        , styled ul
            [ sidebarBoxStyle ]
            [ class "sitesWithoutCategory" ]
            (if String.isEmpty model.searchTerm then
                model.sites
                    |> List.filter (\site -> List.isEmpty site.categoriesId)
                    |> List.map (renderSiteEntry model.selectedSiteId)
             else
                []
            )
        , styled ul
            [ sidebarBoxStyle ]
            [ class "categories accordion"
            ]
            (if String.isEmpty model.searchTerm then
                model.categories
                    |> List.map (renderCategory model)
             else
                []
            )
        ]
