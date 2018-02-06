module PartialViews.CategoryButtons exposing (categoryButtons)

import Helpers exposing (extractId, getClass)
import Html exposing (Html, button, span, text)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Models exposing (Category, Model, Site)
import Msgs exposing (..)
import Transit


categoryButtons : Model -> Category -> List Site -> Html Msg
categoryButtons model category sitesInCategory =
    -- let
    --     log =
    --         Debug.log "transit" toString (Transit.getValue model.transition)
    -- in
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
                [ class ("delete-actions" ++ getClass " is-visible" model.categoryToDeleteId category.id ++ getClass " is-open" model.categoryButtonsToShow category.id) ]
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
