module Models exposing (..)

import Json.Encode
import TransitionManager


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
    { id : Id
    , siteId : Id
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


type alias Data =
    { categories : List Category
    , sites : List Site
    , articles : List Article
    }


type alias SelectedCategoryId =
    Maybe Id


type alias SelectedSiteId =
    Maybe Id


type alias Model =
    TransitionManager.WithTransitionStore
        { errorMsgs : List String
        , categories : List Category
        , sites : List Site
        , articles : List Article
        , selectedCategoryId : SelectedCategoryId
        , selectedSiteId : SelectedSiteId
        , categoryToEditId : Maybe Id
        , siteToEditId : Maybe Id
        , importData : String
        , searchTerm : String
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



--OutsideInfo


type alias GenericOutsideData =
    { tag : String
    , data : Json.Encode.Value
    }
