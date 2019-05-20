module GetFeeds exposing (getFeeds)

import Decoder exposing (feedDecoder)
import Http exposing (Error)
import Models exposing (..)
import Task exposing (Task, sequence)
import Url


getFeeds : List Site -> List (Cmd Msg)
getFeeds sites =
    sites
        |> List.map (\site -> Task.attempt (GetArticles site.id) (getSiteFeed site))


getSiteFeed : Site -> Task String (List Article)
getSiteFeed site =
    Http.get
        ("https://api.rss2json.com/v1/api.json?rss_url=" ++ Url.percentEncode site.rssLink)
        (feedDecoder site.id)
        |> Http.toTask
        |> Task.mapError (\err -> "Error reading feeds for site: " ++ site.name)
