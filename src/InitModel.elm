module InitModel exposing (..)

import Models exposing (ElementVisibility(..), Model)
import Msgs exposing (Msg)


init : ( Model, Cmd Msg )
init =
    ( Model
        []
        []
        []
        []
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
        False
        ""
        ""
        None
    , Cmd.none
    )
