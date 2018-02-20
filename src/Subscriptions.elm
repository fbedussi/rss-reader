module Subscriptions exposing (..)

import Models exposing (Model, Msg(..))
import OutsideInfo exposing (getInfoFromOutside)


subscriptions : Model -> Sub Msg
subscriptions model =
    getInfoFromOutside Outside LogErr
