module InitModel exposing (..)

import Models exposing (Article, Category, Model, Site)
import Msgs exposing (Msg)


init : ( Model, Cmd Msg )
init =
    ( Model
        [ exampleCategory 1, exampleCategory 2 ]
        [ exampleSite 1, exampleSite 2 ]
        [ exampleArticle 1, exampleArticle 2 ]
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
    , Cmd.none
    )



-- TEMP DUMMY DATA


exampleCategory : Int -> Category
exampleCategory int =
    Category
        int
        ("Category " ++ toString int)


exampleSite : Int -> Site
exampleSite int =
    Site
        int
        [ int ]
        ("Site " ++ toString int)
        "https://www.lffl.org/feed"
        "https://www.lffl.org/"
        False


exampleArticle : Int -> Article
exampleArticle int =
    Article
        int
        "https://www.lffl.org/2018/01/fuchsia-os-google.html"
        ("Title " ++ toString int)
        ("Lorem ipsum dolor hamet " ++ toString int)
        False
