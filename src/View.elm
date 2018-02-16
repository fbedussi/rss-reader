module View exposing (view)

import Html.Styled exposing (Html, div, p, text)
import Html.Styled.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Sidebar exposing (sidebar)
import Css exposing (displayFlex, fontFamily, sansSerif)
import Html.Styled exposing (styled)

view : Model -> Html Msg
view model =
    styled div
        [ fontFamily sansSerif
        ]
        [ class "appWrapper grid-x" ]
        [ siteHeader model
        , errorContainer model.errorMsgs
        , styled div        
            [displayFlex]
            []
            [ sidebar model
            , mainContent model
            ]
        , editSiteLayer model
        , importLayer model.transitionStore
        ]
