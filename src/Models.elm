module Models exposing (..)

import Dom exposing (Error)
import Json.Encode
import Keyboard exposing (KeyCode)
import PanelsManager exposing (PanelsState, initialPanelsState)
import Time exposing (Time)


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
    , date: Time
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


type alias Selected =
    Bool


type alias Modal =
    { text : String
    , action : Msg
    }


type alias GenericOutsideData =
    { tag : String
    , data : Json.Encode.Value
    }


type alias Model =
        { errorMsgs : List String
        , categories : List Category
        , sites : List Site
        , articles : List Article
        , selectedCategoryId : SelectedCategoryId
        , selectedSiteId : SelectedSiteId
        , categoryToEditId : Maybe Id
        , siteToEditId : Id
        , importData : String
        , searchTerm : String
        , keyboardNavigation : Bool
        , fetchingRss : Bool
        , modal : Modal
        , panelsState : PanelsState
        , defaultTransitionDuration : Int
        , articlesPerPage: Int
        , currentPage: Int
        , articlePreviewHeight : Int
        }


init : ( Model, Cmd Msg )
init =
    ( { errorMsgs = []
      , categories = []
      , sites = []
      , articles = []
      , selectedCategoryId = Nothing
      , selectedSiteId = Nothing
      , categoryToEditId = Nothing
      , siteToEditId = -1
      , importData = ""
      , searchTerm = ""
      , keyboardNavigation = False
      , fetchingRss = False
      , modal = {text = "", action = NoOp}
      , panelsState = initialPanelsState
      , defaultTransitionDuration = 500
      , articlesPerPage = 10
      , currentPage = 1
      , articlePreviewHeight = 15
      }
    , Cmd.none
    )


createEmptySite : Site
createEmptySite =
    Site
        0
        [ 0 ]
        ""
        ""
        ""
        False


type Msg
    = SetMouseNavigation
    | VerifyKeyboardNavigation KeyCode
    | ToggleSelectedCategory Id
    | ToggleSelectSite Id
    | ToggleDeleteActions Id
    | ToggleImportLayer
    | StoreImportData String
    | ExecuteImport
    | RequestDeleteCategories (List Id)
    | DeleteCategories (List Id)
    | RequestDeleteSites (List Id)
    | DeleteSites (List Id)
    | RequestDeleteCategoryAndSites (List Id) (List Id)
    | DeleteCategoryAndSites (List Id) (List Id)
    | EditCategoryId Id
    | UpdateCategoryName Id String
    | EndCategoryEditing
    | AddNewCategory
    | AddNewSite
    | FocusResult (Result Error ())
    | OpenEditSitePanel Id
    | CloseEditSitePanel
    | UpdateSite Site
    | GetArticles (Result String (List Article))
    | DeleteArticles (List Id)
    | SaveArticle Article
    | Outside InfoForElm
    | OpenErrorMsg String   
    | LogErr String
    | RefreshFeeds
    | RequestRemoveErrorMsg String
    | RemoveErrorMsg String
    | UpdateSearch String
    | CloseAllPanels
    | ChangePage Int
    | NoOp


type InfoForOutside
    = LoginRequest LoginData
    | OpenDb UserUid
    | ReadAllData
    | AddCategoryInDb Category
    | DeleteCategoriesInDb (List Id)
    | UpdateCategoryInDb Category
    | AddSiteInDb Site
    | DeleteSitesInDb (List Id)
    | UpdateSiteInDb Site
    | AddArticleInDb Article
    | DeleteArticlesInDb (List Id)
    | SaveAllData ( List Category, List Site, List Article )


type InfoForElm
    = UserLoggedIn UserUid
    | DbOpened
    | NewData (List Category) (List Site) (List Article)
