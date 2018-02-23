module PartialViews.ErrorContainer exposing (errorContainer)

import Html.Styled exposing (Html, button, div, header, span, styled, text)
import Html.Styled.Attributes exposing (class)
import Models exposing (Msg(..))
import Murmur3 exposing (hashString)
import PanelsManager exposing (PanelsState, getPanelClass, getPanelState)
import PartialViews.UiKit exposing (closeBtn, errorMessage, standardPadding)

errorContainer : PanelsState -> List String -> Html Msg
errorContainer panelsState errorMsgs =
    div
        [ class "errorContainer" ]
        (errorMsgs
            |> List.map (renderErrorMsg panelsState)
        )


renderErrorMsg : PanelsState -> String -> Html Msg
renderErrorMsg panelsState errorMsg =
    let
        panelId =
            hashString 1234 errorMsg |> toString

        animationClass =
            getPanelState panelId panelsState |> getPanelClass "" "" "collapse"

        log = Debug.log "animationClass" animationClass
    in
    errorMessage animationClass errorMsg
        