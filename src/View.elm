module View exposing (view)

import Css exposing (borderBox, boxSizing, displayFlex, fontFamily, listStyleType, margin, none, outline, padding, sansSerif, zero)
import Css.Foreign exposing (everything, global, selector)
import Html.Styled exposing (Attribute, Html, div, styled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (keyCode, on, onClick)
import Json.Decode as Json
import Models exposing (Model, Msg(..))
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.UiKit exposing (overlay)
import PartialViews.Modal exposing (modal)
import PanelsManager exposing (isPanelOpen)
import Helpers exposing (getSiteToEdit)


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


view : Model -> Html Msg
view model =
    let
        bodyClass =
            "appWrapper"
                ++ (if model.keyboardNavigation then
                        " keyboardNavigation"
                    else
                        " mouseNavigation"
                   )
                ++ (if model.fetchingRss then
                        " fetchingRss"
                    else
                        ""
                   )
    in
    styled div
        [ fontFamily sansSerif
        ]
        [ class bodyClass
        , onClick SetMouseNavigation
        , onKeyDown VerifyKeyboardNavigation
        ]
        [ global
            [ everything
                [ margin zero
                , padding zero
                , boxSizing borderBox
                ]
            , selector "ul"
                [ listStyleType none ]
            , selector ".mouseNavigation *:focus"
                [ outline none ]
            ]
        , siteHeader model.searchTerm
        , errorContainer model.errorMsgs
        , styled div
            [ displayFlex ]
            []
            [ sidebar model
            , mainContent model
            ]
        --, overlay (isSomethingOpen model.transitionStore "panel")
        --, modal model.modal <| getTransitionState model.transitionStore "panelmodal"
        , editSiteLayer (isPanelOpen "editSite" model.panelsOpen) (getSiteToEdit model.siteToEditId model.sites) model.categories
        , importLayer (isPanelOpen "import" model.panelsOpen)
        ]
