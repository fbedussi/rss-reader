module Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeScrollTop, decodeUser, feedDecoder)

import Css
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
    succeed Article
        |> required "id" int
        |> required "siteId" int
        |> required "link" string
        |> required "title" string
        |> required "excerpt" string
        |> required "starred" bool
        |> required "date" (int |> map millisToPosix)
        |> hardcoded False
        |> hardcoded initialModel.options.articlePreviewHeightInEm
        |> hardcoded 0


appOptionsDecoder : Decoder Options
appOptionsDecoder =
    map3 Options
        (oneOf [ field "articlesPerPage" Json.Decode.int, succeed initialModel.options.articlesPerPage ])
        (oneOf [ field "articlePreviewHeightInEm" Json.Decode.float, succeed initialModel.options.articlePreviewHeightInEm ])
        (oneOf [ field "maxNumberOfFailures" Json.Decode.int, succeed initialModel.options.maxNumberOfFailures ])


decodeError : Value -> Result Error String
decodeError err =
    decodeValue string err


feedDecoder : Int -> Decoder (List Article)
feedDecoder siteId =
    field "items" (list (feedArticleDecoder siteId))


feedArticleDecoder : Int -> Decoder Article
feedArticleDecoder siteId =
    succeed Article
        |> hardcoded 0
        |> hardcoded siteId
        |> required "link" string
        |> required "title" string
        |> required "content" string
        |> hardcoded False
        |> required "isoDate" Iso8601.decoder
        |> hardcoded False
        |> hardcoded initialModel.options.articlePreviewHeightInEm
        |> hardcoded 0


decodeScrollTop : Value -> Result Error Int
decodeScrollTop scrollTopJson =
    decodeValue int scrollTopJson
