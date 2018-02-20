module Main exposing (..)

import Html exposing (Html)
import Models exposing (Model, init, Msg)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)
import Html.Styled exposing (toUnstyled)

main : Program Never Model Msg
main =
    Html.program
        { view = view >> toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
