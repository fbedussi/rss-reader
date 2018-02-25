module PartialViews.MainContent exposing (..)

import Css exposing (auto, block, calc, center, display, displayFlex, flex, float, height, hidden, inline, int, left, margin3, marginBottom, marginLeft, maxHeight, maxWidth, minus, none, overflow, pct, px, rem, textAlign, width, zero)
import Css.Foreign exposing (descendants, selector, typeSelector)
import Date exposing (day, fromTime, month, year)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Attributes
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, type_)
import Html.Styled.Events exposing (onClick)
import Json.Encode
import Models exposing (Article, Category, Model, Msg(..), Site)
import PartialViews.UiKit exposing (article, articleTitle, btn, clear, standardPadding, starBtn, theme)


mainContent : Model -> Html Msg
mainContent model =
    let
        selectedArticles =
            getSelectedArticles model.selectedCategoryId model.selectedSiteId model.sites model.articles

        lastPage =
            List.length selectedArticles // model.articlesPerPage

        articlesToDisplay =
            selectedArticles
                |> List.drop (model.articlesPerPage * (model.currentPage - 1))
                |> List.take model.articlesPerPage
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
        , styled div
            [ textAlign center
            , if List.length articlesToDisplay == model.articlesPerPage then
                display block
              else
                display none
            ]
            [ class "pagerWrapper" ]
            ((if model.currentPage > 1 then
                [ btn
                    [ class "firstPageButton"
                    , onClick <| ChangePage 1
                    ]
                    [ text "<<" ]
                , btn
                    [ class "prevPageButton"
                    , onClick <| ChangePage <| max 1 <| model.currentPage - 1
                    ]
                    [ text "<" ]
                ]
              else
                []
             )
                ++ [ styled span
                        [ marginLeft (Css.em 0.5) ]
                        [ class "currentPage" ]
                        [ text <| toString model.currentPage ++ "/" ++ toString lastPage ]
                   ]
                ++ (if model.currentPage < lastPage then
                        [ btn
                            [ class "nextPageButton"
                            , onClick <| ChangePage <| min lastPage <| model.currentPage + 1
                            ]
                            [ text ">" ]
                        , btn
                            [ class "nextPageButton"
                            , onClick <| ChangePage lastPage
                            ]
                            [ text ">>" ]
                        ]
                    else
                        []
                   )
            )
        ]


renderArticle : Int -> List Site -> Article -> Html Msg
renderArticle articlePreviewHeight sites articleToRender =
    let
        starredLabel =
            if articleToRender.starred then
                "starred"
            else
                ""

        site =
            getArticleSite sites articleToRender

        date =
            fromTime articleToRender.date
    in
    li
        [ class "article" ]
        [ article
            [ class "article"
            , id <| "srticle_" ++ toString articleToRender.id
            ]
            [ styled div
                [ displayFlex
                , marginBottom theme.distanceXXS
                ]
                [ class "starAndSiteAndTitle" ]
                [ starBtn ("starred_" ++ toString articleToRender.id)
                    articleToRender.starred
                    (\checked ->
                        if checked then
                            SaveArticle articleToRender
                        else
                            DeleteArticles [ articleToRender.id ]
                    )
                , div
                    [ class "articleSiteAndTitle" ]
                    [ div
                        [ class "articleDate" ]
                        [ text <| ((toString <| day date) ++ " " ++ (toString <| month date) ++ " " ++ (toString <| year date)) ]
                    , div
                        [ class "articleSite" ]
                        [ text site.name ]
                    , articleTitle
                        [ class "article-title" ]
                        [ a
                            [ class "article-link"
                            , href articleToRender.link
                            , Json.Encode.string articleToRender.title
                                |> Html.Attributes.property "innerHTML"
                                |> fromUnstyled
                            ]
                            []
                        ]
                    ]
                ]
            , styled div
                [ descendants
                    [ typeSelector "img"
                        [ width (Css.rem 13)
                        , height auto
                        , float left
                        , margin3 zero (Css.em 1) (Css.em 1)
                        , clear "both"
                        ]
                    ]
                , maxHeight (Css.rem <| toFloat articlePreviewHeight)
                ]
                [ class "article-excerpt"
                , Json.Encode.string articleToRender.excerpt
                    |> Html.Attributes.property "innerHTML"
                    |> fromUnstyled
                ]
                []
            ]
        ]
