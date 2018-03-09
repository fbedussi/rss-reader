module PartialViews.Header exposing (siteHeader)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Html.Styled exposing (Html, header, img, span, styled, text)
import Html.Styled.Attributes exposing (class, src)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..), Panel(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (menuIcon, refreshIcon, logo)
import PartialViews.UiKit exposing (btnNoStyle, input, theme)


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
        , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
            [ justifyContent flexStart 
            , zIndex (theme.zIndex.headerDesktop)        
            ]
        ]
        []
        [ styled btnNoStyle
            [ withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ display none
                ]
            ]
            [ onClick <| TogglePanel PanelMenu ]
            [ menuIcon
                [ fill theme.colorPrimary
                , width theme.buttonHeight
                , height theme.buttonHeight
                ]
            ]
        , logo [height (Css.rem 2)]
        , styled span
            [ display none
            , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ display inline
                , flex (int 1)
                ]
            ]
            [ class "separator" ]
            []
        , iconButton (refreshIcon []) ( "refresh", False ) [ class "refreshButton", onClick RefreshFeeds ]
        ]
