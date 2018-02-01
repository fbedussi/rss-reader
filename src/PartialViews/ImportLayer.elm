module PartialViews.ImportLayer exposing (importLayer)

import Html exposing (Html, button, div, p, text, textarea)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (..)


importLayer : Bool -> Html Msg
importLayer layerOpen =
    div
        [ class
            ("editSiteLayer layer layer--top "
                ++ (if layerOpen then
                        "is-open"
                    else
                        ""
                   )
            )
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
