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


type alias AppData =
    { lastRefreshTime : Time
    , articlesPerPage : Int
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
    }


type alias Data =
    { categories : List Category
    , sites : List Site
    , articles : List Article
    , appData : AppData
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
    , selectedCategoryId : SelectedCategoryId
    , categoryToEditId : Maybe Id
    , siteToEditForm : Site
    , importData : String
    , searchTerm : String
    , keyboardNavigation : Bool
    , fetchingRss : Bool
    , modal : Modal
    , panelsState : PanelsState
    , defaultTransitionDuration : Int
    , currentPage : Int
    , articlePreviewHeightInEm : Float
    , appData : AppData
    , touchData : (Float, Float)
    }


init : ( Model, Cmd Msg )
init =
    ( { errorMsgs = []
      , categories = []
      , sites = []
      , articles = []
      , selectedCategoryId = Nothing
      , categoryToEditId = Nothing
      , importData = ""
      , searchTerm = ""
      , keyboardNavigation = False
      , fetchingRss = False
      , modal = { text = "", action = NoOp }
      , panelsState = initialPanelsState
      , defaultTransitionDuration = 500
      , currentPage = 1
      , articlePreviewHeightInEm = 15
      , appData = { lastRefreshTime = 0, articlesPerPage = 15 }
      , touchData = (0.0, 0.0)
      , siteToEditForm = createEmptySite
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
    | UpdateCategoryName Id String
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
    | SaveAppData AppData
    | SaveAllData ( List Category, List Site, List Article )
    | ToggleExcerptViaJs String Bool Float
    | InitReadMoreButtons
    | ScrollToTopViaJs


type InfoForElm
    = UserLoggedIn UserUid
    | DbOpened
    | NewData (List Category) (List Site) (List Article) AppData
