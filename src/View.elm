module View exposing (view)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Helpers exposing (getSiteToEdit, onKeyDown)
import Html.Styled exposing (Html, div, styled, span)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Lazy exposing (lazy, lazy3)
import Models exposing (Model, Msg(..), Panel(..))
import PanelsManager exposing (getPanelState, isPanelOpen, isSomePanelOpen)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Modal exposing (modal)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.UiKit exposing (btn, getAnimationClassTopLayers, getModalAnimationClass, overlay, theme, transition)
import PartialViews.Icons exposing (arrowTop)

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
            [ class "mainWrapper" ]
            [ lazy sidebar model
            , mainContent model
            ]
        , PartialViews.UiKit.overlay (isSomePanelOpen "Panel" model.panelsState)
        , modal model.modal <| getModalAnimationClass <| getPanelState (toString PanelModal) model.panelsState
        , editSiteLayer (getPanelState (toString PanelEditSite) model.panelsState |> getAnimationClassTopLayers) model.siteToEditForm model.categories
        , importLayer <| getAnimationClassTopLayers <| getPanelState (toString PanelImport) model.panelsState
        , styled span
            [ position fixed
            , right theme.distanceS
            , bottom theme.distanceS
            , opacity (int 0)
            , display none
            , transition "opacity 0.3s"
            ]
            [ class "backToTopButton" ]
            [ iconButton (arrowTop [ fill theme.white ]) ( "backToTop", False ) [onClick ScrollToTop]]
        ]
