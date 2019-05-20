module Subscriptions exposing (subscriptions)

import Browser.Events exposing (onResize)
import Models exposing (ErrorBoxMsg(..), Model, Msg(..))
import OutsideInfo exposing (getInfoFromOutside)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ getInfoFromOutside Outside <| ErrorBoxMsg << LogErr
        , onResize
            (\height width ->
                if model.menuOpen then
                    CloseMenu

                else
                    NoOp
            )
        ]
