module PartialViews.ErrorContainer exposing (errorContainer)

import Html.Styled exposing (Html, button, div, header, span, text)
import Html.Styled.Attributes exposing (class)
import Models exposing (Msg(..))
import PartialViews.UiKit exposing (errorMessage, closeBtn)
import PanelsManager exposing (PanelsState, getPanelClass, getPanelState)
import Murmur3 exposing (hashString)


errorContainer : PanelsState -> List String -> Html Msg
errorContainer panelsState errorMsgs =
    div
        [ class "errorContainer" ]
        (errorMsgs
        |> List.map (renderErrorMsg panelsState))


renderErrorMsg : PanelsState -> String -> Html Msg
renderErrorMsg panelsState errorMsg =
    let
        panelId = hashString 1234 errorMsg |> toString

        animationClass = 
            getPanelState panelId panelsState |> getPanelClass "" "slideRight" "slideLeft"
    in
    errorMessage
        [ class <| "errorMsg" ++ animationClass ]
        [ span
            [ class "errorMsg-text" ]
            [ text errorMsg ]
        , closeBtn (RequestRemoveErrorMsg errorMsg)
        ]
