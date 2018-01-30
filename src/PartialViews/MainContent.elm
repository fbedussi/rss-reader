module PartialViews.MainContent exposing (..)

import Helpers exposing (getSelectedArticles)
import Html exposing (Html, a, article, button, div, h2, input, label, li, main_, span, text, ul)
import Html.Attributes exposing (class, for, href, id, src, type_)
import Html.Events exposing (onCheck)
import Json.Encode
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
        [ class "article" ]
        [ article
            [ class "article" ]
            [ div
                [ class "articleToolBar" ]
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
                    ]
                    []
                , label
                    [ for ("starred_" ++ toString articleToRender.id) ]
                    [ text "starred" ]
                ]
            , h2
                [ class "article-title" ]
                [ a
                    [ class "article-link"
                    , href articleToRender.link
                    , Json.Encode.string articleToRender.title
                        |> Html.Attributes.property "innerHTML"
                    ]
                    []
                , span
                    [ class "article-starred" ]
                    [ starredLabel |> text ]
                ]
            , div
                [ class "article-excerpt"
                , Json.Encode.string articleToRender.excerpt
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            ]
        ]
