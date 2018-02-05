module Subscriptions exposing (..)

--import Json.Encode

import AnimationFrame
import Models exposing (ElementVisibility(..), Model)
import Msgs exposing (..)
import OutsideInfo exposing (getInfoFromOutside)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ getInfoFromOutside Outside LogErr
        , if model.elementVisibility == OverrideNone || model.elementVisibility == OverrideNoneBack then
            AnimationFrame.times Tick
          else
            Sub.none
        ]
