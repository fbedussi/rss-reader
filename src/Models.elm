module Models exposing (..)


type alias UserUid =
    String


type alias LoginData =
    { email : Email
    , password : Password
    , authenticated : Bool
    }


type alias Email =
    String


type alias Password =
    String


type alias Id =
    Int


type alias Article =
    { siteId : Id
    , link : String
    , title : String
    , excerpt : String
    , starred : Bool
    }


type alias Site =
    { id : Id
    , categoriesId : List Int
    , name : String
    , rssLink : String
    , webLink : String
    , starred : Bool
    }


type alias Category =
    { id : Id
    , name : String
    }


type alias SelectedCategoryId =
    Maybe Id


type alias SelectedSiteId =
    Maybe Id


type alias Model =
    { errorMsg : String
    , categories : List Category
    , sites : List Site
    , articles : List Article
    , selectedCategoryId : SelectedCategoryId
    , selectedSiteId : SelectedSiteId
    , categoryToDeleteId : Maybe Id
    , categoryToEditId : Maybe Id
    , siteToEditId : Maybe Id
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
