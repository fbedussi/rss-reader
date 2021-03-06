module View exposing (view)

import Browser exposing (Document)
import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Helpers exposing (onKeyDown)
import Html.Styled exposing (div, styled, toUnstyled)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Lazy as HSL
import Models exposing (Model, Msg(..), Panel(..), panelToString)
import PanelsManager exposing (getPanelState, isSomePanelOpen)
import PartialViews.BackToTop exposing (backToTop)
import PartialViews.EditSiteLayer exposing (editSiteLayer)
import PartialViews.ErrorContainer exposing (errorContainer)
import PartialViews.Header exposing (siteHeader)
import PartialViews.ImportLayer exposing (importLayer)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Modal exposing (modal)
import PartialViews.SettingsLayer exposing (settingsLayer)
import PartialViews.Sidebar exposing (sidebar)
import PartialViews.UiKit exposing (btn, getAnimationClassTopLayers, getModalAnimationClass, onDesktop, overlay, theme, transition)


view : Model -> Document Msg
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

        content =
            toUnstyled <|
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
                        [ HSL.lazy5 sidebar model.sites model.searchTerm model.categories model.panelsState model.sidebarCollapsed
                        , HSL.lazy6 mainContent model.categories model.sites model.articles model.options model.currentPage model.sidebarCollapsed
                        ]
                    , PartialViews.UiKit.overlay (model.menuOpen || isSomePanelOpen "Panel" model.panelsState)
                    , modal model.modal <| getModalAnimationClass <| getPanelState (panelToString PanelModal) model.panelsState
                    , editSiteLayer (getPanelState (panelToString PanelEditSite) model.panelsState |> getAnimationClassTopLayers) model.siteToEditForm model.categories
                    , importLayer <| getAnimationClassTopLayers <| getPanelState (panelToString PanelImport) model.panelsState
                    , settingsLayer model.options <| getAnimationClassTopLayers <| getPanelState (panelToString PanelSettings) model.panelsState
                    , backToTop model.isBackToTopVisible
                    ]
    in
    { title = "FlyFeed"
    , body = [ content ]
    }


isRefreshButtonVisible : List a -> Bool
isRefreshButtonVisible sites =
    not <| List.isEmpty sites
