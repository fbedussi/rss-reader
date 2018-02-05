module PartialViews.CategoryButtons exposing (categoryButtons)

import Helpers exposing (extractId, getSelectedClass, isSelected)
import Html exposing (Html, button, span, text)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Models exposing (Category, ElementVisibility(..), Model, Site)
import Msgs exposing (..)


categoryButtons : Model -> Category -> List Site -> Html Msg
categoryButtons model category sitesInCategory =
    let
        isCatSelected =
            isSelected model.selectedCategoryId category.id

        isEdited =
            isSelected model.categoryToDeleteId category.id
    in
    span
        [ class "category-action button-group" ]
        [ button
            [ class "button"
            , onClick (EditCategoryId category.id)
            ]
            [ text "edit " ]
        , span
            [ class "deleteButtonsWrapper" ]
            [ button
                [ class "button alert"
                , onClick (ToggleDeleteActions category.id)
                ]
                [ text "delete " ]
            , span
                [ class
                    ("delete-actions "
                        --++ getSelectedClass model.categoryToDeleteId category.id
                        ++ (if isCatSelected && (model.elementVisibility == OverrideNone || model.elementVisibility == OverrideNoneBack) then
                                " is-visible"
                            else
                                ""
                                    ++ (if isEdited && model.elementVisibility == DoTransition then
                                            " is-visible is-open"
                                        else
                                            ""
                                       )
                           )
                    )
                ]
                [ button
                    [ class "button"
                    , onClick (DeleteCategories [ category.id ])
                    ]
                    [ text "Delete category only" ]
                , button
                    [ class "button"
                    , onClick (DeleteCategoryAndSites [ category.id ] (extractId sitesInCategory))
                    , disabled
                        (if List.isEmpty sitesInCategory then
                            True
                         else
                            False
                        )
                    ]
                    [ text "Delete sites as well" ]
                ]
            ]
        ]
