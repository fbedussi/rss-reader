module PartialViews.MainContent exposing (..)

import Css exposing (Style, auto, batch, block, calc, center, display, displayFlex, flex, float, height, hidden, inline, int, justifyContent, left, margin3, marginBottom, marginLeft, maxHeight, maxWidth, minus, none, overflow, pct, px, rem, spaceBetween, textAlign, width, zero, important, backgroundColor)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, type_)
import Html.Styled.Events exposing (onClick)
import Models exposing (Article, Category, Model, Msg(..), Site)
import PartialViews.Article exposing (renderArticle)
import PartialViews.UiKit exposing (btn, clear, standardPadding, starBtn, theme, selectableBtn)


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
        [ width (pct 75)
        , maxWidth <| calc (pct 100) minus (Css.rem 25)
        , standardPadding
        ]
        [ class "mainContent" ]
        [ ul
            [ class "selectedArticles" ]
            (articlesToDisplay
                |> List.map (renderArticle model.articlePreviewHeight model.sites)
            )
        , renderPagination articlesToDisplay model.appData.articlesPerPage model.currentPage lastPage
        ]


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
    