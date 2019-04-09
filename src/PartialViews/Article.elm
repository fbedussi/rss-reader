module PartialViews.Article exposing (renderArticle)

import Css exposing (..)
import Css.Global exposing (descendants, selector, typeSelector)
-- import Date exposing (day, fromTime, month, year)
import Time exposing (toDay, toMonth, toYear, utc)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Attributes
import Html.Attributes.Aria exposing (ariaHidden)
import Html.Styled exposing (Html, a, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, target, type_)
import Html.Styled.Events exposing (onClick)
-- import HtmlParser as HtmlParser exposing (..)
-- import HtmlParser.Util exposing (..)
import Html.Parser
import Json.Encode
import Models exposing (Article, Category, DeleteMsg(..), Model, Msg(..), Site, toEnglishMonth)
import PartialViews.UiKit exposing (article, articleTitle, btn, clear, onDesktop, standardPadding, starBtn, theme, transition)


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
            "article_" ++ String.fromInt articleToRender.id

        articleExcerptParsed =
            Html.parser.run articleToRender.excerpt

        imageUrl =
            articleExcerptParsed
                |> getElementsByTagName "img"
                |> mapElements (\_ attr _ -> getValue "src" attr |> Maybe.withDefault "")
                |> List.head
                |> Maybe.withDefault ""
    in
    li
        [ class "article" ]
        [ article
            [ class "article"
            , id domId
            ]
            [ styled div
                [ marginBottom theme.distanceXXS
                , onDesktop
                    [ displayFlex ]
                ]
                [ class "starAndArticle" ]
                [ styled span
                    [ position absolute
                    , onDesktop
                        [ position static
                        , marginRight (Css.em 0.5)
                        ]
                    ]
                    []
                    [ starBtn ("starred_" ++ String.fromInt articleToRender.id)
                        articleToRender.starred
                        (\checked ->
                            if checked then
                                SaveArticle articleToRender

                            else
                                DeleteArticles [ articleToRender.id ] |> DeleteMsg
                        )
                    ]
                , styled div
                    [ onDesktop
                        [ width <| calc (pct 100) minus (calc (Css.rem 2.05) plus (Css.em 0.5)) ]
                    ]
                    [ class "article-content" ]
                    [ styled div
                        [ marginLeft (Css.rem 2)
                        , onDesktop
                            [ marginLeft zero ]
                        ]
                        [ class "articleDateAndSite" ]
                        [ div
                            [ class "articleDate" ]
                            [ text <| ((String.fromInt <| toDay utc date) ++ " " ++ (toEnglishMonth <| toMonth utc date) ++ " " ++ (String.fromInt <| toTear utc date)) ]
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
                    , articleImage imageUrl
                    , styled div
                        [ descendants
                            [ typeSelector "img"
                                [ display none ]
                            ]
                        , maxHeight (Css.em articlePreviewHeight)
                        , transition "max-height 0.3s"
                        , overflow hidden
                        ]
                        [ class "article-excerpt" ]
                        [ styled div
                            []
                            [ class "article-excerptInner" ]
                            (articleExcerptParsed
                                |> toVirtualDom
                                |> List.map (\el -> Html.Styled.fromUnstyled el)
                            )
                        ]
                    , styled btn
                        [ marginTop theme.distanceXXS
                        , opacity zero
                        , transition "opacity 0.3s"
                        ]
                        [ class "readMoreButton"
                        , onClick <| ToggleExcerpt articleToRender.id domId <| not articleToRender.isOpen
                        , ariaHidden True |> Html.Styled.Attributes.fromUnstyled
                        ]
                        [ text <|
                            if articleToRender.isOpen then
                                "read less"

                            else
                                "read more"
                        ]
                    ]
                ]
            ]
        ]


articleImage : String -> Html msg
articleImage imageUrl =
    if String.isEmpty imageUrl then
        text ""

    else
        styled div
            [ backgroundImage <| url imageUrl
            , width (Css.rem 13)
            , height (Css.rem 9)
            , backgroundSize cover
            , backgroundRepeat noRepeat
            , backgroundPosition center
            , margin4 zero theme.distanceXXS theme.distanceXXS zero
            , clear "both"
            , borderRadius (px 3)
            , onDesktop
                [ float left ]
            ]
            [ class "article-image" ]
            []
