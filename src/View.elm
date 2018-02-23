module View exposing (view)

import Css exposing (displayFlex)
import Helpers exposing (getSiteToEdit)
import Html.Styled exposing (Attribute, Html, div, styled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (keyCode, on, onClick)
import Json.Decode as Json
import Models exposing (Model, Msg(..))
import PanelsManager exposing (getPanelState, isSomePanelOpen)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Modal exposing (modal)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.UiKit exposing (getAnimationClassTopLayers, getModalAnimationClass, overlay)


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
    div
        [ class bodyClass
        , onClick SetMouseNavigation
        , onKeyDown VerifyKeyboardNavigation
        ]
        [ siteHeader model.searchTerm
        , errorContainer model.panelsState model.errorMsgs
        , styled div
            [ displayFlex ]
            []
            [ sidebar model
            , mainContent model
            ]
        , overlay (isSomePanelOpen "panel" model.panelsState)
        , modal (getPanelState "panelModal" model.panelsState |> getModalAnimationClass) model.modal
        , editSiteLayer (getPanelState "panelEditSite" model.panelsState |> getAnimationClassTopLayers) (getSiteToEdit model.siteToEditId model.sites) model.categories
        , importLayer (getPanelState "panelImport" model.panelsState |> getAnimationClassTopLayers)
        ]
