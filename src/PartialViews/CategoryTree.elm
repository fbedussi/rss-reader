module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)

import Accordion exposing (closeTab, openTab)
import Css exposing (auto, em, flexShrink, height, int, marginRight, middle, verticalAlign, backgroundColor, fill)
import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites, isSelected)
import Html.Styled exposing (Html, a, article, button, div, h2, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)
import PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon, folderIcon)
import PartialViews.UiKit exposing (badge, categoryWrapper, input, sidebarRow, sidebarSelectionBtn, tabContentOuter, theme)


renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    let
        domId =
            "cat_" ++ toString category.id

        selected =
            isSelected model.selectedCategoryId category.id

        log = Debug.log ("selected " ++ domId) selected
        triggerOpenTab =
            if selected then
                openTab ("#" ++ domId)
            else
                closeTab ("#" ++ domId)
    in
    categoryWrapper
        [ class"accordion-item category"
        , id domId
        ]
        (renderViewCategory model category selected)
        

renderViewCategory : Model -> Category -> Bool -> List (Html Msg)
renderViewCategory model category selected =
    let
        sitesInCategory =
            getSitesInCategory category.id model.sites

        articlesInCategory =
            countArticlesInCategory sitesInCategory model.articles

        domId =
            "cat_" ++ toString category.id
    in
    [ deleteActions model.transitionStore category (extractId sitesInCategory)
    , sidebarRow selected
        [ class "categoryButtons accordion-title" ]
        (case model.categoryToEditId of
            Just categoryToEditId ->
                if categoryToEditId == category.id then
                    renderEditCategory model category 
                else
                    renderCaregoryName model category selected sitesInCategory articlesInCategory

            Nothing ->
                renderCaregoryName model category selected sitesInCategory articlesInCategory
        )       
    
    , tabContentOuter selected
        [ class "tabContentOuter" ]
        [ styled ul
            []
            [ class "category-sitesInCategory tabContentInner" ]
            (sitesInCategory
                |> List.map (renderSiteEntry model.selectedSiteId)
            )
        ]
    ]


renderCaregoryName model category selected sitesInCategory articlesInCategory = 
    ([sidebarSelectionBtn
            [ class "categoryBtn"
            , onClick <| ToggleSelectedCategory category.id
            ]
            [ styled span
                [verticalAlign middle
                , marginRight (em 0.5)]
                [ class "icon folderIcon" ]
                [ folderIcon [Css.fill theme.colorPrimary] selected
                ]
            , badge
                [ class "category-numberOfArticles" ]
                [ articlesInCategory
                    |> toString
                    |> text
                ]
            , styled span
                [verticalAlign middle]
                [ class "category-name" ]
                [ text (" " ++ category.name) ]
            ]
    ] ++ (if selected then
                    [categoryButtons model category sitesInCategory]
                else
                    []
               ))

categoryButtons : Model -> Category -> List Site -> Html Msg
categoryButtons model category sitesInCategory =
    span
        [ class "category-action button-group" ]
        [ iconButtonNoStyle (editIcon [fill theme.white]) ( "edit", False ) [ onClick <| EditCategoryId category.id ]
        , iconButtonNoStyle (deleteIcon [fill theme.white])  ( "delete", False ) [ onClick <| ToggleDeleteActions category.id ]
        ]


renderEditCategory : Model -> Category -> List (Html Msg)
renderEditCategory model category =
    [ sidebarRow True
        [ class "editCategoryName accordion-title" ]
        [ styled input
            [ Css.flex (Css.int 1) ]
            [ class "editCategoryName-input"
            , id <| "editCategoryName-" ++ toString category.id
            , value category.name
            , onInput <| UpdateCategoryName category.id
            ]
            []
        , iconButton (checkIcon []) ( "ok", False ) [ onClick EndCategoryEditing ]
        ]
    ]


renderSiteEntry : SelectedSiteId -> Site -> Html Msg
renderSiteEntry selectedSiteId site =
    let
        selected =
            isSelected selectedSiteId site.id
    in
    li
        [ class "category-siteInCategory " ]
        [ sidebarRow selected
            []
            ([ sidebarSelectionBtn
                [ class "siteInCategoryBtn"
                , onClick <| SelectSite site.id
                ]
                [ site.name |> text ]
             ]
                ++ (if selected then
                        [ renderSiteButtons site.id ]
                    else
                        []
                   )
            )
        ]


renderSiteButtons : Id -> Html Msg
renderSiteButtons siteId =
    styled span
        [ flexShrink (int 0) ]
        [ class "siteInCategory-actions button-group" ]
        [ iconButtonNoStyle (editIcon [fill theme.white]) ( "edit", False ) [ onClick <| ChangeEditSiteId <| Just siteId ]
        , iconButtonNoStyle (deleteIcon [fill theme.white]) ( "delete", False ) [ onClick <| DeleteSites [ siteId ] ]
        ]


addParenthesis : String -> String
addParenthesis string =
    "(" ++ string ++ ")"


countArticlesInCategory : List Site -> List Article -> Int
countArticlesInCategory sitesInCategory articles =
    let
        articlesInCategory =
            List.filter (isArticleInSites sitesInCategory) articles
    in
    List.length articlesInCategory

