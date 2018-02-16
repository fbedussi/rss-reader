module PartialViews.CategoryTree exposing (renderCategory, renderSiteEntry)



import Accordion exposing (closeTab, openTab)
import Helpers exposing (extractId, getClass, getSitesInCategory, isArticleInSites, isSelected)
import Html.Styled exposing (Html, a, article, button, div, h2, input, li, main_, span, text, ul, styled)
import Html.Styled.Attributes exposing (attribute, class, disabled, href, id, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Article, Category, Id, Model, SelectedCategoryId, SelectedSiteId, Site)
import Msgs exposing (..)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (checkIcon, deleteIcon, editIcon, folderIcon)
import PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)
import PartialViews.UiKit exposing (sidebarSelectionBtn, sidebarRow, tabContentOuter)
import Css exposing (flexShrink, int)

renderCategory : Model -> Category -> Html Msg
renderCategory model category =
    let
        domId =
            "cat_" ++ toString category.id

        selected =
            isSelected model.selectedCategoryId category.id

        triggerOpenTab =
            if selected then
                openTab ("#" ++ domId)
            else
                closeTab ("#" ++ domId)
    in
    li
        [ class
            ("accordion-item category "
                ++ (if selected then
                        "is-selected"
                    else
                        ""
                   )
            )
        , attribute "data-accordion-item" ""
        , id domId
        ]
        (case model.categoryToEditId of
            Just categoryToEditId ->
                if categoryToEditId == category.id then
                    renderEditCategory model category
                else
                    renderViewCategory model category

            Nothing ->
                renderViewCategory model category
        )


renderViewCategory : Model -> Category -> List (Html Msg)
renderViewCategory model category =
    let
        sitesInCategory =
            getSitesInCategory category.id model.sites

        articlesInCategory =
            countArticlesInCategory sitesInCategory model.articles

        domId =
            "cat_" ++ toString category.id
    in
    [ deleteActions model.transitionStore category (extractId sitesInCategory) 
    , sidebarRow
        [ class "categoryButtons accordion-title" ]
        [ sidebarSelectionBtn
            [ class "categoryBtn"
            , onClick <| SelectCategory category.id
            ]
            [ span 
                [ class "icon folderIcon"]
                [ folderIcon]
            , span
                [ class "category-numberOfArticles badge primary" ]
                [ articlesInCategory
                    |> toString
                    |> text
                ]
            , span
                [ class "category-name" ]
                [ text (" " ++ category.name) ]
            ]
        , categoryButtons model category sitesInCategory
        ]
    , tabContentOuter
        [ class "tabContentOuter" ]
        [ styled ul
            []
            [ class "category-sitesInCategory tabContentInner" ]
            (sitesInCategory
                |> List.map (renderSiteEntry model.selectedSiteId)
            )
        ]
    ]


categoryButtons : Model -> Category -> List Site -> Html Msg
categoryButtons model category sitesInCategory =
    span
        [ class "category-action button-group" ]
        [ iconButton editIcon ("edit", False) [ onClick <| EditCategoryId category.id]
        , iconButton deleteIcon ("delete", False) [onClick <| ToggleDeleteActions category.id]
        ]


renderEditCategory : Model -> Category -> List (Html Msg)
renderEditCategory model category =
    [ span
        [ class "editCategoryName accordion-title" ]
        [ input
            [ class "editCategoryName-input"
            , id <| "editCategoryName-" ++ toString category.id
            , value category.name
            , onInput <| UpdateCategoryName category.id
            ]
            []
        ,  iconButton checkIcon ( "ok", False ) [ onClick EndCategoryEditing ]
        ]
    ]


renderSiteEntry : SelectedSiteId -> Site -> Html Msg
renderSiteEntry selectedSiteId site =
    li
        [ class <| "category-siteInCategory " ++ getClass "is-selected" selectedSiteId site.id ]
        [ sidebarRow
            []
            [ sidebarSelectionBtn
                [ class "siteInCategoryBtn"
                , onClick <| SelectSite site.id
                ]
                [ site.name |> text ]
            , renderSiteButtons site.id
            ]
        ]


renderSiteButtons : Id -> Html Msg
renderSiteButtons siteId =
    styled span
        [flexShrink (int 0)]
        [ class "siteInCategory-actions button-group" ]
        [ iconButton editIcon ( "edit", False ) [ onClick <| ChangeEditSiteId <| Just siteId ]
        , iconButton deleteIcon ( "delete", False ) [ onClick <| DeleteSites [ siteId ] ]
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


selectCategory : Id -> String -> Msg
selectCategory id domSelector =
    let
        triggerOpenTab =
            openTab domSelector

        log =
            Debug.log "domSelector2" domSelector
    in
    SelectCategory id
