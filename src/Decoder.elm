module Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeScrollTop, decodeUser, feedDecoder)

import Iso8601
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
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
    succeed Site
        |> required "id" int
        |> required "categoriesId" (list Json.Decode.int)
        |> required "name" string
        |> required "rssLink" string
        |> required "webLink" string
        |> required "starred" bool
        |> hardcoded False
        |> hardcoded 0
        |> optional "isActive" bool True
        |> optional "numberOfFailures" int 0


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
    map3 Options
        (oneOf [ field "articlesPerPage" Json.Decode.int, succeed initialModel.options.articlesPerPage ])
        (oneOf [ field "articlePreviewHeightInEm" Json.Decode.float, succeed initialModel.options.articlePreviewHeightInEm ])
        (oneOf [ field "maxNumberOfFailures" Json.Decode.int, succeed initialModel.options.maxNumberOfFailures ])


decodeError : Value -> Result Error String
decodeError err =
    decodeValue string err


feedDecoder : Decoder (List Article)
feedDecoder =
    field "items" (list feedArticleDecoder)


feedArticleDecoder : Decoder Article
feedArticleDecoder =
    map8 Article
        (succeed 0)
        (field "siteId" int)
        (field "link" string)
        (field "title" string)
        (field "content" string)
        (succeed False)
        (field "isoDate" Iso8601.decoder)
        (succeed False)


decodeScrollTop : Value -> Result Error Int
decodeScrollTop scrollTopJson =
    decodeValue int scrollTopJson
