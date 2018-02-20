module PartialViews.IconButton exposing (iconButton, iconButtonAlert, iconButtonNoStyle)

import Css exposing (Style, backgroundColor, em, marginLeft, padding2)
import Html.Styled exposing (Attribute, Html, button, span, styled, text)
import Html.Styled.Attributes exposing (class, disabled)
import Models exposing (Msg(..))
import PartialViews.UiKit exposing (btn, btnNoStyle, noStyle, theme, visuallyHiddenStyle)


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

        hiddenStyle =
            if showLabel then
                noStyle
            else
                visuallyHiddenStyle
    in
    styled element
        styles
        attributes
        [ span
            []
            [ icon ]
        , styled span
            [ marginLeft (em 0.5)
            , hiddenStyle
            ]
            []
            [ text label ]
        ]


iconButton : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButton icon labelData attributes =
    iconButton_ btn icon labelData [] attributes


iconButtonAlert : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButtonAlert icon labelData attributes =
    iconButton_ btn icon labelData [ backgroundColor theme.colorAlert ] attributes


iconButtonNoStyle : Icon -> ( Label, ShowLabel ) -> List (Attribute Msg) -> Html Msg
iconButtonNoStyle icon labelData attributes =
    iconButton_ btnNoStyle icon labelData [ padding2 theme.distanceXXXS theme.distanceXXS ] attributes
