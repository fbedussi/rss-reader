module PartialViews.Header exposing (siteHeader)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Html.Styled exposing (Html, header, span, styled, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..), Panel(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (importIcon, menuIcon, refreshIcon, rssIcon)
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
        , zIndex (int 10)
        , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
            [justifyContent flexStart]
        ]
        []
        [ styled btnNoStyle
            [ withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ display none
                ]
            ]
            [ onClick <| TogglePanel PanelMenu ]
            [ menuIcon 
                [fill theme.colorPrimary 
                , width theme.buttonHeight
                , height theme.buttonHeight
                ]
            ]
        , rssIcon
            [ display none
            , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ display block
                , width (em 2)
                , height (em 2)
                , marginRight (em 0.5)
                , fill theme.colorAccent
                ]
            ]
        , styled span
            [ fontSize theme.fontSizeTitle
            , marginRight (em 0.5)
            , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ fontSize theme.fontSizeTitleDesktop ]
            ]
            []
            [ text "Minimal RSS reader" ]
        , iconButton (refreshIcon []) ( "refresh", False ) [ class "refreshButton", onClick RefreshFeeds ]
        , styled span 
            [ display none
            , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ display block
                , flex (int 1)
                 ]
            ]
            []
            []
        , styled span
            [ display none
            , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ display inlineBlock ]
            ]
            []
            [ iconButton (importIcon []) ( "import", True ) [ class "warning", onClick <| TogglePanel PanelImport ] ]
        ]
