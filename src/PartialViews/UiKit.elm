module PartialViews.UiKit exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)


theme =
    { primary = hex "4D79BC"
    , secondary = hex "673C4F"
    , accent = hex "EAC435"
    , primaryLight = hex "03CEA4"
    , secondaryLight = hex "FB4D3D"
    , white = hex "ffffff"
    , black = hex "000000"
    }


btnStyle : List Style
btnStyle = 
    [ padding2 (Css.rem 0.5) (Css.rem 1)
    , backgroundColor theme.primary
    , color theme.white
    , hover
        [ backgroundColor theme.primaryLight ]
    ]

btn: List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button btnStyle
            

alertBtn: List (Attribute msg) -> List (Html msg) -> Html msg
alertBtn =
    styled button <| btnStyle ++ [backgroundColor theme.secondary
        , hover
            [ backgroundColor theme.secondaryLight ]
        ]

