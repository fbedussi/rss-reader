module PartialViews.EditSiteLayer exposing (editSiteLayer)

import Css exposing (displayFlex, flex, int, justifyContent, spaceBetween)
import Html.Styled exposing (Html, a, article, aside, button, div, form, h2, label, li, main_, option, select, span, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, checked, class, disabled, for, href, id, selected, src, type_, value)
import Html.Styled.Events exposing (on, onClick, onInput, targetChecked)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site, createEmptySite, Msg(..))
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (deleteIcon)
import PartialViews.UiKit exposing (btn, input, inputRow, layerInner, layerTop)


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
    layerTop
        [ class "editSiteLayer" ]
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
    layerInner
        []
        [ inputRow
            []
            [ div
                [ class "inputLabel" ]
                [ text "Site id: " ]
            , div
                [ class "input is-disabled" ]
                [ toString site.id |> text ]
            ]
        , inputRowText "Name" "siteNameInput" site.name (\name -> UpdateSite { site | name = name })
        , inputRowText "Rss link" "rssLinkInput" site.rssLink (\rssLink -> UpdateSite { site | rssLink = rssLink })
        , inputRowText "Web link" "webLinkInput" site.webLink (\webLink -> UpdateSite { site | webLink = webLink })
        , inputRow
            []
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
        , inputRow
            []
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
        , styled div
            [ displayFlex
            , justifyContent spaceBetween
            ]
            []
            [ btn
                [ onClick (ChangeEditSiteId Nothing) ]
                [ text "close" ]
            , iconButton (deleteIcon []) ( "delete", True ) [ onClick (DeleteSites [ site.id ]) ]
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


inputRowText : String -> String -> String -> (String -> msg) -> Html msg
inputRowText idText labelText val inputHandler =
    inputRow
        []
        [ styled label
            [ flex (int 1) ]
            [ class "inputLabel"
            , for idText
            ]
            [ text (labelText ++ ": ") ]
        , styled input
            [flex (int 5)]
            [ class "input"
            , id idText
            , value val
            , onInput inputHandler
            , type_ "text"
            ]
            []
        ]
