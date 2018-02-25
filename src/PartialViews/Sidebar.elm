module PartialViews.Sidebar exposing (..)

import Css exposing (alignItems, border3, displayFlex, justifyContent, marginLeft, marginBottom, em, minWidth, padding, pct, px, rem, stretch, width, zero, flexDirection, column)
import Html.Styled exposing (Html, a, article, aside, button, div, h2, label, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, for, href, id, placeholder, src, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Model, Msg(..), SelectedCategoryId, SelectedSiteId, Site)
import PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (plusIcon)
import PartialViews.SearchResult exposing (searchResult)
import PartialViews.UiKit exposing (input, sidebarBoxStyle, theme, standardPadding)


sidebar : Model -> Html Msg
sidebar model =
    styled aside
        [ width (pct 25)
        , minWidth (Css.rem 25)
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
                [marginBottom (em 0.5)]
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
            [sidebarBoxStyle]
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
