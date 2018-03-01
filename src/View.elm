module View exposing (view)

import Css exposing (displayFlex)
import Css.Media exposing (only, screen, withMedia)
import Helpers exposing (getSiteToEdit, onKeyDown)
import Html.Styled exposing (Html, div, styled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model, Msg(..), Panel(..))
import PanelsManager exposing (getPanelState, isSomePanelOpen, isPanelOpen)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Modal exposing (modal)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.UiKit exposing (getAnimationClassTopLayers, getModalAnimationClass, overlay, theme)
import Html.Styled.Lazy exposing (lazy3, lazy)
import Html

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

                ++ (if getPanelState (toString PanelMenu) model.panelsState |> isPanelOpen then
                        " menuOpen"
                    else
                        ""
                   )
    in
    div
        [ class bodyClass
        , onClick SetMouseNavigation
        , onKeyDown VerifyKeyboardNavigation
        ]
        [ siteHeader
        , errorContainer model.panelsState model.errorMsgs
        , styled div
            [ withMedia [ only screen [ Css.Media.minWidth theme.breakpoints.desktop ] ]
                [ displayFlex ]
            ]
            [ class "mainWrapper"]
            [ lazy sidebar model
            , mainContent model
            ]
        , overlay (isSomePanelOpen "Panel" model.panelsState)
        , modal model.modal <| getModalAnimationClass <| getPanelState (toString PanelModal) model.panelsState
        , editSiteLayer (getPanelState (toString PanelEditSite) model.panelsState |> getAnimationClassTopLayers) (getSiteToEdit model.siteToEditId model.sites) model.categories
        , importLayer <| getAnimationClassTopLayers <| getPanelState (toString PanelImport) model.panelsState
        ]
