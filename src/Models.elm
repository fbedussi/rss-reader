module Models exposing (..)

import Dom exposing (Error)
import Json.Encode
import Keyboard exposing (KeyCode)
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


type alias Selected =
    Bool


type alias Modal =
    { open : Bool
    , text : String
    , action : Msg
    }


type alias GenericOutsideData =
    { tag : String
    , data : Json.Encode.Value
    }


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
        , keyboardNavigation : Bool
        , fetchingRss : Bool
        , modal : Modal
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
      , siteToEditId = Nothing
      , importData = ""
      , searchTerm = ""
      , transitionStore = TransitionManager.empty
      , keyboardNavigation = False
      , fetchingRss = False
      , modal = {open = False, text = "", action = NoOp}
      , defaultTransitionDuration = 500
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
    | SelectSite Id
    | ToggleDeleteActions Id
    | TransitionEnd
    | TransitionStart
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
    | ChangeEditSiteId (Maybe Id)
    | UpdateSite Site
    | GetArticles (Result String (List Article))
    | DeleteArticles (List Id)
    | SaveArticle Article
    | Outside InfoForElm
    | LogErr String
    | RefreshFeeds
    | RemoveErrorMsg String
    | UpdateSearch String
    | CloseAllPanels
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
