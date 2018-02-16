module Main exposing (..)

import Html exposing (Html)
import InitModel exposing (init)
import Models exposing (Model)
import Msgs exposing (..)
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
