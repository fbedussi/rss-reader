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
      , categoryPanelStates = []
      , categoryToEditId = Nothing
      , siteToEditId = Nothing
      , importLayerOpen = False
      , importData = ""
      , searchTerm = ""
      , transition = Transit.empty
      }
    , Cmd.none
    )
