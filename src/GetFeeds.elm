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
        |> List.map (\site -> getSiteFeed site)


getSiteFeed : Site -> Cmd Msg
getSiteFeed site =
    Http.get
        { url = "https://rss2json.fbedussi.now.sh/?url=" ++ site.rssLink
        , expect = Http.expectJson (GetArticles site.id) (feedDecoder site.id)
        }
