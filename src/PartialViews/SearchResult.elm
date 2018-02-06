module PartialViews.SearchResult exposing (searchResult)

import Html exposing (Html, div, input, ul)
import Html.Attributes exposing (class)
import Models exposing (SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryTree exposing (renderSiteEntry)


searchResult : SelectedSiteId -> List Site -> String -> Html Msg
searchResult selectedSiteId sites searchTerm =
    let
        selectedSites =
            sites |> List.filter (\site -> not (String.isEmpty searchTerm) && String.contains (String.toLower searchTerm) (String.toLower site.name))
    in
    ul
        [ class "searchResult" ]
        (selectedSites |> List.map (renderSiteEntry selectedSiteId))
