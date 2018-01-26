module Models exposing (..)


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


type alias SelectedCategoryId =
    Maybe Int


type alias SelectedSiteId =
    Maybe Int


type alias Model =
    { categories : List Category
    , sites : List Site
    , articles : List Article
    , selectedCategoryId : SelectedCategoryId
    , selectedSiteId : SelectedSiteId
    , categoryToDeleteId : Maybe Int
    , categoryToEditId : Maybe Int
    , siteToEditId : Maybe Int
    }


createEmptySite : Site
createEmptySite =
    Site
        0
        [ 0 ]
        ""
        ""
        ""
        False



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
        [ 1 ]
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
