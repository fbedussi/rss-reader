module Subscriptions exposing (subscriptions)

import Models exposing (ErrorBoxMsg(..), Model, Msg(..))
import OutsideInfo exposing (getInfoFromOutside)
-- import Window
import Browser


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ getInfoFromOutside Outside <| ErrorBoxMsg << LogErr
        , Browser.events.onResize
            (\{ height, width } ->
                if model.menuOpen then
                    CloseMenu

                else
                    NoOp
            )
        ]
