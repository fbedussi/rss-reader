module PartialViews.SearchResult exposing (searchResult)

import Html.Styled exposing (Html, div, input, ul, text, styled)
import Html.Styled.Attributes exposing (class)
import Models exposing (SelectedSiteId, Site, Msg)
import PartialViews.CategoryTree exposing (renderSiteEntry)
import PartialViews.UiKit exposing (sidebarBoxStyle)


searchResult : SelectedSiteId -> List Site -> String -> Html Msg
searchResult selectedSiteId sites searchTerm =
    let
        selectedSites =
            sites |> List.filter (\site -> not (String.isEmpty searchTerm) && String.contains (String.toLower searchTerm) (String.toLower site.name))

        searchInProgress =
            String.length searchTerm > 0
    in
    styled ul
        (if searchInProgress then [sidebarBoxStyle] else [])
        [ class "searchResult" ]
        (if List.length selectedSites > 0
        then selectedSites |> List.map (renderSiteEntry selectedSiteId)
        else if searchInProgress
        then [ text "no sites found"]
        else []
        ) 
