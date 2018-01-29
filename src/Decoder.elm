module Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser)

import Json.Decode exposing (..)
import Models exposing (..)


decodeDbOpened : Value -> Result String Bool
decodeDbOpened value =
    decodeValue bool value


decodeUser : Value -> Result String UserUid
decodeUser value =
    decodeValue string value


decodeData : Value -> Result String (List Category)
decodeData value =
    decodeValue categoriesDecoder value


categoriesDecoder : Decoder (List Category)
categoriesDecoder =
    list categoryDecoder


categoryDecoder : Decoder Category
categoryDecoder =
    map2 Category
        (field "id" Json.Decode.int)
        (field "name" Json.Decode.string)


decodeError : Value -> Result String String
decodeError err =
    decodeValue string err
