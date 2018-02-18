module PartialViews.ImportLayer exposing (importLayer)

import Html.Styled exposing (Html, button, div, p, text, textarea)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick, onInput)
import Msgs exposing (..)
import TransitionManager exposing (TransitionStore, getTransitionState, toTransitionManagerId)
import PartialViews.UiKit exposing (layerTop, btn, secondaryBtn)


importLayer : TransitionStore -> Html Msg
importLayer transitionStore =
    layerTop (toTransitionManagerId "panel" "import" |> getTransitionState transitionStore)
        [ class "editSiteLayer" ]
        [ div
            [ class "layer-inner" ]
            [ div
                [ class "importForm" ]
                [ p
                    [ class "impoertInstructions" ]
                    [ text "Paste your OPML converted into Json in the text area below and click \"import\"" ]
                , textarea
                    [ class "importArea"
                    , onInput StoreImportData
                    ]
                    []
                , div
                    [ class "button-group" ]
                    [ btn
                        [ class "executeImportButton button"
                        , onClick ExecuteImport
                        ]
                        [ text "import" ]
                    , secondaryBtn
                        [ class "button"
                        , onClick ToggleImportLayer
                        ]
                        [ text "close" ]
                    ]
                ]
            ]
        ]
