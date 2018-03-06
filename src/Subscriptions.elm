module Subscriptions exposing (..)

import Models exposing (Model, Msg(..), ErrorBoxMsg(..))
import OutsideInfo exposing (getInfoFromOutside)


subscriptions : Model -> Sub Msg
subscriptions model =
    getInfoFromOutside Outside <| ErrorBoxMsg << LogErr
