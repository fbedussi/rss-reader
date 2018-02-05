module Models exposing (..)

import Json.Encode


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
    { errorMsgs : List String
    , categories : List Category
    , sites : List Site
    , articles : List Article
    , selectedCategoryId : SelectedCategoryId
    , selectedSiteId : SelectedSiteId
    , categoryToDeleteId : Maybe Id
    , categoryToEditId : Maybe Id
    , siteToEditId : Maybe Id
    , importLayerOpen : Bool
    , importData : String
    , searchTerm : String
    , elementVisibility : ElementVisibility
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


type ElementVisibility
    = None
    | OverrideNone
    | DoTransition
    | OverrideNoneBack



--OutsideInfo


type alias GenericOutsideData =
    { tag : String
    , data : Json.Encode.Value
    }
