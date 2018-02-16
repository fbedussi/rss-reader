module PartialViews.IconButton exposing (iconButton)

import Css exposing (em, marginLeft)
import Html.Styled exposing (Attribute, Html, button, span, styled, text)
import Html.Styled.Attributes exposing (class, disabled)
import Msgs exposing (..)
import PartialViews.UiKit exposing (btn)


type alias Icon =
    Html Msg


type alias Label =
    String


type alias ShowLabel =
    Bool


iconButton : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButton icon labelData attributes =
    let
        ( label, showLabel ) =
            labelData
    in
    btn
        attributes
        [ span
            []
            [ icon ]
        , styled span
            [ marginLeft (em 0.5)]
            [ class
                (if showLabel then
                    ""
                 else
                    " visuallyHidden"
                )
            ]
            [ text label ]
        ]
