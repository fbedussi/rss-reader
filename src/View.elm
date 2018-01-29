module View exposing (view)

import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.Toolbar exposing (toolbar)


view : Model -> Html Msg
view model =
    div
        [ class "appWrapper grid-x" ]
        [ toolbar model
        , sidebar model
        , mainContent model
        , editSiteLayer model
        ]
