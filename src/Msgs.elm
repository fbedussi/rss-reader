module Msgs exposing (..)

import Dom exposing (Error)
import Http
import Models exposing (Article, Id, Site)
import OutsideInfo exposing (InfoForElm)


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
