module PartialViews.Toolbar exposing (toolbar)

import Css exposing (..)
import Html.Styled exposing (Html, button, div, li, span, text, ul, styled)
import Html.Styled.Attributes exposing (class, placeholder, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Msgs exposing (..)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (importIcon, refreshIcon)
import PartialViews.UiKit exposing (input, theme)

toolbar : String -> List (Html Msg)
toolbar searchTerm =
    [ styled div
        [ displayFlex
        , justifyContent spaceBetween
        , padding theme.distanceXXS
        , borderBottom3 theme.hairlineWidth solid theme.colorHairline
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
            , iconButton (refreshIcon []) ( "refresh", False ) [ onClick RefreshFeeds ]
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
    ]
