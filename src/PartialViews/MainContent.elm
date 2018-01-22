module PartialViews.MainContent exposing (..)

import Helpers exposing (getSelectedArticles)
import Html exposing (Html, a, article, button, div, h2, li, main_, span, text, ul)
import Html.Attributes exposing (class, href, src)
import Models exposing (Article, Category, Model, Site)
import Msgs exposing (..)


mainContent : Model -> Html Msg
mainContent model =
    main_
        [ class "mainContent cell medium-9" ]
        [ ul
            [ class "selectedArticles" ]
            (getSelectedArticles model.selectedCategoryId model.selectedSiteId model.sites model.articles
                |> List.map renderArticle
            )
        ]


renderArticle : Article -> Html Msg
renderArticle articleToRender =
    let
        starredLabel =
            if articleToRender.starred then
                "starred"
            else
                ""
    in
    li
        []
        [ article
            [ class "article" ]
            [ h2
                [ class "article-title" ]
                [ a
                    [ class "article-link"
                    , href articleToRender.link
                    ]
                    [ articleToRender.title |> text ]
                , span
                    [ class "article-starred" ]
                    [ starredLabel |> text ]
                ]
            , div
                [ class "article-excerpt" ]
                [ articleToRender.excerpt |> text ]
            ]
        ]
