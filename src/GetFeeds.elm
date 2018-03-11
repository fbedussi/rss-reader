module GetFeeds exposing (getFeeds)

import Decoder exposing (feedDecoder)
import Http exposing (Error, encodeUri)
import Models exposing (..)
import Task exposing (Task, sequence)


getFeeds : List Site -> List (Cmd Msg)
getFeeds sites =
    sites
        |> List.map (\site -> Task.attempt GetArticles (getSiteFeed site))


getSiteFeed : Site -> Task String (List Article)
getSiteFeed site =
    Http.get
        ("//api.rss2json.com/v1/api.json?rss_url=" ++ encodeUri site.rssLink)
        (feedDecoder site.id)
        |> Http.toTask
        |> Task.mapError (\err -> "Error reading feeds for site: " ++ site.name)
