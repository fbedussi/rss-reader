module PartialViews.CategoryButtons exposing (categoryButtons)

import Helpers exposing (extractId, getClass, isTransitionOver)
import Html exposing (Html, button, span, text)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Models exposing (Category, Model, Site)
import Msgs exposing (..)


categoryButtons : Model -> Category -> List Site -> Html Msg
categoryButtons model category sitesInCategory =
    span
        [ class "category-action button-group" ]
        [ button
            [ class "button"
            , onClick (EditCategoryId category.id)
            ]
            [ text "edit " ]
        , button
            [ class "button alert"
            , onClick
                (if isTransitionOver model.transition then
                    ToggleDeleteActions category.id
                 else
                    NoOp
                )
            ]
            [ text "delete " ]
        ]
