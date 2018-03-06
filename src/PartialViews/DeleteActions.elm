module PartialViews.DeleteActions exposing (deleteActions)

import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (class, disabled)
import Html.Styled.Events exposing (onClick)
import Models exposing (Category, Id, Msg(..), DeleteMsg(..))
import PartialViews.UiKit exposing (alertBtn, btn, deleteActionsPanel, standardPadding)
import Css exposing (height, rem)


deleteActions : String -> Category -> List Id -> Html Msg
deleteActions animationClass category sitesInCategoryIds =
    deleteActionsPanel
        [ class <| "delete-actions" ++ animationClass ]
        [ styled btn
            [ height (Css.rem 3)
            ]
            [ class "button"
            , onClick <| DeleteMsg <| RequestDeleteCategories [ category.id ]
            ]
            [ text "Delete category only" ]
        , styled alertBtn
            [ height (Css.rem 3)
            ]
            [ class "button"
            , onClick <| DeleteMsg <| RequestDeleteCategoryAndSites [ category.id ] sitesInCategoryIds
            , disabled
                (if List.isEmpty sitesInCategoryIds then
                    True
                 else
                    False
                )
            ]
            [ text "Delete sites as well" ]
        ]
