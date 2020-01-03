module PartialViews.SettingsLayer exposing (settingsLayer)

import Css exposing (..)
import Html.Styled exposing (Html, div, span, styled)
import Html.Styled.Attributes exposing (class, id, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..), Options, Panel(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (exitIcon, exportIcon, importIcon)
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
                [ styled div
                    [ marginRight theme.distanceXS ]
                    []
                    [ styled span [ marginRight theme.distanceXS ] [] [ iconButton (importIcon []) ( "import", True ) [ onClick <| OpenImportPanel ] ]
                    , iconButton (exportIcon []) ( "export", True ) [ onClick <| TriggerExportData ]
                    ]
                ]
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
                    , value <| String.fromFloat options.articlePreviewHeightInEm
                    , onInput ChangePreviewHeight
                    , type_ "number"
                    ]
                    []
                ]
            , inputRow
                []
                [ inputRowLabel "maxNumberOfFailures" "Number of consecutive failures before disabling a site"
                , styled input
                    [ flex (int 5) ]
                    [ class "input"
                    , id "maxNumberOfFailures"
                    , value <| String.fromInt options.maxNumberOfFailures
                    , onInput ChangeMaxNumberOfFailures
                    , type_ "number"
                    ]
                    []
                ]
            ]
        ]
