module PartialViews.ErrorContainer exposing (errorContainer)

import Html.Styled exposing (Html, button, div, header, span, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Msg(..))
import PartialViews.UiKit exposing (errorMessage, closeBtn)

errorContainer : List String -> Html Msg
errorContainer errorMsgs =
    div
        [ class "errorContainer" ]
        (errorMsgs
        |> List.map renderErrorMsg)


renderErrorMsg : String -> Html Msg
renderErrorMsg errorMsg =
    errorMessage
        [ class "errorMsg" ]
        [ span
            [ class "errorMsg-text" ]
            [ text errorMsg ]
        , closeBtn (RemoveErrorMsg errorMsg)
        ]
