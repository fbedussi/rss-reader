module Msgs exposing (..)

import Dom exposing (Error)
import Http
import Models exposing (Article, Site)


type Msg
    = SelectCategory Int
    | SelectSite Int
    | ToggleDeleteActions Int
    | DeleteCategories (List Int)
    | DeleteSites (List Int)
    | DeleteCategoryAndSites (List Int) (List Int)
    | EditCategoryId Int
    | UpdateCategoryName Int String
    | EndCategoryEditing
    | AddNewCategory
    | AddNewSite
    | FocusResult (Result Error ())
    | ChangeEditSiteId Int
    | EndEditSite
    | UpdateSite Site
    | GetArticles (Result Http.Error (List Article))
