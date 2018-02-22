module PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)

import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (class, disabled)
import Html.Styled.Events exposing (onClick)
import Models exposing (Category, Id, Msg(..))
import PartialViews.UiKit exposing (alertBtn, btn, deleteActionsPanel, standardPadding)
import TransitionManager exposing (TransitionStore, getTransitionState, toTransitionManagerId)
import Css exposing (height, rem)

getDeleteActionsTransitionId : a -> TransitionManager.Id
getDeleteActionsTransitionId categoryId =
    toTransitionManagerId "cat" (toString categoryId)


deleteActions : TransitionStore -> Category -> List Id -> Html Msg
deleteActions transitionStore category sitesInCategoryIds =
    deleteActionsPanel (getDeleteActionsTransitionId category.id |> getTransitionState transitionStore)
        [ class "delete-actions" ]
        [ styled btn
            [ height (Css.rem 3)
            ]
            [ class "button"
            , onClick (RequestDeleteCategories [ category.id ])
            ]
            [ text "Delete category only" ]
        , styled alertBtn
            [ height (Css.rem 3)
            ]
            [ class "button"
            , onClick (RequestDeleteCategoryAndSites [ category.id ] sitesInCategoryIds)
            , disabled
                (if List.isEmpty sitesInCategoryIds then
                    True
                 else
                    False
                )
            ]
            [ text "Delete sites as well" ]
        ]
