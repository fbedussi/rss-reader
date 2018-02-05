module Msgs exposing (..)

import Dom exposing (Error)
import Models exposing (Article, Category, Id, LoginData, Site, UserUid)
import Time exposing (Time)


type Msg
    = SelectCategory Id
    | SelectSite Id
    | ToggleDeleteActions Id
    | ToggleImportLayer
    | StoreImportData String
    | ExecuteImport
    | DeleteCategories (List Id)
    | DeleteSites (List Id)
    | DeleteCategoryAndSites (List Id) (List Id)
    | EditCategoryId Id
    | UpdateCategoryName Id String
    | EndCategoryEditing
    | AddNewCategory
    | AddNewSite
    | FocusResult (Result Error ())
    | ChangeEditSiteId Id
    | EndEditSite
    | UpdateSite Site
    | GetArticles (Result String (List Article))
    | DeleteArticles (List Id)
    | SaveArticle Article
    | Outside InfoForElm
    | LogErr String
    | RefreshFeeds
    | RemoveErrorMsg String
    | UpdateSearch String
    | ShowWithTransition
    | Tick Time


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
