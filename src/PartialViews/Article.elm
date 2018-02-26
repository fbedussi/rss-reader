module PartialViews.Article exposing (renderArticle)

import Css exposing (auto, block, calc, center, display, displayFlex, flex, float, height, hidden, inline, int, left, margin3, marginBottom, marginLeft, maxHeight, maxWidth, minus, none, overflow, pct, px, rem, textAlign, width, zero)
import Css.Foreign exposing (descendants, selector, typeSelector)
import Date exposing (day, fromTime, month, year)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Attributes
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, target, type_)
import Json.Encode
import Models exposing (Article, Category, Model, Msg(..), Site)
import PartialViews.UiKit exposing (article, articleTitle, clear, standardPadding, starBtn, theme)


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
                [ class "starAndArticle" ]
                [ starBtn ("starred_" ++ toString articleToRender.id)
                    articleToRender.starred
                    (\checked ->
                        if checked then
                            SaveArticle articleToRender
                        else
                            DeleteArticles [ articleToRender.id ]
                    )
                , div
                    [ class "article-content" ]
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
                            , target "_blank"
                            , Json.Encode.string articleToRender.title
                                |> Html.Attributes.property "innerHTML"
                                |> fromUnstyled
                            ]
                            []
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

                        --, maxHeight (Css.rem <| toFloat articlePreviewHeight)
                        ]
                        [ class "article-excerpt"
                        , Json.Encode.string articleToRender.excerpt
                            |> Html.Attributes.property "innerHTML"
                            |> fromUnstyled
                        ]
                        []
                    ]
                ]
            ]
        ]
