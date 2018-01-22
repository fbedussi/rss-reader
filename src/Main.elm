module Main exposing (..)

import Html exposing (Html)
import Models exposing (Model, init)
import Msgs exposing (..)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
