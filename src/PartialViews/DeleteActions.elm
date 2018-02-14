module PartialViews.DeleteActions exposing (deleteActions, getDeleteActionsTransitionId)

import Css exposing (..)
import Html exposing (Html)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, disabled)
import Html.Styled.Events exposing (onClick)
import Models exposing (Category, Id)
import Msgs exposing (..)
import TransitionManager exposing (TransitionStore, manageTransitionClass, toTransitionManagerId)


theme : { secondary : Color, primary : Color }
theme =
    { primary = hex "55af6a"
    , secondary = rgb 250 240 230
    }


getDeleteActionsTransitionId : a -> TransitionManager.Id
getDeleteActionsTransitionId categoryId =
    toTransitionManagerId "cat" categoryId


deleteActions : TransitionStore -> Category -> List Id -> Html.Html Msg
deleteActions transitionStore category sitesInCategoryIds =
    toUnstyled <| div 
        [ class ("delete-actions" ++ (getDeleteActionsTransitionId category.id |> manageTransitionClass transitionStore)) ]
        [ button
            [ class "button"
            , onClick (DeleteCategories [ category.id ])
            , css 
                [backgroundColor theme.primary]
            ]
            [ text "Delete category only" ]
        , button
            [ class "button"
            , onClick (DeleteCategoryAndSites [ category.id ] sitesInCategoryIds)
            , Html.Styled.Attributes.disabled
                (if List.isEmpty sitesInCategoryIds then
                    True
                 else
                    False
                )
            ]
            [ text "Delete sites as well" ]
        ]
    