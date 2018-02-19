module PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)

import Css exposing (em, marginLeft, Style, backgroundColor, padding2)
import Html.Styled exposing (Attribute, Html, button, span, styled, text, styled)
import Html.Styled.Attributes exposing (class, disabled)
import Msgs exposing (..)
import PartialViews.UiKit exposing (btn, theme, btnNoStyle)


type alias Icon =
    Html Msg


type alias Label =
    String


type alias ShowLabel =
    Bool


iconButton_ : (List (Attribute Msg) -> List (Html Msg) -> Html Msg) -> Icon -> ( Label, ShowLabel ) -> List Style -> List (Attribute Msg) -> Html Msg
iconButton_ element icon labelData styles attributes =
    let
        ( label, showLabel ) =
            labelData
    in
    styled element
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
    iconButton_ btn icon labelData [] attributes 

iconButtonAlert : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButtonAlert icon labelData attributes =
    iconButton_ btn icon labelData [backgroundColor theme.colorAlert] attributes 
    
iconButtonNoStyle : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButtonNoStyle icon labelData attributes =
    iconButton_ btnNoStyle icon labelData [padding2 theme.distanceXXXS theme.distanceXXS] attributes 