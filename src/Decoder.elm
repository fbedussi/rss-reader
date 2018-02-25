module Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser, feedDecoder)

import Date
import Time exposing (Time)
import Json.Decode exposing (..)
import Models exposing (..)


decodeDbOpened : Value -> Result String Bool
decodeDbOpened value =
    decodeValue bool value


decodeUser : Value -> Result String UserUid
decodeUser value =
    decodeValue string value


decodeData : Value -> Result String Data
decodeData value =
    decodeValue dataDecoder value


dataDecoder : Decoder Data
dataDecoder =
    map3 Data
        (field "categories" categoriesDecoder)
        (field "sites" sitesDecoder)
        (field "articles" articlesDecoder)


categoriesDecoder : Decoder (List Category)
categoriesDecoder =
    list categoryDecoder


sitesDecoder : Decoder (List Site)
sitesDecoder =
    list siteDecoder


articlesDecoder : Decoder (List Article)
articlesDecoder =
    list articleDecoder


categoryDecoder : Decoder Category
categoryDecoder =
    map2 Category
        (field "id" Json.Decode.int)
        (field "name" Json.Decode.string)


siteDecoder : Decoder Site
siteDecoder =
    map6 Site
        (field "id" Json.Decode.int)
        (field "categoriesId" (list Json.Decode.int))
        (field "name" Json.Decode.string)
        (field "rssLink" Json.Decode.string)
        (field "webLink" Json.Decode.string)
        (field "starred" Json.Decode.bool)


articleDecoder : Decoder Article
articleDecoder =
    map7 Article
        (field "id" Json.Decode.int)
        (field "siteId" Json.Decode.int)
        (field "link" Json.Decode.string)
        (field "title" Json.Decode.string)
        (field "excerpt" Json.Decode.string)
        (field "starred" Json.Decode.bool)
        (field "pubDate" dateDecoder)


dateDecoder : Decoder Time
dateDecoder =
    let
        convert : String -> Decoder Time
        convert raw =
            case Date.fromString raw of
                Ok date ->
                    date |> Date.toTime |> succeed

                Err error ->
                    fail error
    in
    string |> andThen convert


decodeError : Value -> Result String String
decodeError err =
    decodeValue string err


feedDecoder : Int -> Decoder (List Article)
feedDecoder siteId =
    field "items" (list (feedArticleDecoder siteId))


feedArticleDecoder : Int -> Decoder Article
feedArticleDecoder siteId =
    map7 Article
        (succeed 0)
        (succeed siteId)
        (field "link" string)
        (field "title" string)
        (field "description" string)
        (succeed False)
        (field "pubDate" dateDecoder)
