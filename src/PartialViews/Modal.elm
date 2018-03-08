module PartialViews.Modal exposing (modal)

import Html.Styled exposing (Html, div, text, styled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Modal, Msg(..))
import PartialViews.UiKit exposing (btn, secondaryBtn, transition, theme, standardPadding)
import Css exposing (borderRadius, display, block, none, int, opacity, width, maxWidth, em, pct, zIndex, position, absolute, top, left, transforms, translate2, backgroundColor, displayFlex, justifyContent, spaceBetween, margin2, zero, auto, marginBottom)

modal : Modal -> String -> Html Msg
modal data animationClass =
    styled div
        [width (em 30)
         ,maxWidth (pct 90)
        ,zIndex (int 20)
        , position absolute
        , top (pct 50)
        , left (pct 50)
        , transforms [translate2 (pct -50) (pct -50)]
        , backgroundColor theme.colorBackground
        , standardPadding
        , borderRadius (Css.px 3)
        ]
        [class <| "modal" ++ animationClass]
        [ styled div
            [marginBottom (em 1)]
            [class "modal-text"]
            [text data.text]
        , styled div
            [displayFlex
            ,width (pct 80)
            , margin2 zero auto
            ,justifyContent spaceBetween
            ]
            [class "modal-buttons"]
            [btn
                [class "modal-okButton"
                ,onClick data.action]
                [text "yes"]
            , secondaryBtn
                [class "modal-cancelButton"
                ,onClick CloseAllPanels]
                [text "no"]
            ]
        ]

