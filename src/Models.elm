module Models exposing (..)

import Dom exposing (Error)
import Json.Encode
import Keyboard exposing (KeyCode)
import PanelsManager exposing (PanelsState, initialPanelsState)
import Time exposing (Time)
import TouchEvents exposing (Touch)
import Task
import Window

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
    , numberOfNewArticles : Int
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
    | PanelSettings


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
    , menuOpen : Bool
    , currentPage : Int
    , options : Options
    , lastRefreshTime : Time
    , touchData : ( Float, Float )
    }


initialModel : Model
initialModel = 
    { errorMsgs = []
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
      , menuOpen = False
      , currentPage = 1
      , options = { articlesPerPage = 10, articlePreviewHeightInEm = 15.0 }
      , lastRefreshTime = 0
      , touchData = ( 0.0, 0.0 )
      }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


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
        0


type Msg
    = SetMouseNavigation
    | VerifyKeyboardNavigation KeyCode
    | ToggleSelectSite Id
    | ToggleDeleteActions Id
    | ToggleExcerpt Id String Bool
    | ExecuteImport
    | StoreImportData String
    | RefreshFeeds
    | GetArticles Id (Result String (List Article))
    | ToggleSelectedCategory Id
    | AddNewCategory
    | AddNewSite
    | SaveArticle Article
    | TogglePanel Panel
    | ToggleMenu
    | CloseMenu
    | OpenImportPanel
    | CloseAllPanels
    | UpdateSearch String
    | ChangePage Int
    | ChangeNumberOfArticlesPerPage Int
    | ChangePreviewHeight String
    | RegisterTime Time
    | OnTouchStart Touch
    | ScrollToTop
    | SignOut
    | EditCategoryMsg EditCategoryMsg
    | EditSiteMsg EditSiteMsg
    | DeleteMsg DeleteMsg
    | ErrorBoxMsg ErrorBoxMsg
    | Outside InfoForElm
    | NoOp


type EditCategoryMsg
    = EditCategory Id
    | UpdateCategoryName Category String
    | EndCategoryEditing


type ErrorBoxMsg
    = OpenErrorMsg String
    | RequestRemoveErrorMsg String
    | RemoveErrorMsg String
    | LogErr String


type DeleteMsg
    = RequestDeleteCategories (List Id)
    | DeleteCategories (List Id)
    | RequestDeleteSites (List Id)
    | DeleteSites (List Id)
    | RequestDeleteCategoryAndSites (List Id) (List Id)
    | DeleteCategoryAndSites (List Id) (List Id)
    | DeleteArticles (List Id)


type EditSiteMsg
    = OpenEditSitePanel Site
    | CloseEditSitePanel
    | UpdateSite Site
    | SaveSite


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
    | SignOutViaJs


type InfoForElm
    = UserLoggedIn UserUid
    | DbOpened
    | NewData (List Category) (List Site) (List Article) Options Time
