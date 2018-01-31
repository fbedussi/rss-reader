module Msgs exposing (..)

import Dom exposing (Error)
import Http
import Models exposing (Article, Category, Id, LoginData, Site, UserUid)


type Msg
    = SelectCategory Id
    | SelectSite Id
    | ToggleDeleteActions Id
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
    | GetArticles (Result Http.Error (List (List Article)))
    | DeleteArticles (List Id)
    | SaveArticle Article
    | Outside InfoForElm
    | LogErr String


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


type InfoForElm
    = UserLoggedIn UserUid
    | DbOpened
    | NewData (List Category) (List Site) (List Article)
