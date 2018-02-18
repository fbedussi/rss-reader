module PartialViews.IconButton exposing (iconButton, iconButtonAlert)

import Css exposing (em, marginLeft, Style, backgroundColor)
import Html.Styled exposing (Attribute, Html, button, span, styled, text, styled)
import Html.Styled.Attributes exposing (class, disabled)
import Msgs exposing (..)
import PartialViews.UiKit exposing (btn, theme)


type alias Icon =
    Html Msg


type alias Label =
    String


type alias ShowLabel =
    Bool


iconButton_ : Icon -> ( Label, ShowLabel ) -> List Style -> List (Attribute Msg) -> Html Msg
iconButton_ icon labelData styles attributes =
    let
        ( label, showLabel ) =
            labelData
    in
    styled btn
        styles
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


iconButton : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButton icon labelData attributes =
    iconButton_ icon labelData [] attributes 

iconButtonAlert : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButtonAlert icon labelData attributes =
    iconButton_ icon labelData [backgroundColor theme.colorAlert] attributes 
    