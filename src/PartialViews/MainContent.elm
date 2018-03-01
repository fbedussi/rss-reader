module PartialViews.MainContent exposing (..)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul, img)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, type_, src, alt)
import Html.Styled.Events exposing (onClick)
import Models exposing (Article, Category, Model, Msg(..), Site)
import PartialViews.Article exposing (renderArticle)
import PartialViews.UiKit exposing (btn, clear, selectableBtn, standardPadding, starBtn, theme, visuallyHiddenStyle)


mainContent : Model -> Html Msg
mainContent model =
    let
        selectedArticles =
            getSelectedArticles model.selectedCategoryId model.selectedSiteId model.sites model.articles

        lastPage =
            List.length selectedArticles // model.appData.articlesPerPage

        articlesToDisplay =
            selectedArticles
                |> List.drop (model.appData.articlesPerPage * (model.currentPage - 1))
                |> List.take model.appData.articlesPerPage
    in
    styled main_
        [ standardPadding
        , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
            [ width (pct 75)
            , maxWidth <| calc (pct 100) minus (Css.rem 25)
            ]
        ]
        [ class "mainContent" ]
        (
        if List.length model.articles == 0 
        then
            [ styled div 
                [backgroundImage (url "/no_articles.svg")
                , backgroundSize contain
                , backgroundRepeat noRepeat
                , width (pct 100)
                , height (vh 80)
                , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                    [backgroundImage (url "/no_articles_desktop.svg")]
                ]
                [] 
                [styled span
                    [visuallyHiddenStyle]
                    []
                    [text "no article yet, click the refresh button"]
                ]
            ]
        else if List.length articlesToDisplay > 0 
        then 
            [ ul
                [ class "selectedArticles" ]
                (articlesToDisplay
                    |> List.map (renderArticle model.articlePreviewHeight model.sites)
                )
            , renderPagination articlesToDisplay model.appData.articlesPerPage model.currentPage lastPage
            ]
        else 
            [div
                [class "noArticleSelected"]
                [text "No article selected, try to select another site o category"]
            ]
        )


renderPagination : List Article -> Int -> Int -> Int -> Html Msg
renderPagination articlesToDisplay articlesPerPage currentPage lastPage =
    styled div
        [ textAlign center
        , displayFlex
        , justifyContent spaceBetween
        , showIf <| List.length articlesToDisplay == articlesPerPage
        ]
        [ class "pagerToolbar" ]
        [ span
            [ class "pagerWrapper" ]
            [ styled btn
                [ showIf <| currentPage > 1 ]
                [ class "firstPageButton"
                , onClick <| ChangePage 1
                ]
                [ text "<<" ]
            , styled btn
                [ showIf <| currentPage > 1 ]
                [ class "prevPageButton"
                , onClick <| ChangePage <| max 1 <| currentPage - 1
                ]
                [ text "<" ]
            , styled span
                [ marginLeft (Css.em 0.5) ]
                [ class "currentPage" ]
                [ text <| toString currentPage ++ "/" ++ toString lastPage ]
            , styled btn
                [ showIf <| currentPage < lastPage ]
                [ class "nextPageButton"
                , onClick <| ChangePage <| min lastPage <| currentPage + 1
                ]
                [ text ">" ]
            , styled btn
                [ showIf <| currentPage < lastPage ]
                [ class "nextPageButton"
                , onClick <| ChangePage lastPage
                ]
                [ text ">>" ]
            ]
        , span
            [ class "changeNumberOfArticlesPerPageButtonsWrapper" ]
            ([ span
                [ class "articlesPerPageLabel" ]
                [ text "articles per page " ]
             ]
                ++ List.map (renderChangeNumberOfArticlesPerPageButton articlesPerPage) [ 10, 25, 50 ]
            )
        ]


showIf : Bool -> Style
showIf condition =
    if condition then
        batch []
    else
        display none |> important


renderChangeNumberOfArticlesPerPageButton : Int -> Int -> Html Msg
renderChangeNumberOfArticlesPerPageButton currentArticlesPerPage newArticlesPerPage =
    selectableBtn (currentArticlesPerPage == newArticlesPerPage)
        [ class "changeNumberOfArticlesPerPageButton"
        , onClick <| ChangeNumberOfArticlesPerPage newArticlesPerPage
        ]
        [ text <| toString newArticlesPerPage ]
