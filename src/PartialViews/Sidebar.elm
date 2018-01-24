module PartialViews.Sidebar exposing (..)

import Html exposing (Html, a, article, aside, button, div, h2, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, class, disabled, href, src, value)
import Html.Events exposing (onClick)
import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryTree exposing (renderCategory)


sidebar : Model -> Html Msg
sidebar model =
    aside
        [ class "sidebar cell medium-3" ]
        [ div
            [ class "button-group" ]
            [ button
                [ class "button"
                , onClick AddNewCategory
                ]
                [ text "add new category" ]
            , button
                [ class "button"
                , onClick AddNewSite
                ]
                [ text "add new site" ]
            , button
                [ class "button" ]
                [ text "refresh" ]
            ]
        , ul
            [ class "categories accordion"
            , attribute "data-accordion" ""
            ]
            (model.categories
                |> List.map (renderCategory model)
            )
        ]
