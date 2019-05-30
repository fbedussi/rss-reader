module Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser, feedDecoder)

import Iso8601
import Json.Decode exposing (..)
import Models exposing (..)
import Time exposing (millisToPosix)


decodeDbOpened : Value -> Result Error Bool
decodeDbOpened value =
    decodeValue bool value


decodeUser : Value -> Result Error UserUid
decodeUser value =
    decodeValue string value


decodeData : Value -> Result Error Data
decodeData value =
    decodeValue dataDecoder value


dataDecoder : Decoder Data
dataDecoder =
    map5 Data
        (field "categories" categoriesDecoder)
        (field "sites" sitesDecoder)
        (field "articles" articlesDecoder)
        (field "options" appOptionsDecoder)
        (field "lastRefreshedTime" Json.Decode.int |> map millisToPosix)


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
    map5 Category
        (field "id" Json.Decode.int)
        (field "name" Json.Decode.string)
        (succeed False)
        (succeed False)
        (succeed 0)

siteDecoder : Decoder Site
siteDecoder =
    map8 Site
        (field "id" Json.Decode.int)
        (field "categoriesId" (list Json.Decode.int))
        (field "name" Json.Decode.string)
        (field "rssLink" Json.Decode.string)
        (field "webLink" Json.Decode.string)
        (field "starred" Json.Decode.bool)
        (succeed False)
        (succeed 0)


articleDecoder : Decoder Article
articleDecoder =
    map8 Article
        (field "id" Json.Decode.int)
        (field "siteId" Json.Decode.int)
        (field "link" Json.Decode.string)
        (field "title" Json.Decode.string)
        (field "excerpt" Json.Decode.string)
        (field "starred" Json.Decode.bool)
        (field "date" Json.Decode.int |> map millisToPosix)
        (succeed False)


appOptionsDecoder : Decoder Options
appOptionsDecoder =
    map2 Options
        (oneOf [ field "articlesPerPage" Json.Decode.int, succeed initialModel.options.articlesPerPage ])
        (oneOf [ field "articlePreviewHeightInEm" Json.Decode.float, succeed initialModel.options.articlePreviewHeightInEm ])


decodeError : Value -> Result Error String
decodeError err =
    decodeValue string err


feedDecoder : Int -> Decoder (List Article)
feedDecoder siteId =
    field "items" (list (feedArticleDecoder siteId))


feedArticleDecoder : Int -> Decoder Article
feedArticleDecoder siteId =
    map8 Article
        (succeed 0)
        (succeed siteId)
        (field "link" string)
        (field "title" string)
        (field "content" string)
        (succeed False)
        (field "isoDate" Iso8601.decoder)
        (succeed False)
