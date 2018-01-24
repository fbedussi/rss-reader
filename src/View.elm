module View exposing (view)

import Dialog
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (..)
import PartialViews.MainContent exposing (mainContent)
import PartialViews.Sidebar exposing (sidebar)


view : Model -> Html Msg
view model =
    div
        [ class "appWrapper grid-x" ]
        [ sidebar model
        , mainContent model
        , Dialog.view
            (case model.siteToEditId of
                Just siteId ->
                    Just
                        { closeMessage = Just EndEditSite
                        , containerClass = Just "your-container-class"
                        , header = Just (text "Alert!")
                        , body = Just (p [] [ text "Let me tell you something important..." ])
                        , footer = Nothing
                        }

                Nothing ->
                    Nothing
            )
        ]
