module Main exposing (main)

import Browser
import Html.Styled exposing (toUnstyled)
import Models exposing (Model, Msg, init)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
