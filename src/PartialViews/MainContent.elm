module PartialViews.MainContent exposing (mainContent, renderChangeNumberOfArticlesPerPageButton, renderPagination, showIf)

import Css exposing (..)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Styled exposing (Html, a, button, div, h2, img, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (alt, checked, class, for, fromUnstyled, href, id, src, type_)
import Html.Styled.Events exposing (onClick)
import Models exposing (Article, Category, Model, Msg(..), Options, Site)
import PartialViews.Article exposing (renderArticle)
import PartialViews.UiKit exposing (btn, clear, onDesktop, selectableBtn, standardPadding, starBtn, theme, visuallyHiddenStyle)


mainContent : List Category -> List Site -> List Article -> Options -> Int -> Html Msg
mainContent categories sites articles options currentPage =
    let
        selectedArticles =
            getSelectedArticles categories sites articles

        lastPage =
            List.length selectedArticles // options.articlesPerPage

        articlesToDisplay =
            selectedArticles
                |> List.drop (options.articlesPerPage * (currentPage - 1))
                |> List.take options.articlesPerPage
    in
    styled main_
        [ standardPadding
        , onDesktop
            [ width (pct 75)
            , maxWidth <| calc (pct 100) minus (Css.rem 25)
            ]
        ]
        [ class "mainContent" ]
        (if List.length articles == 0 then
            [ styled div
                [ backgroundImage (url "/no_articles.svg")
                , backgroundSize contain
                , backgroundRepeat noRepeat
                , backgroundPosition2 (pct 100) zero
                , width (pct 100)
                , height (vh 80)
                ]
                []
                [ styled span
                    [ visuallyHiddenStyle ]
                    []
                    [ text "no article yet, click the refresh button" ]
                ]
            ]

         else if List.length articlesToDisplay > 0 then
            [ ul
                [ class "selectedArticles" ]
                (articlesToDisplay
                    |> List.map (renderArticle options.articlePreviewHeightInEm sites)
                )
            , renderPagination articlesToDisplay options.articlesPerPage currentPage lastPage
            ]

         else
            [ div
                [ class "noArticleSelected" ]
                [ text "No article selected, try to select another site o category" ]
            ]
        )


renderPagination : List Article -> Int -> Int -> Int -> Html Msg
renderPagination articlesToDisplay articlesPerPage currentPage lastPage =
    styled div
        [ textAlign center
        , displayFlex
        , flexDirection columnReverse
        , justifyContent spaceBetween
        , showIf <| List.length articlesToDisplay == articlesPerPage
        , onDesktop
            [ flexDirection row ]
        ]
        [ class "pagerToolbar" ]
        [ styled span
            [ marginBottom (Css.rem 0.5) ]
            [ class "pagerWrapper" ]
            [ styled btn
                [ showIf <| currentPage > 1
                , marginRight (Css.rem 0.5)
                ]
                [ class "firstPageButton"
                , onClick <| ChangePage 1
                ]
                [ text "<<" ]
            , styled btn
                [ showIf <| currentPage > 1
                , marginRight (Css.rem 0.5)
                ]
                [ class "prevPageButton"
                , onClick <| ChangePage <| max 1 <| currentPage - 1
                ]
                [ text "<" ]
            , styled span
                [ marginRight (Css.em 0.5) ]
                [ class "currentPage" ]
                [ text <| String.fromInt currentPage ++ "/" ++ String.fromInt lastPage ]
            , styled btn
                [ showIf <| currentPage < lastPage
                , marginRight (Css.rem 0.5)
                ]
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
        , styled span
            [ marginBottom (Css.rem 0.5) ]
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
    styled span
        [ marginLeft (Css.rem 0.5) ]
        []
        [ selectableBtn (currentArticlesPerPage == newArticlesPerPage)
            [ class "changeNumberOfArticlesPerPageButton"
            , onClick <| ChangeNumberOfArticlesPerPage newArticlesPerPage
            ]
            [ text <| String.fromInt newArticlesPerPage ]
        ]
