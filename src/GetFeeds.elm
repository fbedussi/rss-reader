module GetFeeds exposing (getFeeds)

import Decoder exposing (feedDecoder)
import Http exposing (Error)
import Models exposing (..)
import Task exposing (Task, sequence)
import Url
import OutsideInfo exposing (sendInfoOutside)


getFeeds : List Site -> List (Cmd Msg)
getFeeds sites =
    sites
        |> List.filter (\site -> site.isActive)
        |> List.map (\site -> encodeSite site |> GetSiteFeed |> sendInfoOutside)


-- getSiteFeed : Site -> Cmd Msg
-- getSiteFeed site =
--     Http.get
--         { url = "https://rss2json.fbedussi.now.sh/?url=" ++ site.rssLink
--         , expect = Http.expectJson (GetArticles site.id) (feedDecoder site.id)
--         }
