module PartialViews.ImportLayer exposing (importLayer)

import Html.Styled exposing (Html, button, div, p, text, textarea)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick, onInput)
import Msgs exposing (..)
import TransitionManager exposing (TransitionStore, manageTransitionClass, toTransitionManagerId)

importLayer : TransitionStore -> Html Msg
importLayer transitionStore =
    div
        [ class
            ("editSiteLayer layer layer--top" ++ (toTransitionManagerId "panel" "import" |> manageTransitionClass transitionStore))
        ]
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
                    [ button
                        [ class "executeImportButton button"
                        , onClick ExecuteImport
                        ]
                        [ text "import" ]
                    , button
                        [ class "button"
                        , onClick ToggleImportLayer
                        ]
                        [ text "close" ]
                    ]
                ]
            ]
        ]
