module PartialViews.UiKit exposing (..)

import Char
import Css exposing (..)
import Css.Foreign exposing (descendants, selector)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabel)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, for, fromUnstyled, id, type_)
import Html.Styled.Events exposing (onCheck, onClick)
import Models exposing (Msg(..), Selected)
import PanelsManager exposing (getPanelClass)
import PartialViews.Icons exposing (starIcon)


inputHeight : Rem
inputHeight =
    Css.rem 2


theme : { black : Color, buttonHeight : Rem, colorAccent : Color, colorAlert : Color, colorBackground : Color, colorHairline : Color, colorPrimaryLight : Color, colorSecondary : Color, colorSecondaryLight : Color, colorTransparent : Color, distanceL : Rem, distanceM : Rem, distanceS : Rem, distanceXL : Rem, distanceXS : Rem, distanceXXL : Rem, distanceXXS : Rem, distanceXXXL : Rem, distanceXXXS : Rem, fontSizeBase : Rem, fontSizeSubtitle : Rem, fontSizeTitle : Rem, hairlineWidth : Px, inputHeight : Rem, white : Color, colorPrimary : Color }
theme =
    { colorPrimary = hex "4D79BC"
    , colorSecondary = hex "673C4F"
    , colorAccent = hex "EAC435"
    , colorPrimaryLight = hex "03CEA4"
    , colorSecondaryLight = hex "FB4D3D"
    , colorHairline = hex "e4e4e4"
    , colorBackground = hex "ffffff"
    , colorTransparent = rgba 0 0 0 0
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


customCss : String -> String -> Style
customCss prop val =
    property prop val


stroke : String -> Style
stroke val =
    property "stroke" val


appearance : String -> Style
appearance val =
    batch
        [ property "appearance" val
        , property "-webkit-appearance" val
        ]


transition : String -> Style
transition val =
    property "transition" val


transformOrigin : String -> Style
transformOrigin val =
    property "transform-origin" val


pointerEventsNone : Style
pointerEventsNone =
    property "pointer-events" "none"


clear : String -> Style
clear val =
    property "clear" val


clipZero : Style
clipZero =
    property "clip" "rect(0 0 0 0)"


pseudoContent : Style
pseudoContent =
    property "content" "\"\""


noStyle : Style
noStyle =
    batch []


visuallyHiddenStyle : Style
visuallyHiddenStyle =
    batch
        [ border zero
        , height (px 1)
        , margin (px -1)
        , overflow hidden
        , padding zero
        , position absolute
        , width (px 1)
        , clipZero
        ]


btnStyle : Style
btnStyle =
    batch
        [ display inlineBlock
        , minHeight theme.buttonHeight
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
        , color currentColor
        ]


standardPadding : Style
standardPadding =
    padding theme.distanceXXS


sidebarBoxStyle : Style
sidebarBoxStyle =
    batch [ standardPadding ]


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


input : List (Attribute msg) -> List (Html msg) -> Html msg
input =
    styled Html.Styled.input
        [ display inlineBlock
        , height theme.inputHeight
        , padding2 theme.distanceXXXS theme.distanceXS
        , border3 theme.hairlineWidth solid theme.colorHairline
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


categoryWrapper : List (Attribute msg) -> List (Html msg) -> Html msg
categoryWrapper =
    styled li
        [ position relative
        , minHeight (Css.rem 2)
        , border3 (px 2) solid theme.colorHairline
        , borderBottom zero
        , lastChild [ borderBottom3 (px 2) solid theme.colorHairline ]
        ]


sidebarRow : Selected -> List (Attribute msg) -> List (Html msg) -> Html msg
sidebarRow selected =
    let
        selectedStyle =
            if selected then
                [ backgroundColor theme.colorPrimaryLight
                , color theme.white
                ]
            else
                [ customCss "padding-right" "calc(3.75rem + 2em)" ]
    in
    styled div
        ([ displayFlex
         , standardPadding
         , justifyContent spaceBetween
         , position relative
         , alignItems center
         , backgroundColor theme.colorBackground
         , zIndex (int 2)
         , transition "background-color 0.5s"
         ]
            ++ selectedStyle
        )


tabContentOuter : Selected -> List (Attribute msg) -> List (Html msg) -> Html msg
tabContentOuter selected =
    styled div
        [ transition "height 0.5s"
        , overflow hidden
        , if selected then
            height auto
          else
            height zero
        ]


deleteActionsPanel : List (Attribute msg) -> List (Html msg) -> Html msg
deleteActionsPanel =
    styled div
        [ position absolute
        , top (px 1)
        , right (px 1)
        , backgroundColor theme.colorBackground
        , transition "transform 0.5s"
        , zIndex (int 1)
        ]


badge : List (Attribute msg) -> List (Html msg) -> Html msg
badge =
    styled div
        [ display inlineBlock
        , backgroundColor theme.colorAccent
        , color theme.white
        , minWidth (Css.rem 1.5)
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
        , backgroundColor theme.colorBackground
        , standardPadding
        , border3 (px 2) solid theme.colorHairline
        ]


layerTop : List (Attribute msg) -> List (Html msg) -> Html msg
layerTop =
    styled div
        [ layerStyle
        , top zero
        , left zero
        , width (pct 100)
        , transforms [ translateY (pct -100) ]
        ]


inputRow : List (Attribute msg) -> List (Html msg) -> Html msg
inputRow attributes children =
    styled div
        [ marginBottom (Css.rem 0.5)
        , displayFlex
        ]
        ([ class "inputRow" ] ++ attributes)
        children


layerInner : List (Attribute msg) -> List (Html msg) -> Html msg
layerInner attributes children =
    styled div
        [ width (pct 100) ]
        ([ class "layer-inner" ] ++ attributes)
        children


overlay : Bool -> Html Msg
overlay active =
    let
        activeStyle =
            if active then
                batch
                    [ opacity (int 1)
                    ]
            else
                batch
                    [ opacity (int 0)
                    , pointerEventsNone
                    ]
    in
    styled div
        [ position fixed
        , width (vw 100)
        , height (vh 100)
        , top zero
        , left zero
        , backgroundColor (rgba 0 0 0 0.5)
        , transition "opacity 0.5s"
        , zIndex (int 2)
        , activeStyle
        ]
        [ class "overlay"
        , onClick CloseAllPanels
        ]
        []


starBtn : String -> Bool -> (Bool -> Msg) -> Html Msg
starBtn idString selected clickHandle =
    let
        iconFill =
            if selected then
                theme.colorAccent
            else
                rgba 0 0 0 0
    in
    styled span
        [ marginRight theme.distanceXXS ]
        [ class "starBtn" ]
        [ styled Html.Styled.input
            [ display none ]
            [ type_ "checkbox"
            , id ("starred_" ++ idString)
            , onCheck clickHandle
            , Html.Styled.Attributes.checked selected
            ]
            []
        , label
            [ for ("starred_" ++ idString)
            , ariaLabel "starred" |> Html.Styled.Attributes.fromUnstyled
            ]
            [ starIcon
                [ width (Css.rem 1.3)
                , height (Css.rem 1.3)
                , stroke theme.colorAccent.value
                , transition "fill 0.5s"
                , Css.fill iconFill
                ]
            ]
        ]


article : List (Attribute msg) -> List (Html msg) -> Html msg
article =
    styled Html.Styled.article
        [ descendants
            [ selector "a"
                [ color theme.colorPrimary ]
            ]
        , clear "both"
        , marginBottom theme.distanceM
        , overflow hidden
        , maxHeight (Css.rem 10)
        , position relative
        , after
            [ pseudoContent
            , position absolute
            , bottom zero
            , left zero
            , width (pct 100)
            , height theme.distanceXXL
            , backgroundImage <| linearGradient (stop2 theme.colorTransparent <| pct 0) (stop theme.colorBackground) []
            ]
        ]


articleTitle : List (Attribute msg) -> List (Html msg) -> Html msg
articleTitle =
    styled h2
        [ descendants
            [ selector "a"
                [ color theme.colorPrimary ]
            ]
        ]


getAnimationClassTopLayers panelState =
    getPanelClass "is-hidden" "slideDown" "slideUp" panelState


getModalAnimationClass panelState =
    getPanelClass "is-hidden" "popInCentered" "popOutCentered" panelState


errorMessage : String -> String -> Html Msg
errorMessage animationClass errorMsg =
    styled div
        [ backgroundColor theme.colorAlert
        , color theme.white
        , maxHeight (Css.rem 4)
        , overflow hidden
        ]
        [ class <| "errorMsg" ++ animationClass ]
        [ styled div
            [ displayFlex
            , justifyContent spaceBetween
            , border3 (px 2) solid theme.white
            , standardPadding
            ]
            [ class "errorMsg-inner" ]
            [ span
                [ class "errorMsg-text" ]
                [ text errorMsg ]
            , closeBtn (RequestRemoveErrorMsg errorMsg)
            ]
        ]


closeBtn : msg -> Html msg
closeBtn clickHandler =
    btnNoStyle
        [ class "closeButton"
        , onClick clickHandler
        , ariaLabel "close" |> Html.Styled.Attributes.fromUnstyled
        ]
        [ span
            [ ariaHidden True |> Html.Styled.Attributes.fromUnstyled ]
            [ String.fromChar (Char.fromCode 215) |> text ]
        ]
