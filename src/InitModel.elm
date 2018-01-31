module InitModel exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg)


init : ( Model, Cmd Msg )
init =
    ( Model
        ""
        []
        []
        []
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
    , Cmd.none
    )
