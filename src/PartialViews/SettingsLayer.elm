module PartialViews.SettingsLayer exposing (settingsLayer)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Html.Styled exposing (Html, div, styled)
import Html.Styled.Attributes exposing (class, id, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..), Panel(..), Options)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (exitIcon, importIcon)
import PartialViews.UiKit exposing (btn, input, inputRow, inputRowLabel, layerTop, secondaryBtn, theme)


settingsLayer : Options -> String -> Html Msg
settingsLayer options animationClass =
    layerTop (TogglePanel PanelSettings)
        [ class <| "settingsLayer" ++ animationClass
        ]
        [ div
            [ class "layer-inner" ]
            [ inputRow
                []
                [ iconButton (importIcon []) ( "import", True ) [ onClick <| OpenImportPanel ] ]
            , inputRow
                []
                [ iconButton (exitIcon []) ( "sign out", True ) [ onClick SignOut ] ]
            , inputRow
                []
                [ inputRowLabel "previewRows" "Text preview height (in rows)"
                , styled input
                    [ flex (int 5) ]
                    [ class "input"
                    , id "previewRows"
                    , value <| toString options.articlePreviewHeightInEm
                    , onInput ChangePreviewHeight
                    , type_ "number"
                    ]
                    []
                ]
            ]
        ]
