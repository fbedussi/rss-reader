module PartialViews.Sidebar exposing (..)

import Html.Styled exposing (Html, a, article, aside, button, div, h2, input, li, main_, span, text, ul, styled, toUnstyled)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, src, value)
import Html.Styled.Events exposing (onClick)
import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (plusIcon)
import PartialViews.SearchResult exposing (searchResult)
import Html.Styled exposing (toUnstyled)
import Css exposing (width, pct, padding, displayFlex, justifyContent, stretch, marginLeft, zero)
import PartialViews.UiKit exposing (theme)

sidebar : Model -> Html Msg
sidebar model =
    styled aside
        [width (pct 25)]
        [ class "sidebar" ]
        [ styled div
            [padding theme.distanceXXS
            , displayFlex
            , justifyContent stretch
            ]
            [ class "sidebar-toolbar" ]
            [ (iconButton plusIcon ( "new category", True ) [ onClick AddNewCategory ])
            , (iconButton plusIcon ( "new site", True ) [ onClick AddNewSite ])
            ]
        , searchResult model.selectedSiteId model.sites model.searchTerm
        , styled ul
            [padding theme.distanceXXS]
            [ class "sitesWithoutCategory" ]
            (if String.isEmpty model.searchTerm then
                model.sites
                    |> List.filter (\site -> List.isEmpty site.categoriesId)
                    |> List.map (renderSiteEntry model.selectedSiteId)
             else
                []
            )
        , styled ul
            [padding theme.distanceXXS]
            [ class "categories accordion"
            , attribute "data-accordion" ""
            ]
            (if String.isEmpty model.searchTerm then
                model.categories
                    |> List.map (renderCategory model)
             else
                []
            )
        ]
