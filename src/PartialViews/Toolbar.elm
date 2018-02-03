module PartialViews.Toolbar exposing (toolbar)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (..)


toolbar : Html Msg
toolbar =
    div
        [ class "toolbar cell" ]
        [ button
            [ class "importButton button"
            , onClick ToggleImportLayer
            ]
            [ text "import" ]
        ]
