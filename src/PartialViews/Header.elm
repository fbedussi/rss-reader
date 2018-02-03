module PartialViews.Header exposing (siteHeader)

import Html exposing (Html, button, div, header, text)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Toolbar exposing (toolbar)


siteHeader : Model -> Html Msg
siteHeader model =
    header
        [ class "header cell" ]
        [ toolbar
        , errorContainer model.errorMsgs
        ]
