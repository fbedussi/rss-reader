module Update.ErrorBox exposing (handleErrorBoxMsgs)

import Helpers exposing (delay)
import Models exposing (ErrorBoxMsg(..), Model, Msg(..))
import Murmur3 exposing (hashString)
import PanelsManager exposing (closePanel, openPanel)


handleErrorBoxMsgs : Model -> ErrorBoxMsg -> ( Model, Cmd Msg )
handleErrorBoxMsgs model msg =
    case msg of
        OpenErrorMsg errorMsgId ->
            ( { model | panelsState = openPanel errorMsgId model.panelsState }, Cmd.none )

        RequestRemoveErrorMsg msgToRemove ->
            let
                updatedPanelsState =
                    closePanel (hashString 1234 msgToRemove |> toString) model.panelsState
            in
            ( { model | panelsState = updatedPanelsState }, delay 1500 (ErrorBoxMsg <| RemoveErrorMsg msgToRemove) )

        RemoveErrorMsg msgToRemove ->
            let
                newErrorMsgs =
                    model.errorMsgs |> List.filter (\modelMsg -> modelMsg /= msgToRemove)
            in
            ( { model | errorMsgs = newErrorMsgs }, Cmd.none )

        LogErr err ->
            let
                log =
                    Debug.log "Error: " err
            in
            ( { model | errorMsgs = model.errorMsgs ++ [ toString err ] }, Cmd.none )
