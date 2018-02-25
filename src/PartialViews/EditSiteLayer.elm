module PartialViews.EditSiteLayer exposing (editSiteLayer)

import Css exposing (displayFlex, flex, int, justifyContent, spaceBetween)
import Html.Styled exposing (Html, a, article, aside, button, div, form, h2, label, li, main_, option, span, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, checked, class, disabled, for, href, id, selected, src, type_, value)
import Html.Styled.Events exposing (on, onClick, onInput, targetChecked)
import Models exposing (Article, Category, Id, Model, Msg(..), SelectedCategoryId, SelectedSiteId, Site, createEmptySite)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (deleteIcon)
import PartialViews.UiKit exposing (btn, input, inputRow, layerInner, layerTop, select, checkbox)


editSiteLayer : String -> Maybe Site -> List Category -> Html Msg
editSiteLayer animationClass site categories =
    layerTop
        [ class <| "editSiteLayer" ++ animationClass ]
        [ case site of
            Just site ->
                renderEditSiteForm site categories

            Nothing ->
                div
                    [ class "error" ]
                    [ text "Error: no site found" ]
        ]


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
            [ styled span
                [ flex (int 1) ]    
                [ class "fakeCheckboxLabel"]
                [text "Starred"]
            , styled span
                [flex (int 5)]
                []
                [checkbox "starredCheckbox" site.starred (onClick <| UpdateSite { site | starred = not site.starred })]
            ]
        , inputRow
            []
            [ inputRowLabel "selectCategory" "Select a category"
            , styled select
                [ flex (int 5) ]
                [ class "siteCategorySelect"
                , onInput (\categoryId -> UpdateSite { site | categoriesId = convertCategoryIdToInt categoryId })
                , id "selectCategory"
                ]
                (option
                    [ selected
                        (if List.isEmpty site.categoriesId then
                            True
                         else
                            False
                        )
                    ]
                    [ text "Pick a catelgory" ]
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
                [ onClick CloseEditSitePanel ]
                [ text "close" ]
            , iconButton (deleteIcon []) ( "delete", True ) [ onClick (RequestDeleteSites [ site.id ]) ]
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


inputRowLabel : String -> String -> Html msg
inputRowLabel inputId labelText =
    styled label
        [ flex (int 1) ]
        [ class "inputLabel"
        , for inputId
        ]
        [ text (labelText ++ ": ") ]


inputRowText : String -> String -> String -> (String -> msg) -> Html msg
inputRowText idText labelText val inputHandler =
    inputRow
        []
        [ inputRowLabel idText labelText
        , styled input
            [ flex (int 5) ]
            [ class "input"
            , id idText
            , value val
            , onInput inputHandler
            , type_ "text"
            ]
            []
        ]
