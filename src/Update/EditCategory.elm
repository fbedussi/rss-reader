module Update.EditCategory exposing (handleEditCategoryMsgs)

import Models exposing (EditCategoryMsg(..), InfoForOutside(..), Model, Msg(..))
import OutsideInfo exposing (sendInfoOutside)


handleEditCategoryMsgs : Model -> EditCategoryMsg -> ( Model, Cmd Msg )
handleEditCategoryMsgs model msg =
    case msg of
        EditCategory categoryToEditId ->
            ( { model
                | categories =
                    model.categories
                        |> List.map
                            (\category ->
                                if category.id == categoryToEditId then
                                    { category
                                        | isSelected = True
                                        , isBeingEdited = True
                                    }
                                else
                                    category
                            )
              }
            , Cmd.none
            )

        EndCategoryEditing ->
            ( { model
                | categories =
                    model.categories
                        |> List.map
                            (\category ->
                                if category.isBeingEdited then
                                    { category
                                        | isBeingEdited = False
                                    }
                                else
                                    category
                            )
              }
            , Cmd.none
            )

        UpdateCategoryName category newName ->
            let
                updateCategory =
                    { category | name = newName }

                updatedCategories =
                    List.map
                        (\modelCategory ->
                            if modelCategory.id == category.id then
                                updateCategory
                            else
                                category
                        )
                        model.categories
            in
            ( { model | categories = updatedCategories }, UpdateCategoryInDb updateCategory |> sendInfoOutside )
