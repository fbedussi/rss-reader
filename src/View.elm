module View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Sidebar exposing (sidebar)


view : Model -> Html Msg
view model =
    div
        [ class "appWrapper grid-x" ]
        [ sidebar model
        , mainContent model
        ]
