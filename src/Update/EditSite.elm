module Update.EditSite exposing (handleEditSiteMsgs)

import Models exposing (Model, EditSiteMsg(..), Panel(..), Msg(..))
import Helpers exposing (sendMsg)
import PanelsManager exposing ( closePanel, openPanel)
import OutsideInfo exposing (sendInfoOutside)


handleEditSiteMsgs : Model -> EditSiteMsg -> (Model, Cmd Msg)
handleEditSiteMsgs model msg =
    case msg of
        OpenEditSitePanel site ->
            ( { model
                | siteToEditForm = site
                , panelsState = openPanel (toString PanelEditSite) model.panelsState
              }
            , Cmd.none
            )

        CloseEditSitePanel ->
            ( { model
                | panelsState = closePanel (toString PanelEditSite) model.panelsState
              }
            , Cmd.none
            )

        UpdateSite siteToUpdate ->
            ( { model | siteToEditForm = siteToUpdate }, Cmd.none )

        SaveSite ->
            let
                updatedSites =
                    model.sites
                        |> List.map
                            (\site ->
                                if site.id == model.siteToEditForm.id then
                                    model.siteToEditForm
                                else
                                    site
                            )
            in
            ( { model
                | sites = updatedSites
              }
            , Cmd.batch
                [ Models.UpdateSiteInDb model.siteToEditForm |> sendInfoOutside
                , sendMsg <| EditSiteMsg CloseEditSitePanel
                ]
            )