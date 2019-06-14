module GetFeeds exposing (getFeeds)

import Decoder exposing (feedDecoder)
import Http exposing (Error)
import Models exposing (..)
import Task exposing (Task, sequence)
import Url


getFeeds : List Site -> List (Cmd Msg)
getFeeds sites =
    sites
        |> List.filter (\site -> site.isActive)
        |> List.map (\site -> Task.attempt (GetArticles site.id) (getSiteFeed site))


getSiteFeed : Site -> Task String (List Article)
getSiteFeed site =
    Http.get
        ("https://rss2json.fbedussi.now.sh/?url=" ++ site.rssLink)
        (feedDecoder site.id)
        |> Http.toTask
        |> Task.mapError
            (\err ->
                -- let
                --     log =
                --         "Error reading from site " ++ site.name ++ ": " ++ Debug.toString err |> Debug.log
                -- in
                "Error reading feeds for site: " ++ site.name
            )
