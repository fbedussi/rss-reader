module Models exposing (..)

import Dom exposing (Error)
import Json.Encode
import Keyboard exposing (KeyCode)
import PanelsManager exposing (PanelsState, initialPanelsState)
import Time exposing (Time)
import TouchEvents exposing (Touch)


type alias UserUid =
    String


type alias LoginData =
    { email : Email
    , password : Password
    , authenticated : Bool
    }


type alias Options =
    { articlesPerPage : Int
    , articlePreviewHeightInEm : Float
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
    , date : Time
    , isOpen : Bool
    }


type alias Site =
    { id : Id
    , categoriesId : List Int
    , name : String
    , rssLink : String
    , webLink : String
    , starred : Bool
    , isSelected : Bool
    }


type alias Category =
    { id : Id
    , name : String
    , isSelected : Bool
    , isBeingEdited : Bool
    }


type alias Data =
    { categories : List Category
    , sites : List Site
    , articles : List Article
    , options : Options
    , lastRefreshedTime : Float
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


type Panel
    = PanelEditSite
    | PanelImport
    | PanelModal
    | PanelMenu


type alias Model =
    { errorMsgs : List String
    , categories : List Category
    , sites : List Site
    , articles : List Article
    , siteToEditForm : Site
    , importData : String
    , searchTerm : String
    , keyboardNavigation : Bool
    , fetchingRss : Bool
    , modal : Modal
    , panelsState : PanelsState
    , currentPage : Int
    , options : Options
    , lastRefreshTime : Time
    , touchData : (Float, Float)
    }


init : ( Model, Cmd Msg )
init =
    ( { errorMsgs = []
      , categories = []
      , sites = []
      , articles = []
      , siteToEditForm = createEmptySite
      , importData = ""
      , searchTerm = ""
      , keyboardNavigation = False
      , fetchingRss = False
      , modal = { text = "", action = NoOp }
      , panelsState = initialPanelsState
      , currentPage = 1
      , options = {articlesPerPage = 10, articlePreviewHeightInEm = 15.0 }
      , lastRefreshTime = 0
      , touchData = (0.0, 0.0)
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
        False


type Msg
    = SetMouseNavigation
    | VerifyKeyboardNavigation KeyCode
    | ToggleSelectedCategory Id
    | ToggleSelectSite Id
    | ToggleDeleteActions Id
    | StoreImportData String
    | ExecuteImport
    | RequestDeleteCategories (List Id)
    | DeleteCategories (List Id)
    | RequestDeleteSites (List Id)
    | DeleteSites (List Id)
    | RequestDeleteCategoryAndSites (List Id) (List Id)
    | DeleteCategoryAndSites (List Id) (List Id)
    | EditCategoryId Id
    | UpdateCategoryName Category String
    | EndCategoryEditing
    | AddNewCategory
    | AddNewSite
    | FocusResult (Result Error ())
    | OpenEditSitePanel Site
    | CloseEditSitePanel
    | UpdateSite Site
    | SaveSite
    | GetArticles (Result String (List Article))
    | DeleteArticles (List Id)
    | SaveArticle Article
    | Outside InfoForElm
    | OpenErrorMsg String
    | LogErr String
    | RefreshFeeds
    | TogglePanel Panel
    | RequestRemoveErrorMsg String
    | RemoveErrorMsg String
    | UpdateSearch String
    | CloseAllPanels
    | ChangePage Int
    | ChangeNumberOfArticlesPerPage Int
    | RegisterTime Time
    | OnTouchStart Touch
    | ToggleExcerpt Id String Bool
    | ScrollToTop
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
    | SaveOptions Options
    | SaveLastRefreshedTime Time
    | SaveAllData ( List Category, List Site, List Article )
    | ToggleExcerptViaJs String Bool Float
    | InitReadMoreButtons
    | ScrollToTopViaJs


type InfoForElm
    = UserLoggedIn UserUid
    | DbOpened
    | NewData (List Category) (List Site) (List Article) Options Time
