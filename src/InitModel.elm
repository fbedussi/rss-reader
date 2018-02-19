module InitModel exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg)
import TransitionManager


init : ( Model, Cmd Msgs.Msg )
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
      , defaultTransitionDuration = 500
      }
    , Cmd.none
    )
