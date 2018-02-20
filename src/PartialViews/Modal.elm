module PartialViews.Modal exposing (modal)

import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (class)
import Models exposing (Modal, Msg)

modal : Modal -> Html Msg
modal data =
    div
        [class "modal"]
        [text data.text]
