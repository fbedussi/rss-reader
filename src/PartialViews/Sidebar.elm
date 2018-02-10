module PartialViews.Sidebar exposing (..)

import Html exposing (Html, a, article, aside, button, div, h2, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, class, disabled, href, src, value)
import Html.Events exposing (onClick)
import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (plusIcon)
import PartialViews.SearchResult exposing (searchResult)


sidebar : Model -> Html Msg
sidebar model =
    aside
        [ class "sidebar cell medium-4" ]
        [ div
            [ class "button-group expanded" ]
            [ iconButton plusIcon ( "new category", True ) [ onClick AddNewCategory ]
            , iconButton plusIcon ( "new site", True ) [ onClick AddNewSite ]
            ]
        , searchResult model.selectedSiteId model.sites model.searchTerm
        , ul
            [ class "sitesWithoutCategory" ]
            (if String.isEmpty model.searchTerm then
                model.sites
                    |> List.filter (\site -> List.isEmpty site.categoriesId)
                    |> List.map (renderSiteEntry model.selectedSiteId)
             else
                []
            )
        , ul
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
