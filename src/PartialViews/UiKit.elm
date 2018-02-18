module PartialViews.UiKit exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import TransitionManager exposing (TransitionState(..))


inputHeight : Rem
inputHeight =
    Css.rem 2


theme : { black : Color, buttonHeight : Rem, colorAccent : Color, colorAlert : Color, colorBackground : Color, colorPrimary : Color, colorPrimaryLight : Color, colorSecondaryLight : Color, distanceL : Rem, distanceM : Rem, distanceS : Rem, distanceXL : Rem, distanceXS : Rem, distanceXXL : Rem, distanceXXS : Rem, distanceXXXL : Rem, distanceXXXS : Rem, fontSizeBase : Rem, fontSizeSubtitle : Rem, fontSizeTitle : Rem, hairlineWidth : Px, inputHeight : Rem, secondary : Color, white : Color, colorHairline : Color }
theme =
    { colorPrimary = hex "4D79BC"
    , secondary = hex "673C4F"
    , colorAccent = hex "EAC435"
    , colorPrimaryLight = hex "03CEA4"
    , colorSecondaryLight = hex "FB4D3D"
    , colorHairline = hex "e4e4e4"
    , colorBackground = hex "ffffff"
    , colorAlert = hex "673C4F"
    , white = hex "ffffff"
    , black = hex "000000"
    , inputHeight = inputHeight
    , buttonHeight = inputHeight
    , hairlineWidth = px 2
    , distanceXXXL = Css.rem 4.25
    , distanceXXL = Css.rem 3.75
    , distanceXL = Css.rem 3.25
    , distanceL = Css.rem 2.75
    , distanceM = Css.rem 2.25
    , distanceS = Css.rem 1.75
    , distanceXS = Css.rem 1.25
    , distanceXXS = Css.rem 0.75
    , distanceXXXS = Css.rem 0.25
    , fontSizeBase = Css.rem 1
    , fontSizeSubtitle = Css.rem 1.25
    , fontSizeTitle = Css.rem 1.5
    }


appearance : String -> Style
appearance val =
    batch
        [ property "appearance" val
        , property "-webkit-appearance" val
        ]


transition : String -> Style
transition val =
    property "transition" val


btnStyle : Style
btnStyle =
    batch
        [ display inlineBlock
        , height theme.buttonHeight
        , padding2 theme.distanceXXXS theme.distanceXS
        , backgroundColor theme.colorPrimary
        , color theme.white
        , appearance "none"
        , border3 (px 2) solid transparent
        , marginLeft (Css.em 0.5)
        , transition "all 0.5s"
        , textTransform uppercase
        , fontWeight bold
        , hover
            [ backgroundColor theme.colorPrimaryLight ]
        , firstChild
            [ marginLeft zero ]
        ]


btnNoStyleStyle : Style
btnNoStyleStyle =
    batch
        [ appearance "none"
        , border zero
        , backgroundColor transparent
        , fontSize theme.fontSizeBase
        , padding zero
        ]


standardPadding : Style
standardPadding =
    padding theme.distanceXXS


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button [ btnStyle ]


alertBtn : List (Attribute msg) -> List (Html msg) -> Html msg
alertBtn =
    styled button
        [ btnStyle
        , borderColor theme.colorAlert
        , backgroundColor theme.colorAlert
        , hover
            [ borderColor theme.colorAlert
            , backgroundColor transparent
            ]
        ]


secondaryBtn : List (Attribute msg) -> List (Html msg) -> Html msg
secondaryBtn =
    styled button
        [ btnStyle
        , backgroundColor transparent
        , borderColor theme.colorPrimary
        , color theme.colorPrimary
        , hover
            [ backgroundColor theme.colorPrimary
            , color theme.white
            ]
        ]


btnNoStyle : List (Attribute msg) -> List (Html msg) -> Html msg
btnNoStyle =
    styled button [ btnNoStyleStyle ]


sidebarSelectionBtn : List (Attribute msg) -> List (Html msg) -> Html msg
sidebarSelectionBtn =
    styled button
        [ btnNoStyleStyle
        , textAlign left
        ]


sidebarRow : Bool -> List (Attribute msg) -> List (Html msg) -> Html msg
sidebarRow selected =
    styled div
        ([ displayFlex
        , justifyContent spaceBetween
        , position relative
        , alignItems center
        , backgroundColor theme.colorBackground
        , zIndex (int 2)
        ] ++ if selected then [borderBottom3 (px 2) solid theme.colorHairline] else [])
 

input : List (Attribute msg) -> List (Html msg) -> Html msg
input =
    styled Html.Styled.input
        [ display inlineBlock
        , height theme.inputHeight
        , padding2 theme.distanceXXXS theme.distanceXS
        , border3 theme.hairlineWidth solid theme.colorHairline
        ]


tabContentOuter : Bool -> List (Attribute msg) -> List (Html msg) -> Html msg
tabContentOuter selected =
    styled div
        [ transition "height 0.5s"
        , overflow hidden
        , if selected then
            height auto
          else
            height zero
        ]


deleteActionsPanel : TransitionState -> List (Attribute msg) -> List (Html msg) -> Html msg
deleteActionsPanel transitionState =
    let
        transitionStyles =
            if transitionState == Hidden then
                [ display none ]
            else if transitionState == Open then
                [ displayFlex
                , transforms [ translateX (pct 100) ]
                ]
            else
                [ displayFlex ]
    in
    styled div
        ([ position absolute
         , top (px 1)
         , right (px 1)
         , backgroundColor theme.colorBackground
         , transition "transform 0.5s"
         , zIndex (int 1)
         ]
            ++ transitionStyles
        )


categoryWrapper : List (Attribute msg) -> List (Html msg) -> Html msg
categoryWrapper =
    styled li
        [ position relative ]


badge : List (Attribute msg) -> List (Html msg) -> Html msg
badge =
    styled div
        [ display inlineBlock
        , backgroundColor theme.colorAccent
        , color theme.white
        , width (Css.rem 1.5)
        , height (Css.rem 1.5)
        , borderRadius (pct 50)
        , textAlign center
        , padding (Css.rem 0.25)
        , verticalAlign middle
        ]


layerStyle : Style
layerStyle =
    batch
        [ position fixed
        , zIndex (int 10)
        , transition "transform 0.5s"
        , backgroundColor theme.colorBackground
        , standardPadding
        , border3 (px 2) solid theme.colorHairline
        ]


layerTop : TransitionState -> List (Attribute msg) -> List (Html msg) -> Html msg
layerTop transitionState =
    let
        transitionStyle =
            if transitionState == Hidden then
                [ display none ]
            else if transitionState == Open then
                [ displayFlex
                , transforms [ translateY zero ]
                ]
            else
                [ displayFlex ]
    in
    styled div
        ([ layerStyle
         , top zero
         , left zero
         , width (pct 100)
         , transforms [ translateY (pct -100) ]
         ]
            ++ transitionStyle
        )
