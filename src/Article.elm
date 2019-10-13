module Article exposing (getArticleDomId, getArticleExcerptDomId, setArticleInnerHeight, toggleArticle)

import Models exposing (Article, Id)


getArticleDomId : Id -> String
getArticleDomId articleId =
    "article_" ++ String.fromInt articleId


getArticleExcerptDomId : Id -> String
getArticleExcerptDomId articleId =
    getArticleDomId articleId ++ "_excerpt"


toggleArticle : List Article -> Id -> Bool -> Float -> List Article
toggleArticle articles articleId toOpen height =
    articles
        |> List.map
            (\article ->
                if article.id == articleId then
                    { article
                        | isOpen = toOpen
                        , height = height
                    }

                else
                    article
            )


setArticleInnerHeight : List Article -> Id -> Float -> List Article
setArticleInnerHeight articles articleId innerHeight =
    articles
        |> List.map
            (\article ->
                if article.id == articleId then
                    { article
                        | innerHeight = innerHeight
                    }

                else
                    article
            )
