module PartialViews.Toolbar exposing (toolbar)

import Html.Styled exposing (Html, button, div, input, li, span, text, ul)
import Html.Styled.Attributes exposing (class, placeholder, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Msgs exposing (..)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (cancelIcon, importIcon, refreshIcon)


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
                [ iconButton refreshIcon ( "refresh", False ) [ onClick RefreshFeeds ] ]
            , li
                []
                [ iconButton importIcon ( "import", True ) [ class "warning", onClick ToggleImportLayer ] ]
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
                [ iconButton cancelIcon ( "clear", False ) [ onClick (UpdateSearch "") ] ]
            ]
        ]
    ]
