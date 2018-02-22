module PartialViews.ImportLayer exposing (importLayer)

import Html.Styled exposing (Html, button, div, p, text, textarea)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Msg(..))
import PartialViews.UiKit exposing (layerTop, btn, secondaryBtn)

importLayer : (Bool, Bool) -> Html Msg
importLayer (isOpen, isClosed) =
    layerTop
        [ class ("importLayer" ++ (if isOpen then " slideDown" else if isClosed then " slideUp" else "" ))
        ]
        [ div
            [ class "layer-inner"]
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
