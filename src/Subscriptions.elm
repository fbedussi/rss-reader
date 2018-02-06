module Subscriptions exposing (..)

--import Json.Encode

import Models exposing (Model)
import Msgs exposing (..)
import OutsideInfo exposing (getInfoFromOutside)
import Transit


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ getInfoFromOutside Outside LogErr
        , Transit.subscriptions TransitMsg model
        ]
