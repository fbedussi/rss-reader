module PartialViews.ErrorContainer exposing (errorContainer)

import Html exposing (Html, button, div, header, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (..)


errorContainer : List String -> Html Msg
errorContainer errorMsgs =
    div
        [ class "errorContainer cell" ]
        (renderErrorMessages errorMsgs)


renderErrorMessages : List String -> List (Html Msg)
renderErrorMessages errorMsgs =
    errorMsgs
        |> List.map renderErrorMsg


renderErrorMsg : String -> Html Msg
renderErrorMsg errorMsg =
    div
        [ class "errorMsg" ]
        [ span
            [ class "errorMsg-text" ]
            [ text errorMsg ]
        , span
            [ class "errorMsg-button button"
            , onClick (RemoveErrorMsg errorMsg)
            ]
            [ text "remove" ]
        ]
