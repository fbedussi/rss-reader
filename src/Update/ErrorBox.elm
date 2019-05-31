module Update.ErrorBox exposing (handleErrorBoxMsgs)

import Helpers exposing (createErrorMsg, delay)
import Models exposing (ErrorBoxMsg(..), ErrorMsg, Model, Msg(..))
import PanelsManager exposing (closePanel, openPanel)
import Time exposing (millisToPosix)


handleErrorBoxMsgs : Model -> ErrorBoxMsg -> ( Model, Cmd Msg )
handleErrorBoxMsgs model msg =
    case msg of
        OpenErrorMsg errorMsg ->
            ( { model | panelsState = openPanel errorMsg.id model.panelsState }, Cmd.none )

        RequestRemoveErrorMsg msgToRemove ->
            let
                updatedPanelsState =
                    closePanel msgToRemove.id model.panelsState
            in
            ( { model | panelsState = updatedPanelsState }, delay (millisToPosix 1500) (ErrorBoxMsg <| RemoveErrorMsg msgToRemove) )

        RemoveErrorMsg msgToRemove ->
            let
                newErrorMsgs =
                    model.errorMsgs |> List.filter (\modelMsg -> modelMsg.id /= msgToRemove.id)
            in
            ( { model | errorMsgs = newErrorMsgs }, Cmd.none )

        LogErr err ->
            -- let
            --     log =
            --         Debug.log "Error: " err
            -- in
            ( { model | errorMsgs = model.errorMsgs ++ [ "Error" |> createErrorMsg ] }, Cmd.none )
