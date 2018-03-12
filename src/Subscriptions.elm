module Subscriptions exposing (..)

import Models exposing (Model, Msg(..), ErrorBoxMsg(..))
import OutsideInfo exposing (getInfoFromOutside)
import Window

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [
        getInfoFromOutside Outside <| ErrorBoxMsg << LogErr
        , Window.resizes (\{height, width} -> if model.menuOpen then CloseMenu else NoOp)
    ]
