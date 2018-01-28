module Main exposing (..)

import Html exposing (Html)
import InitModel exposing (init)
import Models exposing (Model)
import Msgs exposing (..)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
