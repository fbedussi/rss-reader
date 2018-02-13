module PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Models exposing (Category, Id)
import Msgs exposing (..)
import TransitionManager exposing (TransitionStore, manageTransitionClass, toTransitionManagerId)

getDeleteActionsTransitionId : a -> TransitionManager.Id
getDeleteActionsTransitionId categoryId =
    toTransitionManagerId "cat" categoryId


deleteActions : TransitionStore -> Category -> List Id -> Html Msg
deleteActions transitionStore category sitesInCategoryIds =
    div
        [ class ("delete-actions" ++ (getDeleteActionsTransitionId category.id |> manageTransitionClass transitionStore)) ]
        [ button
            [ class "button"
            , onClick (DeleteCategories [ category.id ])
            ]
            [ text "Delete category only" ]
        , button
            [ class "button"
            , onClick (DeleteCategoryAndSites [ category.id ] sitesInCategoryIds)
            , disabled
                (if List.isEmpty sitesInCategoryIds then
                    True
                 else
                    False
                )
            ]
            [ text "Delete sites as well" ]
        ]
