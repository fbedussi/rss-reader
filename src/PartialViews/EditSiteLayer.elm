module PartialViews.EditSiteLayer exposing (editSiteLayer)

import Css exposing (displayFlex, flex, int, justifyContent, marginLeft, spaceBetween)
import Html.Styled exposing (Html, a, article, aside, button, div, form, h2, label, li, main_, option, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (attribute, checked, class, disabled, for, href, id, selected, src, type_, value)
import Html.Styled.Events exposing (on, onClick, onInput, targetChecked)
import Models exposing (Article, Category, DeleteMsg(..), EditSiteMsg(..), Id, Model, Msg(..), SelectedCategoryId, SelectedSiteId, Site, createEmptySite)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (deleteIcon)
import PartialViews.UiKit exposing (btn, checkbox, input, inputRow, inputRowLabel, inputRowText, layerInner, layerTop, secondaryBtn, select)


editSiteLayer : String -> Site -> List Category -> Html Msg
editSiteLayer animationClass site categories =
    layerTop (EditSiteMsg CloseEditSitePanel)
        [ class <| "editSiteLayer" ++ animationClass ]
        [ renderEditSiteForm site categories ]


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
                [ String.fromInt site.id ++ " - Number of failures: " ++ String.fromInt site.numberOfFailures |> text ]
            ]
        , inputRowText "siteNameInput" "Name" site.name (\name -> EditSiteMsg <| UpdateSite { site | name = name })
        , inputRowText "rssLinkInput" "Rss link" site.rssLink (\rssLink -> EditSiteMsg <| UpdateSite { site | rssLink = rssLink })
        , inputRowText "webLinkInput" "Web link" site.webLink (\webLink -> EditSiteMsg <| UpdateSite { site | webLink = webLink })
        , inputRow
            []
            [ styled span
                [ flex (int 1) ]
                [ class "fakeCheckboxLabel" ]
                [ text "Starred" ]
            , styled span
                [ flex (int 5) ]
                []
                [ checkbox "starredCheckbox" site.starred (onClick <| EditSiteMsg <| UpdateSite { site | starred = not site.starred }) ]
            ]
        , inputRow
            []
            [ styled span
                [ flex (int 1) ]
                [ class "fakeCheckboxLabel" ]
                [ text "Active" ]
            , styled span
                [ flex (int 5) ]
                []
                [ checkbox "activeCheckbox" site.isActive (onClick <| EditSiteMsg <| UpdateSite { site | isActive = not site.isActive }) ]
            ]
        , inputRow
            []
            [ inputRowLabel "selectCategory" "Select a category"
            , styled select
                [ flex (int 5) ]
                [ class "siteCategorySelect"
                , onInput (\categoryId -> EditSiteMsg <| UpdateSite { site | categoriesId = [ convertCategoryIdToInt categoryId ] })
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
                    [ text "Pick a category" ]
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
            [ span
                []
                [ btn
                    [ onClick <| EditSiteMsg SaveSite ]
                    [ text "save" ]
                ]
            , iconButton (deleteIcon []) ( "delete", True ) [ onClick <| DeleteMsg <| RequestDeleteSites [ site.id ] ]
            ]
        ]


renderCategoryOptions : List Id -> Category -> Html Msg
renderCategoryOptions siteCategoriesId category =
    option
        [ String.fromInt category.id |> value
        , selected
            (if List.member category.id siteCategoriesId then
                True

             else
                False
            )
        ]
        [ text category.name ]


convertCategoryIdToInt string =
    String.toInt string |> Maybe.withDefault 0
