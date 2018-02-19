module PartialViews.Icons exposing (..)

import Html.Styled exposing (Html)
import Msgs exposing (..)
import Svg.Styled exposing (path, svg, styled)
import Svg.Styled.Attributes exposing (viewBox, d, strokeWidth, strokeLinecap, strokeLinejoin, fill, class, style)
import Css exposing (batch, display, width, height, vertical, inlineBlock, em, currentColor, verticalAlign, middle)
import Models exposing (Selected)

iconStyle : Css.Style
iconStyle =
    batch 
        [ display inlineBlock
        , width (em 1)
        , height (em 1)
        , Css.fill currentColor
        , verticalAlign middle
    ]

starIcon : List(Css.Style) ->Html Msg
starIcon styles=
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 79.087 75.38" ]
        [ path
            [ d "M63.743 73.86L39.757 56.285 15.939 74.18l9.303-28.243L.862 28.815l29.735.12L39.347.458l9.076 28.317 29.787-.478-24.127 17.38z"
            , strokeWidth "3"
            , strokeLinecap "round"
            , strokeLinejoin "bevel"
            ]
            []
        ]


refreshIcon : List(Css.Style) -> Html Msg
refreshIcon styles=
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.901 2.599c-1.463-1.597-3.565-2.599-5.901-2.599-4.418 0-8 3.582-8 8h1.5c0-3.59 2.91-6.5 6.5-6.5 1.922 0 3.649 0.835 4.839 2.161l-2.339 2.339h5.5v-5.5l-2.099 2.099z" ]
            []
        , path [ d "M14.5 8c0 3.59-2.91 6.5-6.5 6.5-1.922 0-3.649-0.835-4.839-2.161l2.339-2.339h-5.5v5.5l2.099-2.099c1.463 1.597 3.565 2.599 5.901 2.599 4.418 0 8-3.582 8-8h-1.5z" ]
            []
        ]


importIcon : List(Css.Style) -> Html Msg
importIcon styles =
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M8 9l4-4h-3v-4h-2v4h-3zM11.636 7.364l-1.121 1.121 4.064 1.515-6.579 2.453-6.579-2.453 4.064-1.515-1.121-1.121-4.364 1.636v4l8 3 8-3v-4z" ]
            []
        ]

cancelIcon : List(Css.Style) -> Html msg
cancelIcon styles =
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M8 0c-4.418 0-8 3.582-8 8s3.582 8 8 8 8-3.582 8-8-3.582-8-8-8zM8 14.5c-3.59 0-6.5-2.91-6.5-6.5s2.91-6.5 6.5-6.5 6.5 2.91 6.5 6.5-2.91 6.5-6.5 6.5z" ]
            []
        , path [ d "M10.5 4l-2.5 2.5-2.5-2.5-1.5 1.5 2.5 2.5-2.5 2.5 1.5 1.5 2.5-2.5 2.5 2.5 1.5-1.5-2.5-2.5 2.5-2.5z" ]
            []
        ]

searchIcon : List(Css.Style) -> Html msg
searchIcon styles=
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M15.504 13.616l-3.79-3.223c-0.392-0.353-0.811-0.514-1.149-0.499 0.895-1.048 1.435-2.407 1.435-3.893 0-3.314-2.686-6-6-6s-6 2.686-6 6 2.686 6 6 6c1.486 0 2.845-0.54 3.893-1.435-0.016 0.338 0.146 0.757 0.499 1.149l3.223 3.79c0.552 0.613 1.453 0.665 2.003 0.115s0.498-1.452-0.115-2.003zM6 10c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z" ]
            []
        ]

editIcon : List(Css.Style) -> Html msg
editIcon styles=
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.5 0c1.381 0 2.5 1.119 2.5 2.5 0 0.563-0.186 1.082-0.5 1.5l-1 1-3.5-3.5 1-1c0.418-0.314 0.937-0.5 1.5-0.5zM1 11.5l-1 4.5 4.5-1 9.25-9.25-3.5-3.5-9.25 9.25zM11.181 5.681l-7 7-0.862-0.862 7-7 0.862 0.862z" ]
            []
        ]

deleteIcon : List(Css.Style) -> Html msg
deleteIcon styles=
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M2 5v10c0 0.55 0.45 1 1 1h9c0.55 0 1-0.45 1-1v-10h-11zM5 14h-1v-7h1v7zM7 14h-1v-7h1v7zM9 14h-1v-7h1v7zM11 14h-1v-7h1v7z" ]
            []
        , path [ d "M13.25 2h-3.25v-1.25c0-0.412-0.338-0.75-0.75-0.75h-3.5c-0.412 0-0.75 0.338-0.75 0.75v1.25h-3.25c-0.413 0-0.75 0.337-0.75 0.75v1.25h13v-1.25c0-0.413-0.338-0.75-0.75-0.75zM9 2h-3v-0.987h3v0.987z" ]
            []
        ]

plusIcon : List(Css.Style) -> Html msg
plusIcon styles =
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M15.5 6h-5.5v-5.5c0-0.276-0.224-0.5-0.5-0.5h-3c-0.276 0-0.5 0.224-0.5 0.5v5.5h-5.5c-0.276 0-0.5 0.224-0.5 0.5v3c0 0.276 0.224 0.5 0.5 0.5h5.5v5.5c0 0.276 0.224 0.5 0.5 0.5h3c0.276 0 0.5-0.224 0.5-0.5v-5.5h5.5c0.276 0 0.5-0.224 0.5-0.5v-3c0-0.276-0.224-0.5-0.5-0.5z" ]
            []
        ]

checkIcon : List(Css.Style) -> Html msg
checkIcon styles =
    styled svg
         ([iconStyle] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.5 2l-7.5 7.5-3.5-3.5-2.5 2.5 6 6 10-10z" ]
            []
        ]

folderIcon : List(Css.Style) -> Selected -> Html msg
folderIcon styles selected = 
    let
        plusVerticalStyle = "transition: transform 0.5s; transform-origin: center center;"
    in
    styled svg
        ([iconStyle] ++ styles)
        [viewBox "0 0 16 16" ]
        [ path [ d "M9 4L7 2H0v13h16V4z" ]
            []
        , path [ d "M5.017 9H11v2H5.017z", fill "#fff", class "plusHorizontal" ]
            []
        , path 
            ([d "M7.008 7.008h2v5.983h-2z", fill "#fff", class "plusVertical", style (if selected then plusVerticalStyle ++ "transform: rotate(90deg);" else plusVerticalStyle)])
            []
        ]