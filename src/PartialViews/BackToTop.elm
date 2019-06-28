module PartialViews.BackToTop exposing (backToTop)

import Css exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Html.Styled exposing (Html, div, span, styled, toUnstyled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Msg(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (arrowTop)
import PartialViews.UiKit exposing (onDesktop, theme, transition)


backToTop isBackToTopVisible =
    let
        ( opacityValue, pointerEventsRule, hidden ) =
            if isBackToTopVisible then
                ( 1, pointerEventsAll, False )

            else
                ( 0, pointerEvents none, True )
    in
    styled span
        [ position fixed
        , right theme.distanceS
        , bottom theme.distanceXS
        , opacity (int opacityValue)
        , pointerEventsRule
        , transition "opacity 0.3s"
        , onDesktop
            [ bottom theme.distanceXXXL ]
        ]
        [ class "backToTopButton"
        , ariaHidden hidden |> Html.Styled.Attributes.fromUnstyled
        ]
        [ iconButton (arrowTop [ fill theme.white ]) ( "backToTop", False ) [ onClick ScrollToTop ] ]
