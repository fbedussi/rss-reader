module PartialViews.EditSiteLayer exposing (editSiteLayer)

import Html exposing (Html, a, article, aside, button, div, form, h2, input, label, li, main_, option, select, span, text, ul)
import Html.Attributes exposing (attribute, checked, class, disabled, for, href, id, selected, src, type_, value)
import Html.Events exposing (on, onClick, onInput, targetChecked)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site, createEmptySite)
import Msgs exposing (..)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (deleteIcon)
import TransitionManager exposing (TransitionStore, manageTransitionClass, toTransitionManagerId)

editSiteLayer : Model -> Html Msg
editSiteLayer model =
    let
        site =
            case model.siteToEditId of
                Just id ->
                    getSiteToEdit id model.sites

                Nothing ->
                    Just createEmptySite
    in
    div
        [ class
                ("callout secondary editSiteLayer layer layer--top "
                ++ (toTransitionManagerId "panel" "editSite" |> manageTransitionClass model.transitionStore)
            )
        ]
        [ case site of
            Just site ->
                renderEditSiteForm site model.categories

            Nothing ->
                div
                    [ class "error" ]
                    [ text "Error: no site found" ]
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
                [ class "inputRow cell" ]
                [ div
                    [ class "inputLabel" ]
                    [ text "Site id: " ]
                , div
                    [ class "input is-disabled" ]
                    [ toString site.id |> text ]
                ]
            , div
                [ class "inputRow cell" ]
                [ label
                    [ class "inputLabel"
                    , for "siteNameInput"
                    ]
                    [ text "Name: " ]
                , input
                    [ class "input"
                    , id "siteNameInput"
                    , value site.name
                    , onInput (\name -> UpdateSite { site | name = name })
                    , type_ "text"
                    ]
                    []
                ]
            , div
                [ class "inputRow cell" ]
                [ label
                    [ class "inputLabel"
                    , for "rssLinkInput"
                    ]
                    [ text "Rss link: " ]
                , input
                    [ class "input"
                    , id "rssLinkInput"
                    , onInput (\rssLink -> UpdateSite { site | rssLink = rssLink })
                    , value site.rssLink
                    , type_ "text"
                    ]
                    []
                ]
            , div
                [ class "inputRow cell" ]
                [ label
                    [ class "inputLabel"
                    , for "webLinkInput"
                    ]
                    [ text "Web link: "
                    ]
                , input
                    [ class "input"
                    , id "webLinkInput"
                    , onInput (\webLink -> UpdateSite { site | webLink = webLink })
                    , value site.webLink
                    , type_ "text"
                    ]
                    []
                ]
            , div
                [ class "inputRow cell" ]
                [ input
                    [ class "checkbox"
                    , type_ "checkbox"
                    , id "starredCheckbox"
                    , onClick (UpdateSite { site | starred = not site.starred })
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
                [ class "inputRow cell" ]
                [ select
                    [ class "siteCategorySelect"
                    , onInput (\categoryId -> UpdateSite { site | categoriesId = convertCategoryIdToInt categoryId })
                    ]
                    (option
                        [ selected
                            (if List.isEmpty site.categoriesId then
                                True
                             else
                                False
                            )
                        ]
                        [ text "Select site category" ]
                        :: (categories
                                |> List.map (renderCategoryOptions site.categoriesId)
                           )
                    )
                ]
            , div
                [ class "cell editSite-buttonGroup" ]
                [ button
                    [ class "button"
                    , onClick (ChangeEditSiteId Nothing)
                    ]
                    [ text "close" ]
                , iconButton deleteIcon ( "delete", True ) [ onClick (DeleteSites [ site.id ]) ]
                ]
            ]
        ]


renderCategoryOptions : List Id -> Category -> Html Msg
renderCategoryOptions siteCategoriesId category =
    option
        [ toString category.id |> value
        , selected
            (if List.member category.id siteCategoriesId then
                True
             else
                False
            )
        ]
        [ text category.name ]


convertCategoryIdToInt : String -> List Int
convertCategoryIdToInt string =
    case String.toInt string of
        Ok id ->
            [ id ]

        Err err ->
            []
