module PartialViews.Toolbar exposing (toolbar)

import Html exposing (Html, div, header, text)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)


toolbar : Model -> Html Msg
toolbar model =
    header
        [ class "toolbar" ]
        [ div
            [ class "errorContainer" ]
            [ text model.errorMsg ]
        ]
