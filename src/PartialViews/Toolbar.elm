module PartialViews.Toolbar exposing (toolbar)

import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (..)


toolbar : String -> List (Html Msg)
toolbar searchTerm =
    [ div
        [ class "top-bar-left" ]
        [ ul
            [ class "dropdown menu" ]
            [ li
                [ class "menu-text" ]
                [ text "Minimal RSS reader" ]
            , li
                []
                [ button
                    [ class "button"
                    , onClick RefreshFeeds
                    ]
                    [ text "refresh" ]
                ]
            , li
                []
                [ button
                    [ class "importButton button warning"
                    , onClick ToggleImportLayer
                    ]
                    [ text "import" ]
                ]
            ]
        ]
    , div
        [ class "top-bar-right" ]
        [ ul
            [ class "menu" ]
            [ li
                []
                [ input
                    [ type_ "search"
                    , placeholder "search site"
                    , onInput UpdateSearch
                    , value searchTerm
                    ]
                    []
                ]
            , li
                []
                [ button
                    [ class "button"
                    , onClick (UpdateSearch "")
                    ]
                    [ text "clear" ]
                ]
            ]
        ]
    ]
