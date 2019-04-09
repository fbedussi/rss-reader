module PartialViews.Modal exposing (modal)

import Css exposing (..)
import Html.Styled exposing (Html, div, styled, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Modal, Msg(..), Panel(..))
import PartialViews.UiKit exposing (btn, closeButton, secondaryBtn, standardPadding, theme, transition)


modal : Modal -> String -> Html Msg
modal data animationClass =
    styled div
        [ width (em 30)
        , maxWidth (pct 90)
        , zIndex (int 20)
        , position absolute
        , top (pct 50)
        , left (pct 50)
        , transforms [ translate2 (pct -50) (pct -50) ]
        , backgroundColor theme.colorBackground
        , borderRadius (Css.px 3)
        ]
        [ class <| "modal" ++ animationClass ]
        [ styled div
            [ padding3 theme.distanceXXS theme.distanceXXS zero
            , borderBottom3 (Css.px 2) solid theme.colorHairline
            ]
            []
            [ closeButton <| TogglePanel PanelModal ]
        , styled div
            [ standardPadding
            , marginBottom (em 1)
            ]
            [ class "modal-text" ]
            [ text data.text ]
        , styled div
            [ displayFlex
            , width (pct 80)
            , margin2 zero auto
            , standardPadding
            , justifyContent spaceBetween
            ]
            [ class "modal-buttons" ]
            [ btn
                [ class "modal-okButton"
                , onClick data.action
                ]
                [ text "yes" ]
            , secondaryBtn
                [ class "modal-cancelButton"
                , onClick <| TogglePanel PanelModal
                ]
                [ text "no" ]
            ]
        ]
