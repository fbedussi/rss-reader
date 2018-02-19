module PartialViews.SearchResult exposing (searchResult)

import Html.Styled exposing (Html, div, input, ul, styled)
import Html.Styled.Attributes exposing (class)
import Models exposing (SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.CategoryTree exposing (renderSiteEntry)
import PartialViews.UiKit exposing (sidebarBoxStyle)


searchResult : SelectedSiteId -> List Site -> String -> Html Msg
searchResult selectedSiteId sites searchTerm =
    let
        selectedSites =
            sites |> List.filter (\site -> not (String.isEmpty searchTerm) && String.contains (String.toLower searchTerm) (String.toLower site.name))
    in
    styled ul
        [sidebarBoxStyle]
        [ class "searchResult" ]
        (selectedSites |> List.map (renderSiteEntry selectedSiteId)) 
