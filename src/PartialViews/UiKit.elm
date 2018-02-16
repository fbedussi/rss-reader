module PartialViews.UiKit exposing (..)

import Html
import Css exposing (..)
import Html.Styled exposing (..)

inputHeight = 
    (Css.rem 2)

theme =
    { primary = hex "4D79BC"
    , secondary = hex "673C4F"
    , accent = hex "EAC435"
    , primaryLight = hex "03CEA4"
    , secondaryLight = hex "FB4D3D"
    , hairline = hex "e4e4e4"
    , white = hex "ffffff"
    , black = hex "000000"
    , inputHeight = inputHeight
    , buttonHeight = inputHeight
    , hairlineWidth = (px 2)
    , distanceXXXL = (Css.rem 4.25)
    , distanceXXL = (Css.rem 3.75)
    , distanceXL = (Css.rem 3.25)
    , distanceL = (Css.rem 2.75)
    , distanceM = (Css.rem 2.25)
    , distanceS = (Css.rem 1.75)
    , distanceXS = (Css.rem 1.25)
    , distanceXXS = (Css.rem 0.75)
    , distanceXXXS = (Css.rem 0.25)
    , fontSizeBase = (Css.rem 1)
    , fontSizeSubtitle = (Css.rem 1.25)
    , fontSizeTitle = (Css.rem 1.5)
    }


appearance : String -> Style
appearance val = 
    batch [
        property "appearance" val
        , property "-webkit-appearance" val
    ]

transition : String -> Style
transition val = 
    property "transition" val

btnStyle : Style
btnStyle = 
    batch [ display inlineBlock
    , height theme.buttonHeight
    , padding2 theme.distanceXXXS theme.distanceXS
    , backgroundColor theme.primary
    , color theme.white
    , appearance "none"
    , border zero 
    , marginLeft (Css.em 0.5)
    , hover
        [ backgroundColor theme.primaryLight ]
    , firstChild
        [marginLeft zero]
    ]

btnNoStyleStyle : Style
btnNoStyleStyle =
    batch [
        appearance "none"
        , border zero
        , backgroundColor transparent
        , fontSize theme.fontSizeBase
        , padding zero
    ]

btn: List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button [btnStyle]
            

alertBtn: List (Attribute msg) -> List (Html msg) -> Html msg
alertBtn =
    styled button [
        btnStyle
        , backgroundColor theme.secondary
        , hover
            [ backgroundColor theme.secondaryLight ]
        ]

btnNoStyle: List (Attribute msg) -> List (Html msg) -> Html msg
btnNoStyle =
    styled button [btnNoStyleStyle]
        

sidebarSelectionBtn:List (Attribute msg) -> List (Html msg) -> Html msg
sidebarSelectionBtn = 
    styled button [btnNoStyleStyle
    , textAlign left
    ]

sidebarRow :List (Attribute msg) -> List (Html msg) -> Html msg
sidebarRow =
    styled div
        [ displayFlex
        , justifyContent spaceBetween
        ]

input: List (Attribute msg) -> List (Html msg) -> Html msg
input = 
    styled Html.Styled.input 
        [ display inlineBlock
        , height theme.inputHeight
        , padding2 theme.distanceXXXS theme.distanceXS
        , border3 theme.hairlineWidth solid theme.hairline
        ]

tabContentOuter : List (Attribute msg) -> List (Html msg) -> Html msg
tabContentOuter =
    styled div
        [ transition "height 0.5s"
        , overflow hidden
        , height zero]