module PartialViews.EditSiteLayer exposing (editSiteLayer)

import Html exposing (Html, a, article, aside, button, div, form, h2, input, label, li, main_, option, select, span, text, ul)
import Html.Attributes exposing (attribute, checked, class, disabled, for, href, id, src, type_, value)
import Html.Events exposing (onClick)
import Models exposing (Article, Category, Model, SelectedCategoryId, SelectedSiteId, Site, createEmptySite)
import Msgs exposing (..)


editSiteLayer : Model -> Html Msg
editSiteLayer model =
    let
        ( layerOpen, siteId, site ) =
            case model.siteToEditId of
                Just id ->
                    ( True, id, getSiteToEdit id model.sites )

                Nothing ->
                    ( False, 0, Just createEmptySite )
    in
    div
        [ class
            ("editSiteLayer layer layer--top "
                ++ (if layerOpen then
                        "is-open"
                    else
                        ""
                   )
            )
        ]
        [ case site of
            Just site ->
                renderEditSiteForm site model.categories

            Nothing ->
                div
                    [ class "error" ]
                    [ text ("Error: no site with id " ++ toString siteId) ]
        ]


getSiteToEdit : Int -> List Site -> Maybe Site
getSiteToEdit siteToEditId sites =
    sites
        |> List.filter (\site -> site.id == siteToEditId)
        |> List.head


renderEditSiteForm : Site -> List Category -> Html Msg
renderEditSiteForm site categories =
    div
        [ class "layer-inner" ]
        [ div
            [ class "editSiteForm" ]
            [ div
                [ class "inputRow" ]
                [ div
                    [ class "inputLabel" ]
                    [ text "Site id: " ]
                , div
                    [ class "input is-disabled" ]
                    [ toString site.id |> text ]
                ]
            , div
                [ class "inputRow" ]
                [ label
                    [ class "inputLabel"
                    , for "siteNameInput"
                    ]
                    [ text "Name: " ]
                , input
                    [ class "input"
                    , id "siteNameInput"
                    , value site.name
                    ]
                    []
                ]
            , div
                [ class "inputRow" ]
                [ label
                    [ class "inputLabel"
                    , for "rssLinkInput"
                    ]
                    [ text "Rss link: " ]
                , input
                    [ class "input"
                    , id "rssLinkInput"
                    , value site.rssLink
                    ]
                    []
                ]
            , div
                [ class "inputRow" ]
                [ label
                    [ class "inputLabel"
                    , for "webLinkInput"
                    ]
                    [ text "Web link: " ]
                , input
                    [ class "input"
                    , id "webLinkInput"
                    , value site.webLink
                    ]
                    []
                ]
            , div
                [ class "inputRow" ]
                [ input
                    [ class "checkbox"
                    , type_ "checkbox"
                    , id "starredCheckbox"
                    , checked site.starred
                    ]
                    []
                , label
                    [ class "checkboxLabel"
                    , for "starredCheckbox"
                    ]
                    [ text "Starred" ]
                ]
            , div
                [ class "inputRow" ]
                [ select
                    [ class "siteCategorySelect" ]
                    (option
                        []
                        [ text "Select site category" ]
                        :: (categories
                                |> List.map renderCategoryOptions
                           )
                    )
                ]
            , button
                [ class "button"
                , onClick EndEditSite
                ]
                [ text "close" ]
            ]
        ]


renderCategoryOptions : Category -> Html Msg
renderCategoryOptions category =
    option
        [ toString category.id |> value ]
        [ text category.name ]
