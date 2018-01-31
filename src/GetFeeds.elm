module GetFeeds exposing (getFeeds)

import Decoder exposing (feedDecoder)
import Http exposing (Error, encodeUri)
import Models exposing (..)
import Msgs exposing (..)
import Task exposing (Task, sequence)


getFeeds : List Site -> Cmd Msg
getFeeds sites =
    sites
        |> List.map getSiteFeed
        |> Task.sequence
        |> Task.attempt GetArticles


getSiteFeed : Site -> Task Error (List Article)
getSiteFeed site =
    Http.get
        ("https://api.rss2json.com/v1/api.json?rss_url=" ++ encodeUri site.rssLink)
        (feedDecoder site.id)
        |> Http.toTask
