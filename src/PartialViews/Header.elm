module PartialViews.Header exposing (siteHeader)

import Css exposing (..)
import Html.Styled exposing (Html, span, text, styled, header)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (importIcon, refreshIcon)
import PartialViews.UiKit exposing (input, theme)
import PartialViews.Icons exposing (rssIcon)

siteHeader : Html Msg
siteHeader =
    styled header
        [ displayFlex
        , justifyContent flexStart
        , padding theme.distanceXXS
        , borderBottom3 theme.hairlineWidth solid theme.colorHairline
        , position sticky
        , top zero
        , backgroundColor theme.colorBackground
        , zIndex (int 10)
        ]
        []
        [ rssIcon [
            width (em 2)
            , height (em 2)
            , marginRight (em 0.5)
            , fill theme.colorAccent
        ]
        , styled span
            [ displayFlex
            , alignItems stretch
            ]
            []
            [ styled span
                [ fontSize theme.fontSizeTitle
                , marginRight (em 0.5)
                ]
                []
                [ text "Minimal RSS reader" ]
            , iconButton (refreshIcon []) ( "refresh", False ) [ class "refreshButton", onClick RefreshFeeds ]
            , iconButton (importIcon []) ( "import", True ) [ class "warning", onClick ToggleImportLayer ]
            ]
        ]
