module Subscriptions exposing (..)

--import Json.Encode

import Models exposing (Model)
import Msgs exposing (..)
import OutsideInfo exposing (getInfoFromOutside)


subscriptions : Model -> Sub Msg
subscriptions model =
    getInfoFromOutside Outside LogErr
