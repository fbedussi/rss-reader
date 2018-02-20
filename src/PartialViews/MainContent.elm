module PartialViews.MainContent exposing (..)

import Css exposing (auto, displayFlex, flex, float, height, int, left, margin2, marginBottom, px, width, zero, overflow, hidden, maxHeight)
import Css.Foreign exposing (descendants, typeSelector)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Attributes
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, type_)
import Json.Encode
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)
import PartialViews.UiKit exposing (clear, standardPadding, starBtn, theme, articleTitle, article)


mainContent : Model -> Html Msg
mainContent model =
    styled main_
        [ flex (int 1)
        , standardPadding
        ]
        [ class "mainContent" ]
        [ ul
            [ class "selectedArticles" ]
            (getSelectedArticles model.selectedCategoryId model.selectedSiteId model.sites model.articles
                |> List.map (renderArticle model.sites)
            )
        ]


renderArticle : List Site -> Article -> Html Msg
renderArticle sites articleToRender =
    let
        starredLabel =
            if articleToRender.starred then
                "starred"
            else
                ""

        site =
            getArticleSite sites articleToRender
    in
    li
        [ class "article" ]
        [ article
            [ class "article" ]
            [ styled div
                [ displayFlex
                , marginBottom theme.distanceXXS ]
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
                        [ width (px 100)
                        , height auto
                        , float left
                        , margin2 zero (Css.rem 1)
                        ]
                    ]
                ]
                [ class "article-excerpt card-section"
                , Json.Encode.string articleToRender.excerpt
                    |> Html.Attributes.property "innerHTML"
                    |> fromUnstyled
                ]
                []
            ]
        ]
