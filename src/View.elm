module View exposing (view)

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Helpers exposing (getSiteToEdit, onKeyDown)
import Html.Styled exposing (Html, div, span, styled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model, Msg(..), Panel(..))
import PanelsManager exposing (getPanelState, isPanelOpen, isSomePanelOpen)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.IconButton exposing (iconButton)
import PartialViews.Icons exposing (arrowTop)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Modal exposing (modal)
import PartialViews.SettingsLayer exposing (settingsLayer)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.UiKit exposing (btn, getAnimationClassTopLayers, getModalAnimationClass, onDesktop, overlay, theme, transition)


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
                ++ (if model.menuOpen then
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
        [ siteHeader <| isRefreshButtonVisible model.sites
        , errorContainer model.panelsState model.errorMsgs
        , styled div
            [ onDesktop
                [ displayFlex ]
            ]
            [ class "mainWrapper" ]
            [ sidebar model
            , mainContent model.categories model.sites model.articles model.options model.currentPage
            ]
        , PartialViews.UiKit.overlay (model.menuOpen || isSomePanelOpen "Panel" model.panelsState)
        , modal model.modal <| getModalAnimationClass <| getPanelState (panelToString PanelModal) model.panelsState
        , editSiteLayer (getPanelState (PanelEditSite) model.panelsState |> getAnimationClassTopLayers) model.siteToEditForm model.categories
        , importLayer <| getAnimationClassTopLayers <| getPanelState (panelToString PanelImport) model.panelsState
        , settingsLayer model.options <| getAnimationClassTopLayers <| getPanelState (panelToString PanelSettings) model.panelsState
        , styled span
            [ position fixed
            , right theme.distanceS
            , bottom theme.distanceXS
            , opacity (int 0)
            , display none
            , transition "opacity 0.3s"
            , onDesktop
                [ bottom theme.distanceXXXL ]
            ]
            [ class "backToTopButton" ]
            [ iconButton (arrowTop [ fill theme.white ]) ( "backToTop", False ) [ onClick ScrollToTop ] ]
        ]


isRefreshButtonVisible : List a -> Bool
isRefreshButtonVisible sites =
    not <| List.isEmpty sites
