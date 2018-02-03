module PartialViews.MainContent exposing (..)

import Helpers exposing (getArticleSite, getSelectedArticles)
import Html exposing (Html, a, article, button, div, h2, input, label, li, main_, span, text, ul)
import Html.Attributes exposing (checked, class, for, href, id, src, type_)
import Html.Events exposing (onCheck)
import Json.Encode
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)
import PartialViews.Icons exposing (starIcon)
import Html.Attributes.Aria exposing (ariaLabel)

mainContent : Model -> Html Msg
mainContent model =
    main_
        [ class "mainContent cell medium-8" ]
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
            [ class "article card" ]
            [ div
                [ class "card-divider" ]
                [ div
                    [ class ("article-starred " ++ if articleToRender.starred then "is-starred" else "")]
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
                            , ariaLabel "starred"
                         ]
                        [ span 
                            [class "icon"
                            ]
                            [starIcon ]
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
                            ]
                            []
                        ]
                    ]
                ]
            , div
                [ class "article-excerpt card-section"
                , Json.Encode.string articleToRender.excerpt
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            ]
        ]
