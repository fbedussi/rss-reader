module PartialViews.SearchResult exposing (searchResult)

import Html
import Html.Styled exposing (Html, div, fromUnstyled, input, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (class)
import Models exposing (Article, Msg, SelectedSiteId, Site)
import PartialViews.CategoryTree exposing (renderSiteEntry)
import PartialViews.UiKit exposing (sidebarBoxStyle)


searchResult : List Site -> String -> Html.Html Msg
searchResult sites searchTerm =
    let
        selectedSites =
            sites |> List.filter (\site -> not (String.isEmpty searchTerm) && String.contains (String.toLower searchTerm) (String.toLower site.name))

        searchInProgress =
            String.length searchTerm > 0
    in
    toUnstyled <|
        styled ul
            (if searchInProgress then
                [ sidebarBoxStyle ]

             else
                []
            )
            [ class "searchResult" ]
            (if List.length selectedSites > 0 then
                selectedSites |> List.map (renderSiteEntry >> fromUnstyled)

             else if searchInProgress then
                [ text "no sites found" ]

             else
                []
            )
