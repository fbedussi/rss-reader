module PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)


import Html.Styled exposing (..)
import Html.Styled.Attributes exposing ( class, disabled)
import Html.Styled.Events exposing (onClick)
import Models exposing (Category, Id)
import Msgs exposing (..)
import TransitionManager exposing (TransitionStore, getTransitionState, toTransitionManagerId)
import PartialViews.UiKit exposing (btn, alertBtn, deleteActionsPanel)

getDeleteActionsTransitionId : a -> TransitionManager.Id
getDeleteActionsTransitionId categoryId =
    toTransitionManagerId "cat" categoryId


deleteActions : TransitionStore -> Category -> List Id -> Html Msg
deleteActions transitionStore category sitesInCategoryIds =
    deleteActionsPanel (getDeleteActionsTransitionId category.id |> getTransitionState transitionStore)
        [ class "delete-actions" ]
        [ btn
            [ class "button"
            , onClick (DeleteCategories [ category.id ])
            ]
            [ text "Delete category only" ]
        , alertBtn
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
    