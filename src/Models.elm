module Models exposing (..)

import Msgs exposing (..)


type alias Article =
    { siteId : Int
    , link : String
    , title : String
    , excerpt : String
    , starred : Bool
    }


type alias Site =
    { id : Int
    , categoriesId : List Int
    , name : String
    , rssLink : String
    , webLink : String
    , starred : Bool
    }


type alias Category =
    { id : Int
    , name : String
    }


type alias Model =
    { categories : List Category
    , sites : List Site
    , articles : List Article
    , selectedCategoryId : Maybe Int
    , selectedSiteId : Maybe Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        [ exampleCategory 1, exampleCategory 2 ]
        [ exampleSite 1, exampleSite 2 ]
        [ exampleArticle 1, exampleArticle 2 ]
        (Just 1)
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
