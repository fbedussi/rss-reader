module PartialViews.Article exposing (renderArticle)

import Css exposing (..)
import Css.Foreign exposing (descendants, selector, typeSelector)
import Css.Media exposing (only, screen, withMedia)
import Date exposing (day, fromTime, month, year)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Attributes
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, target, type_)
import Html.Styled.Events exposing (onClick)
import Json.Encode
import Models exposing (Article, Category, Model, Msg(..), Site)
import PartialViews.UiKit exposing (article, articleTitle, clear, standardPadding, starBtn, theme, btn, transition)


renderArticle : Float -> List Site -> Article -> Html Msg
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

        domId = 
            "article_" ++ toString articleToRender.id
    in
    li
        [ class "article" ]
        [ article
            [ class "article"
            , id domId
            ]
            [ styled div
                [ marginBottom theme.distanceXXS
                , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                    [ displayFlex ]
                ]
                [ class "starAndArticle" ]
                [ styled span
                    [ position absolute
                    , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                        [ position static
                        , marginRight (Css.em 0.5)
                         ]
                    ]
                    []
                    [ starBtn ("starred_" ++ toString articleToRender.id)
                        articleToRender.starred
                        (\checked ->
                            if checked then
                                SaveArticle articleToRender
                            else
                                DeleteArticles [ articleToRender.id ]
                        )
                    ]
                , styled div
                    [ withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ]]
                        [width <| calc (pct 100) minus (calc (Css.rem 2.05) plus (Css.em 0.5))]
                    ]
                    [ class "article-content" ]
                    [ styled div
                        [marginLeft (Css.rem 2)
                        , withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                            [ marginLeft zero ]
                        ]
                        [class "articleDateAndSite"]
                        [div
                            [ class "articleDate" ]
                            [ text <| ((toString <| day date) ++ " " ++ (toString <| month date) ++ " " ++ (toString <| year date)) ]
                        , div
                            [ class "articleSite" ]
                            [ text site.name ]
                        ]
                    , articleTitle
                        [ class "article-title" ]
                        [ a
                            [ class "article-link"
                            , href articleToRender.link
                            , Html.Styled.Attributes.target "_blank"
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
                                , margin4 zero (Css.em 1) (Css.em 1) zero
                                , clear "both"
                                ]
                            ]
                        , maxHeight (Css.em  articlePreviewHeight)
                        , transition "max-height 0.3s"
                        , overflow hidden
                        ]
                        [ class "article-excerpt"]
                        [div 
                            [class "article-excerptInner"
                            , Json.Encode.string articleToRender.excerpt
                                |> Html.Attributes.property "innerHTML"
                                |> fromUnstyled
                            ]
                            []
                        ]
                    , btn
                        [ class "readMoreButton"
                            , onClick <| OpenExcerpt domId]
                        [text "read more"]
                    ]
                ]
            ]
        ]
