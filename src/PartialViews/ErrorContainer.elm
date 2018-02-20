module PartialViews.ErrorContainer exposing (errorContainer)

import Char
import Html.Styled exposing (Html, button, div, header, span, text)
import Html.Styled.Attributes exposing (class, fromUnstyled)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabel)
import Html.Styled.Events exposing (onClick)
import Models exposing (Msg(..))


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
            , ariaLabel "Dismiss alert" |> fromUnstyled
            ]
            [ span
                [ ariaHidden True |> fromUnstyled ]
                [ String.fromChar (Char.fromCode 215) |> text ]
            ]
        ]
