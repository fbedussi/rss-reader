module PartialViews.Header exposing (siteHeader)

import Css exposing (..)
import Html.Styled exposing (Html, button, div, li, span, text, ul, styled, header)
import Html.Styled.Attributes exposing (class, placeholder, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (importIcon, refreshIcon)
import PartialViews.UiKit exposing (input, theme)

siteHeader : String -> Html Msg
siteHeader searchTerm =
    styled header
        [ displayFlex
        , justifyContent spaceBetween
        , padding theme.distanceXXS
        , borderBottom3 theme.hairlineWidth solid theme.colorHairline
        , position sticky
        , top zero
        , backgroundColor theme.colorBackground
        , zIndex (int 10)
        ]
        []
        [ styled span
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
        ,styled span
            [ displayFlex
            , alignItems stretch
            ]
            [ ]
            [ input
                    [ type_ "search"
                    , placeholder "search site"
                    , onInput UpdateSearch
                    , value searchTerm
                    ]
                    []
            ]
        ]
