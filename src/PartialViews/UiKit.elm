module PartialViews.UiKit exposing (alertBtn, appearance, article, articleTitle, badge, btn, btnNoStyle, btnNoStyleStyle, btnStyle, buttonHeightInRem, categoryWrapper, checkbox, clear, clipZero, closeBtn, closeButton, customCss, deleteActionsPanel, distancesInRem, errorMessage, getAnimationClassTopLayers, getModalAnimationClass, hairlineWidthInPx, input, inputHeightInRem, inputRow, inputRowLabel, inputRowText, layerInner, layerStyle, layerTop, noStyle, onDesktop, overlay, pointerEventsNone, pseudoContent, secondaryBtn, select, selectableBtn, sidebarBoxStyle, sidebarRow, sidebarSelectionBtn, standardPadding, starBtn, stroke, tabContentOuter, theme, transformOrigin, transition, visuallyHiddenStyle)

import Char
import Css exposing (..)
import Css.Global exposing (descendants, selector)
import Css.Media exposing (only, screen, withMedia)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabel)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, for, fromUnstyled, id, type_, value)
import Html.Styled.Events exposing (onCheck, onClick, onInput)
import Models exposing (ErrorBoxMsg(..), ErrorMsg, Msg(..), Panel, Selected)
import PanelsManager exposing (getPanelClass)
import PartialViews.Icons exposing (closeIcon, starIcon)


inputHeightInRem : Float
inputHeightInRem =
    distancesInRem.l


distancesInRem : { l : Float, m : Float, s : Float, xl : Float, xs : Float, xxl : Float, xxxl : Float, xxxs : Float, xxs : Float }
distancesInRem =
    { xxxl = 4.25
    , xxl = 3.75
    , xl = 3.25
    , l = 2.75
    , m = 2.25
    , s = 1.75
    , xs = 1.25
    , xxs = 0.75
    , xxxs = 0.25
    }


hairlineWidthInPx : number
hairlineWidthInPx =
    2


buttonHeightInRem =
    distancesInRem.m


theme =
    { colorPrimary = hex "008080"
    , colorSecondary = hex "673C4F"
    , colorAccent = hex "EAC435"
    , colorPrimaryLight = hex "03CEA4"
    , colorSecondaryLight = hex "FB4D3D"
    , colorHairline = hex "e4e4e4"
    , colorBackground = hex "ffffff"
    , colorTransparent = rgba 0 0 0 0
    , colorAlert = hex "ff0000"
    , white = hex "ffffff"
    , black = hex "000000"
    , inputHeight = calc (Css.rem inputHeightInRem) minus (Css.px <| hairlineWidthInPx)
    , buttonHeight = Css.rem buttonHeightInRem
    , hairlineWidth = px hairlineWidthInPx
    , distanceXXXL = Css.rem distancesInRem.xxxl
    , distanceXXL = Css.rem distancesInRem.xxl
    , distanceXL = Css.rem distancesInRem.xl
    , distanceL = Css.rem distancesInRem.l
    , distanceM = Css.rem distancesInRem.m
    , distanceS = Css.rem distancesInRem.s
    , distanceXS = Css.rem distancesInRem.xs
    , distanceXXS = Css.rem distancesInRem.xxs
    , distanceXXXS = Css.rem distancesInRem.xxxs
    , fontSizeBase = Css.rem 1
    , fontSizeSubtitle = Css.rem 1.25
    , fontSizeTitle = Css.rem 1
    , fontSizeTitleDesktop = Css.rem 1.5
    , headerHeight = Css.rem (buttonHeightInRem + (distancesInRem.xxs * 2))
    , breakpoints =
        { desktop = 900
        }
    , zIndex =
        { base = int 1
        , headerDesktop = int 10
        , overlay = int 20
        , headerSmartphone = int 30
        , menu = int 40
        , layer = int 50
        , deleteActions = int 60
        , sidebarRow = int 70
        }
    }


onDesktop : List Style -> Style
onDesktop =
    withMedia [ only screen [ Css.Media.minWidth <| px theme.breakpoints.desktop ] ]


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


btnStyle : Bool -> Style
btnStyle selected =
    batch
        [ display inlineBlock
        , minHeight theme.buttonHeight
        , padding2 theme.distanceXXXS theme.distanceXXS
        , if selected then
            backgroundColor theme.colorPrimaryLight

          else
            backgroundColor theme.colorPrimary
        , color theme.white
        , appearance "none"
        , border3 (px 2) solid transparent
        , transition "all 0.5s"
        , textTransform uppercase
        , fontWeight bold
        , borderRadius (px 3)
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
    styled button [ btnStyle False ]


selectableBtn : Bool -> List (Attribute msg) -> List (Html msg) -> Html msg
selectableBtn selected =
    styled button
        [ btnStyle selected ]


alertBtn : List (Attribute msg) -> List (Html msg) -> Html msg
alertBtn =
    styled button
        [ btnStyle False
        , borderColor theme.colorAlert
        , backgroundColor theme.colorAlert
        , hover
            [ borderColor theme.colorAlert
            , backgroundColor transparent
            , color theme.black
            ]
        ]


input : List (Attribute msg) -> List (Html msg) -> Html msg
input =
    styled Html.Styled.input
        [ display inlineBlock
        , height theme.inputHeight

        --, padding2 theme.distanceXXXS theme.distanceXS
        , standardPadding
        , border3 theme.hairlineWidth solid theme.colorHairline
        ]


select : List (Attribute msg) -> List (Html msg) -> Html msg
select =
    styled Html.Styled.select
        [ display inlineBlock
        , height theme.inputHeight
        , padding2 theme.distanceXXXS theme.distanceXS
        , border3 theme.hairlineWidth solid theme.colorHairline
        , backgroundColor theme.colorBackground
        ]


secondaryBtn : List (Attribute msg) -> List (Html msg) -> Html msg
secondaryBtn =
    styled button
        [ btnStyle False
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
        , standardPadding
        , textAlign left
        , displayFlex
        , alignItems center
        , flex (int 1)
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
            batch
                [ backgroundColor theme.colorPrimaryLight
                , zIndex theme.zIndex.sidebarRow
                ]
    in
    styled div
        [ displayFlex
        , justifyContent spaceBetween
        , position relative
        , alignItems center
        , backgroundColor theme.colorBackground
        , width (pct 100)
        , zIndex (int 2)
        , transition "background-color 0.5s"
        , if selected then
            selectedStyle

          else
            batch []
        , hover
            [ selectedStyle
            ]
        ]


tabContentOuter : Int -> List (Attribute msg) -> List (Html msg) -> Html msg
tabContentOuter h =
    styled div
        [ transition "height 0.5s"
        , overflow hidden
        , height (px (toFloat h))
        ]


deleteActionsPanel : List (Attribute msg) -> List (Html msg) -> Html msg
deleteActionsPanel =
    styled div
        [ position absolute
        , top (px 1)
        , right (px 1)
        , displayFlex
        , backgroundColor theme.colorBackground
        , transition "transform 0.5s"
        , zIndex theme.zIndex.deleteActions
        ]


badge : List (Attribute msg) -> List (Html msg) -> Html msg
badge =
    styled div
        [ display inlineBlock
        , backgroundColor theme.colorAccent
        , color theme.white
        , fontSize (Css.rem 0.7)
        , borderRadius (pct 25)
        , textAlign center
        , padding (Css.rem 0.2)
        , verticalAlign middle
        , marginRight (Css.rem 0.5)
        ]


layerStyle : Style
layerStyle =
    batch
        [ position fixed
        , zIndex theme.zIndex.layer
        , backgroundColor theme.colorBackground
        , standardPadding
        , border3 (px 2) solid theme.colorHairline
        ]


closeButton : msg -> Html msg
closeButton closer =
    styled div
        [ textAlign right
        , marginBottom theme.distanceXS
        , color theme.colorPrimary
        ]
        [ class "closeButtonWrapper" ]
        [ btnNoStyle
            [ onClick closer ]
            [ closeIcon []
            , styled span
                [ visuallyHiddenStyle ]
                []
                [ text "close" ]
            ]
        ]


layerTop : msg -> List (Attribute msg) -> List (Html msg) -> Html msg
layerTop closer attributes children =
    styled div
        [ layerStyle
        , top zero
        , left zero
        , width (pct 100)
        , transforms [ translateY (pct -100) ]
        ]
        attributes
        ([ closeButton closer ] ++ children)


inputRow : List (Attribute msg) -> List (Html msg) -> Html msg
inputRow attributes children =
    styled div
        [ marginBottom (Css.rem 0.5)
        , displayFlex
        , flexDirection column
        , onDesktop
            [ alignItems center
            , flexDirection row
            , height theme.inputHeight
            ]
        ]
        ([ class "inputRow" ] ++ attributes)
        children


inputRowLabel : String -> String -> Html msg
inputRowLabel inputId labelText =
    styled label
        [ onDesktop
            [ flex (int 1) ]
        ]
        [ class "inputLabel"
        , for inputId
        ]
        [ text (labelText ++ " ") ]


inputRowText : String -> String -> String -> (String -> msg) -> Html msg
inputRowText idText labelText val inputHandler =
    inputRow
        []
        [ inputRowLabel idText labelText
        , styled input
            [ onDesktop
                [ flex (int 5) ]
            ]
            [ class "input"
            , id idText
            , value val
            , onInput inputHandler
            , type_ "text"
            ]
            []
        ]


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
        , zIndex theme.zIndex.overlay
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
        , overflow hidden
        , position relative
        , after
            [ pseudoContent
            , display block
            , bottom zero
            , left zero
            , width (pct 100)
            , height theme.distanceXXXL
            , backgroundImage <| linearGradient (stop2 theme.colorTransparent <| pct 0) (stop2 theme.colorBackground <| pct 60) []
            ]
        ]


articleTitle : List (Attribute msg) -> List (Html msg) -> Html msg
articleTitle =
    styled h2
        [ descendants
            [ selector "a"
                [ color theme.colorPrimary
                , textDecoration none
                , backgroundImage none
                ]
            ]
        , marginBottom (Css.em 0.5)
        ]


getAnimationClassTopLayers panelState =
    getPanelClass "is-hidden" "slideDown" "slideUp" panelState


getModalAnimationClass panelState =
    getPanelClass "is-hidden" "popInCentered" "popOutCentered" panelState


errorMessage : String -> ErrorMsg -> Html Msg
errorMessage animationClass errorMsg =
    styled div
        [ backgroundColor theme.colorAlert
        , color theme.white
        , height (Css.rem 2.5)
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
                [ text errorMsg.text ]
            , closeBtn <| ErrorBoxMsg <| RequestRemoveErrorMsg errorMsg
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


checkbox : String -> Bool -> Attribute msg -> Html msg
checkbox checkboxId selected clickHandler =
    span
        [ class "checkboxContainer" ]
        [ styled Html.Styled.input
            [ display none ]
            [ type_ "checkbox"
            , Html.Styled.Attributes.checked selected
            , id checkboxId
            , clickHandler
            ]
            []
        , styled label
            [ display inlineBlock
            , width theme.inputHeight
            , height theme.inputHeight
            , border3 theme.hairlineWidth solid theme.colorHairline
            , position relative
            , after
                [ pseudoContent
                , position absolute
                , top (pct 15)
                , left (pct 15)
                , width (pct 70)
                , height (pct 70)
                , if selected then
                    backgroundColor theme.colorPrimary

                  else
                    backgroundColor transparent
                ]
            ]
            [ for checkboxId ]
            []
        ]
