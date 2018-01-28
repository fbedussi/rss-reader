module InitModel exposing (..)

import Http exposing (Error)
import Json.Decode exposing (..)
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (Msg)
import Task exposing (sequence)


init : ( Model, Cmd Msg )
init =
    let
        sites =
            [ lffl, js ]

        categories =
            [ linuxCat, jsCat ]
    in
    ( Model
        ""
        categories
        sites
        []
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
    , Task.attempt Msgs.GetArticles <|
        Task.sequence
            [ Http.get
                "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.lffl.org%2Ffeed"
                (feedDecoder 1)
                |> Http.toTask
            , Http.get
                "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.javascript.com%2Ffeed%2Frss"
                (feedDecoder 2)
                |> Http.toTask
            ]
    )



-- TEMP DUMMY DATA
-- getFeed : Http.Request Feed
-- getFeed =
--     Http.get "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Ftechcrunch.com%2Ffeed%2F" feedDecoder
-- decodeFeed : Value -> Result String Feed
-- decodeFeed value =
--     decodeValue feedDecoder value


feedDecoder : Int -> Decoder (List Article)
feedDecoder siteId =
    field "items" (list (articleDecoder siteId))


articleDecoder : Int -> Decoder Article
articleDecoder siteId =
    map5 Article
        (succeed siteId)
        (field "link" string)
        (field "title" string)
        (field "description" string)
        (succeed False)


exampleCategory : Int -> Category
exampleCategory int =
    Category
        int
        ("Category " ++ toString int)


exampleSite : Int -> Site
exampleSite int =
    Site
        int
        [ int ]
        ("Site " ++ toString int)
        "https://www.lffl.org/feed"
        "https://www.lffl.org/"
        False


exampleArticle : Int -> Article
exampleArticle int =
    Article
        int
        "https://www.lffl.org/2018/01/fuchsia-os-google.html"
        ("Title " ++ toString int)
        ("Lorem ipsum dolor hamet " ++ toString int)
        False


linuxCat : Category
linuxCat =
    Category
        1
        "linux"


jsCat : Category
jsCat =
    Category
        2
        "javaScript"


lffl : Site
lffl =
    Site
        1
        [ 1 ]
        "lffl"
        "https://www.lffl.org/feed"
        "https://www.lffl.org/"
        False


js : Site
js =
    Site
        2
        [ 2 ]
        "javascript.com"
        "https://www.javascript.com/feed/rss"
        "https://www.javascript.com"
        False
