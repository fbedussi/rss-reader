module PartialViews.ErrorContainer exposing (errorContainer)

import Char
import Html exposing (Html, button, div, header, span, text)
import Html.Attributes exposing (class)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabel)
import Html.Events exposing (onClick)
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
        [ class "errorMsg callout warning" ]
        [ span
            [ class "errorMsg-text" ]
            [ text errorMsg ]
        , button
            [ class "errorMsg-button close-button"
            , onClick (RemoveErrorMsg errorMsg)
            , ariaLabel "Dismiss alert"
            ]
            [ span
                [ ariaHidden True ]
                [ String.fromChar (Char.fromCode 215) |> text ]
            ]
        ]
