module PartialViews.IconButton exposing (iconButton)

import Html exposing (Attribute, Html, button, span, text)
import Html.Attributes exposing (class, disabled)
import Msgs exposing (..)


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
    button
        ([ class "button" ]
            ++ attributes
        )
        [ span
            [ class "icon" ]
            [ icon ]
        , span
            [ class
                ("text"
                    ++ (if showLabel then
                            ""
                        else
                            " visuallyHidden"
                       )
                )
            ]
            [ text label ]
        ]
