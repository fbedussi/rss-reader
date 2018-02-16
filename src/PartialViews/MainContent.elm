module PartialViews.MainContent exposing (..)

import Css exposing (flex, int)
import Helpers exposing (getArticleSite, getSelectedArticles)
import Html.Attributes
import Html.Attributes.Aria exposing (ariaLabel)
import Html.Styled exposing (Html, a, article, button, div, h2, input, label, li, main_, span, styled, text, ul)
import Html.Styled.Attributes exposing (checked, class, for, fromUnstyled, href, id, src, type_)
import Html.Styled.Events exposing (onCheck)
import Json.Encode
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)
import PartialViews.Icons exposing (starIcon)


mainContent : Model -> Html Msg
mainContent model =
    styled main_
        [ flex (int 1) ]
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
            [ div
                [ class "card-divider" ]
                [ div
                    [ class
                        ("article-starred "
                            ++ (if articleToRender.starred then
                                    "is-starred"
                                else
                                    ""
                               )
                        )
                    ]
                    [ input
                        [ type_ "checkbox"
                        , id ("starred_" ++ toString articleToRender.id)
                        , onCheck
                            (\checked ->
                                if checked then
                                    SaveArticle articleToRender
                                else
                                    DeleteArticles [ articleToRender.id ]
                            )
                        , checked articleToRender.starred
                        ]
                        []
                    , label
                        [ for ("starred_" ++ toString articleToRender.id)
                        , ariaLabel "starred" |> fromUnstyled
                        ]
                        [ span
                            [ class "icon"
                            ]
                            [ starIcon ]
                        ]
                    ]
                , div
                    [ class "articleSiteAndTitle" ]
                    [ div
                        [ class "articleSite" ]
                        [ text site.name ]
                    , h2
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
            , div
                [ class "article-excerpt card-section"
                , Json.Encode.string articleToRender.excerpt
                    |> Html.Attributes.property "innerHTML"
                    |> fromUnstyled
                ]
                []
            ]
        ]
