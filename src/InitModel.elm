module InitModel exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg)
import Transit


init : ( Model, Cmd Msgs.Msg )
init =
    ( { errorMsgs = []
      , categories = []
      , sites = []
      , articles = []
      , selectedCategoryId = Nothing
      , selectedSiteId = Nothing
      , categoryToDeleteId = Nothing
      , categoryToEditId = Nothing
      , siteToEditId = Nothing
      , importLayerOpen = False
      , importData = ""
      , searchTerm = ""
      , categoryButtonsToShow = Nothing
      , transition = Transit.empty
      }
    , Cmd.none
    )
