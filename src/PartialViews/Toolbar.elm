module PartialViews.Toolbar exposing (toolbar)

import Html exposing (Html, button, div, header, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (..)


toolbar : Model -> Html Msg
toolbar model =
    header
        [ class "toolbar" ]
        [ button
            [ class "importButton button"
            , onClick ToggleImportLayer
            ]
            [ text "import" ]
        , div
            [ class "errorContainer" ]
            [ text model.errorMsg ]
        ]
