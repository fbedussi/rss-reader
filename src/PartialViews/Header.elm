module PartialViews.Header exposing (siteHeader)

import Html.Styled exposing (Html, button, div, header, text)
import Html.Styled.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.Toolbar exposing (toolbar)


siteHeader : Model -> Html Msg
siteHeader model =
    header
        [ class "header cell top-bar" ]
        (toolbar model.searchTerm)
