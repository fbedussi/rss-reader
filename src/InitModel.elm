module InitModel exposing (..)

import Http exposing (Error)
import Json.Decode exposing (..)
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (Msg)


init : ( Model, Cmd Msg )
init =
    ( Model
        [ exampleCategory 1, exampleCategory 2 ]
        [ exampleSite 1, exampleSite 2 ]
        [ exampleArticle 1, exampleArticle 2 ]
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
    , Http.send Msgs.GetArticles <|
        Http.get
            "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Ftechcrunch.com%2Ffeed%2F"
            feedDecoder
    )



-- TEMP DUMMY DATA
-- getFeed : Http.Request Feed
-- getFeed =
--     Http.get "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Ftechcrunch.com%2Ffeed%2F" feedDecoder


type alias Feed =
    List Article


decodeFeed : Value -> Result String Feed
decodeFeed value =
    decodeValue feedDecoder value


feedDecoder : Decoder Feed
feedDecoder =
    field "items" (list articleDecoder)


articleDecoder : Decoder Article
articleDecoder =
    map5 Article
        int
        (field "link" string)
        (field "title" string)
        (field "description" string)
        bool


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
