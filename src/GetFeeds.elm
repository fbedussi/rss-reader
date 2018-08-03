module GetFeeds exposing (getFeeds)

import Http exposing (Error, encodeUri)
import Models exposing (..)
import Task exposing (Task, sequence)
import Json.Decode as JD

getFeeds : List Site -> List (Cmd Msg)
getFeeds sites =
    sites
        |> List.map (\site -> Task.attempt (GetArticles site.id) (getSiteFeed site))


getSiteFeed : Site -> Task String String
getSiteFeed site =
    Http.getString site.rssLink
        |> Http.toTask
        |> Task.mapError (\err -> "Error reading feeds for site: " ++ site.name)


resultToString =
    JD.string