module PartialViews.Header exposing (siteHeader)

import Css exposing (..)
import Html.Styled exposing (Html, header, img, span, styled, text)
import Html.Styled.Attributes exposing (class, src)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..), Panel(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (menuIcon, refreshIcon, logo)
import PartialViews.UiKit exposing (btnNoStyle, input, theme, onDesktop)


siteHeader : Html Msg
siteHeader =
    styled header
        [ displayFlex
        , justifyContent spaceBetween
        , alignItems center
        , padding theme.distanceXXS
        , borderBottom3 theme.hairlineWidth solid theme.colorHairline
        , position sticky
        , top zero
        , backgroundColor theme.colorBackground
        , zIndex (theme.zIndex.headerSmartphone)
        , onDesktop
            [ justifyContent flexStart 
            , zIndex (theme.zIndex.headerDesktop)        
            ]
        ]
        []
        [ styled btnNoStyle
            [ onDesktop
                [ display none]
            ]
            [ onClick ToggleMenu ]
            [ menuIcon
                [ fill theme.colorPrimary
                , width theme.buttonHeight
                , height theme.buttonHeight
                ]
            ]
        , logo [height (Css.rem 2)]
        , styled span
            [ display none
            , onDesktop
                [ display inline
                , flex (int 1)
                ]
            ]
            [ class "separator" ]
            []
        , iconButton (refreshIcon []) ( "refresh", False ) [ class "refreshButton", onClick RefreshFeeds ]
        ]
