module View exposing (view)

import Html.Styled exposing (Html, div, p, text, Attribute)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick, on, keyCode)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Sidebar exposing (sidebar)
import Css exposing (displayFlex, fontFamily, sansSerif, outline, none, margin, zero, padding, boxSizing, borderBox, listStyleType)
import Html.Styled exposing (styled)
import Json.Decode as Json
import PartialViews.UiKit exposing (overlay)
import TransitionManager exposing (isSomethingOpen)
import Css.Foreign exposing (global, selector, everything)

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)

view : Model -> Html Msg
view model =
    styled div
        [ fontFamily sansSerif
        ]
        [ class ("appWrapper" ++ if model.keyboardNavigation then " keyboardNavigation" else " mouseNavigation")
        , onClick SetMouseNavigation
        , onKeyDown VerifyKeyboardNavigation
        ]
        [ global
            [ everything [ margin zero
                , padding zero
                , boxSizing borderBox
            ]
            , selector "ul"
                [listStyleType none]
            , selector ".mouseNavigation *:focus"
                [ outline none ]
            ] 
        , siteHeader model.searchTerm
        , errorContainer model.errorMsgs
        , styled div        
            [displayFlex]
            []
            [ sidebar model
            , mainContent model
            ]
        , overlay (isSomethingOpen model.transitionStore "panel")
        , editSiteLayer model
        , importLayer model.transitionStore
        ]
