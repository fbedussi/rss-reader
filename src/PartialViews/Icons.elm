module PartialViews.Icons exposing (arrowTop, cancelIcon, checkIcon, closeIcon, cogIcon, deleteIcon, editIcon, exitIcon, folderIcon, iconStyle, importIcon, logo, menuIcon, plusIcon, refreshIcon, rssIcon, searchIcon, starIcon)

import Css exposing (batch, currentColor, display, em, height, inlineBlock, middle, vertical, verticalAlign, width)
import Html.Styled exposing (Html)
import Models exposing (Msg, Selected)
import Svg.Styled exposing (path, styled, svg)
import Svg.Styled.Attributes exposing (class, d, fill, strokeLinecap, strokeLinejoin, strokeWidth, style, viewBox)


iconStyle : Css.Style
iconStyle =
    batch
        [ display inlineBlock
        , width (em 1)
        , height (em 1)
        , Css.fill currentColor
        , verticalAlign middle
        ]


starIcon : List Css.Style -> Html Msg
starIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 79.087 75.38" ]
        [ path
            [ d "M63.743 73.86L39.757 56.285 15.939 74.18l9.303-28.243L.862 28.815l29.735.12L39.347.458l9.076 28.317 29.787-.478-24.127 17.38z"
            , strokeWidth "3"
            , strokeLinecap "round"
            , strokeLinejoin "bevel"
            ]
            []
        ]


refreshIcon : List Css.Style -> Html Msg
refreshIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.901 2.599c-1.463-1.597-3.565-2.599-5.901-2.599-4.418 0-8 3.582-8 8h1.5c0-3.59 2.91-6.5 6.5-6.5 1.922 0 3.649 0.835 4.839 2.161l-2.339 2.339h5.5v-5.5l-2.099 2.099z" ]
            []
        , path [ d "M14.5 8c0 3.59-2.91 6.5-6.5 6.5-1.922 0-3.649-0.835-4.839-2.161l2.339-2.339h-5.5v5.5l2.099-2.099c1.463 1.597 3.565 2.599 5.901 2.599 4.418 0 8-3.582 8-8h-1.5z" ]
            []
        ]


importIcon : List Css.Style -> Html Msg
importIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M8 9l4-4h-3v-4h-2v4h-3zM11.636 7.364l-1.121 1.121 4.064 1.515-6.579 2.453-6.579-2.453 4.064-1.515-1.121-1.121-4.364 1.636v4l8 3 8-3v-4z" ]
            []
        ]


cancelIcon : List Css.Style -> Html msg
cancelIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M8 0c-4.418 0-8 3.582-8 8s3.582 8 8 8 8-3.582 8-8-3.582-8-8-8zM8 14.5c-3.59 0-6.5-2.91-6.5-6.5s2.91-6.5 6.5-6.5 6.5 2.91 6.5 6.5-2.91 6.5-6.5 6.5z" ]
            []
        , path [ d "M10.5 4l-2.5 2.5-2.5-2.5-1.5 1.5 2.5 2.5-2.5 2.5 1.5 1.5 2.5-2.5 2.5 2.5 1.5-1.5-2.5-2.5 2.5-2.5z" ]
            []
        ]


searchIcon : List Css.Style -> Html msg
searchIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M15.504 13.616l-3.79-3.223c-0.392-0.353-0.811-0.514-1.149-0.499 0.895-1.048 1.435-2.407 1.435-3.893 0-3.314-2.686-6-6-6s-6 2.686-6 6 2.686 6 6 6c1.486 0 2.845-0.54 3.893-1.435-0.016 0.338 0.146 0.757 0.499 1.149l3.223 3.79c0.552 0.613 1.453 0.665 2.003 0.115s0.498-1.452-0.115-2.003zM6 10c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z" ]
            []
        ]


editIcon : List Css.Style -> Html msg
editIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.5 0c1.381 0 2.5 1.119 2.5 2.5 0 0.563-0.186 1.082-0.5 1.5l-1 1-3.5-3.5 1-1c0.418-0.314 0.937-0.5 1.5-0.5zM1 11.5l-1 4.5 4.5-1 9.25-9.25-3.5-3.5-9.25 9.25zM11.181 5.681l-7 7-0.862-0.862 7-7 0.862 0.862z" ]
            []
        ]


deleteIcon : List Css.Style -> Html msg
deleteIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M2 5v10c0 0.55 0.45 1 1 1h9c0.55 0 1-0.45 1-1v-10h-11zM5 14h-1v-7h1v7zM7 14h-1v-7h1v7zM9 14h-1v-7h1v7zM11 14h-1v-7h1v7z" ]
            []
        , path [ d "M13.25 2h-3.25v-1.25c0-0.412-0.338-0.75-0.75-0.75h-3.5c-0.412 0-0.75 0.338-0.75 0.75v1.25h-3.25c-0.413 0-0.75 0.337-0.75 0.75v1.25h13v-1.25c0-0.413-0.338-0.75-0.75-0.75zM9 2h-3v-0.987h3v0.987z" ]
            []
        ]


plusIcon : List Css.Style -> Html msg
plusIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M15.5 6h-5.5v-5.5c0-0.276-0.224-0.5-0.5-0.5h-3c-0.276 0-0.5 0.224-0.5 0.5v5.5h-5.5c-0.276 0-0.5 0.224-0.5 0.5v3c0 0.276 0.224 0.5 0.5 0.5h5.5v5.5c0 0.276 0.224 0.5 0.5 0.5h3c0.276 0 0.5-0.224 0.5-0.5v-5.5h5.5c0.276 0 0.5-0.224 0.5-0.5v-3c0-0.276-0.224-0.5-0.5-0.5z" ]
            []
        ]


checkIcon : List Css.Style -> Html msg
checkIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.5 2l-7.5 7.5-3.5-3.5-2.5 2.5 6 6 10-10z" ]
            []
        ]


folderIcon : List Css.Style -> Selected -> Html msg
folderIcon styles selected =
    let
        plusVerticalStyle =
            "transition: transform 0.5s; transform-origin: center 62%;"
    in
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M9 4L7 2H0v13h16V4z" ]
            []
        , path [ d "M5.017 9H11v2H5.017z", fill "#fff", class "plusHorizontal" ]
            []
        , path
            [ d "M7.008 7.008h2v5.983h-2z"
            , fill "#fff"
            , class "plusVertical"
            , style
                (if selected then
                    plusVerticalStyle ++ "transform: rotate(90deg);"

                 else
                    plusVerticalStyle
                )
            ]
            []
        ]


rssIcon : List Css.Style -> Html msg
rssIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M2.13 11.733c-1.175 0-2.13.958-2.13 2.126 0 1.174.955 2.122 2.13 2.122a2.126 2.126 0 0 0 2.133-2.122 2.133 2.133 0 0 0-2.133-2.126zM.002 5.436v3.067c1.997 0 3.874.781 5.288 2.196a7.45 7.45 0 0 1 2.192 5.302h3.08c0-5.825-4.739-10.564-10.56-10.564zM.006 0v3.068C7.128 3.068 12.924 8.87 12.924 16H16C16 7.18 8.824 0 .006 0z" ]
            []
        ]


menuIcon : List Css.Style -> Html msg
menuIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M1 11h14v3H1z", Svg.Styled.Attributes.id "bottom" ]
            []
        , path [ d "M1 7h14v3H1z", Svg.Styled.Attributes.id "central" ]
            []
        , path [ d "M1 3h14v3H1z", Svg.Styled.Attributes.id "top" ]
            []
        , path [ d "M1 7h14v3H1z", Svg.Styled.Attributes.id "centralBis" ]
            []
        ]


arrowTop : List Css.Style -> Html msg
arrowTop styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M13.707 6.293l-5-5c-0.39-0.391-1.024-0.391-1.414 0l-5 5c-0.391 0.391-0.391 1.024 0 1.414s1.024 0.391 1.414 0l3.293-3.293v9.586c0 0.552 0.448 1 1 1s1-0.448 1-1v-9.586l3.293 3.293c0.195 0.195 0.451 0.293 0.707 0.293s0.512-0.098 0.707-0.293c0.391-0.391 0.391-1.024 0-1.414z" ]
            []
        ]


cogIcon : List Css.Style -> Html msg
cogIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M14.59 9.535c-0.839-1.454-0.335-3.317 1.127-4.164l-1.572-2.723c-0.449 0.263-0.972 0.414-1.529 0.414-1.68 0-3.042-1.371-3.042-3.062h-3.145c0.004 0.522-0.126 1.051-0.406 1.535-0.839 1.454-2.706 1.948-4.17 1.106l-1.572 2.723c0.453 0.257 0.845 0.634 1.123 1.117 0.838 1.452 0.336 3.311-1.12 4.16l1.572 2.723c0.448-0.261 0.967-0.41 1.522-0.41 1.675 0 3.033 1.362 3.042 3.046h3.145c-0.001-0.517 0.129-1.040 0.406-1.519 0.838-1.452 2.7-1.947 4.163-1.11l1.572-2.723c-0.45-0.257-0.839-0.633-1.116-1.113zM8 11.24c-1.789 0-3.24-1.45-3.24-3.24s1.45-3.24 3.24-3.24c1.789 0 3.24 1.45 3.24 3.24s-1.45 3.24-3.24 3.24z" ]
            []
        ]


exitIcon : List Css.Style -> Html msg
exitIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M12 10v-2h-5v-2h5v-2l3 3zM11 9v4h-5v3l-6-3v-13h11v5h-1v-4h-8l4 2v9h4v-3z" ]
            []
        ]


closeIcon : List Css.Style -> Html msg
closeIcon styles =
    styled svg
        ([ iconStyle ] ++ styles)
        [ viewBox "0 0 16 16" ]
        [ path [ d "M15.854 12.854c-0-0-0-0-0-0l-4.854-4.854 4.854-4.854c0-0 0-0 0-0 0.052-0.052 0.090-0.113 0.114-0.178 0.066-0.178 0.028-0.386-0.114-0.529l-2.293-2.293c-0.143-0.143-0.351-0.181-0.529-0.114-0.065 0.024-0.126 0.062-0.178 0.114 0 0-0 0-0 0l-4.854 4.854-4.854-4.854c-0-0-0-0-0-0-0.052-0.052-0.113-0.090-0.178-0.114-0.178-0.066-0.386-0.029-0.529 0.114l-2.293 2.293c-0.143 0.143-0.181 0.351-0.114 0.529 0.024 0.065 0.062 0.126 0.114 0.178 0 0 0 0 0 0l4.854 4.854-4.854 4.854c-0 0-0 0-0 0-0.052 0.052-0.090 0.113-0.114 0.178-0.066 0.178-0.029 0.386 0.114 0.529l2.293 2.293c0.143 0.143 0.351 0.181 0.529 0.114 0.065-0.024 0.126-0.062 0.178-0.114 0-0 0-0 0-0l4.854-4.854 4.854 4.854c0 0 0 0 0 0 0.052 0.052 0.113 0.090 0.178 0.114 0.178 0.066 0.386 0.029 0.529-0.114l2.293-2.293c0.143-0.143 0.181-0.351 0.114-0.529-0.024-0.065-0.062-0.126-0.114-0.178z" ]
            []
        ]


logo : List Css.Style -> Html msg
logo styles =
    styled svg
        styles
        [ viewBox "0 0 82.211 31.35" ]
        [ path
            [ d "M10.563 0C4.75 0 .023 4.717.002 10.52H0v15.455h3.066V10.52A7.426 7.426 0 0 1 5.262 5.27a7.447 7.447 0 0 1 5.3-2.19V0zM8.422 6.299a2.133 2.133 0 0 0-2.127 2.133c0 1.175.959 2.13 2.127 2.13a2.126 2.126 0 0 0 2.121-2.13 2.125 2.125 0 0 0-2.121-2.133zM12.062 8.558h3.066v17.417h-3.066zM17.617 15.355c0 4.548 2.895 8.421 6.932 9.907a12.876 12.876 0 0 1-8.285 3.011v3.077c8.82 0 16-7.177 16-15.995h-3.069c0 2.743-.865 5.284-2.33 7.377a7.426 7.426 0 0 1-3.974-2.074 7.453 7.453 0 0 1-2.194-5.303h-3.08z", style "fill: #008080" ]
            []
        , path
            [ d "M37.38 14.102h3.875v-.877H37.38V10.82c0-3.027.735-4.328 2.63-4.328 1.612 0 2.291.877 2.291 1.697v.594c0 .255.226.849.905.849.481 0 .877-.368.877-.82 0-2.122-2.206-3.14-4.101-3.14-1.273 0-2.263.48-2.914 1.414-.735 1.075-1.131 2.744-1.131 4.922v1.216h-3.705v.877h3.705V24.34c0 .82-.368 1.3-1.273 1.3h-1.612v.878h7.213v-.877h-1.64c-.906 0-1.245-.425-1.245-1.301V14.1z", style "fill: #4d4d4d" ]
            []
        , path
            [ d "M53.565 19.447c0-3.988-2.574-6.646-5.685-6.646-2.97 0-5.912 2.856-5.912 7.297 0 3.111 1.839 6.958 6.194 6.958 2.291 0 3.48-.764 5.714-3.62l-.736-.51c-1.3 1.782-2.517 3.253-4.695 3.253-2.856 0-5.034-2.941-5.034-6.081v-.65h10.154zm-10.098-.876c.424-2.885 2.263-4.894 4.413-4.894 1.244 0 2.206.396 2.941 1.188.764.792 1.16 2.037 1.273 3.706h-8.627zM66.742 19.447c0-3.988-2.573-6.646-5.685-6.646-2.97 0-5.911 2.856-5.911 7.297 0 3.111 1.838 6.958 6.194 6.958 2.291 0 3.48-.764 5.714-3.62l-.736-.51c-1.3 1.782-2.517 3.253-4.695 3.253-2.857 0-5.035-2.941-5.035-6.081v-.65h10.154zm-10.097-.876c.424-2.885 2.263-4.894 4.412-4.894 1.245 0 2.207.396 2.942 1.188.764.792 1.16 2.037 1.273 3.706h-8.627zM79.694 5.673c-1.386.764-2.602 1.16-3.62 1.16v.876c1.951 0 2.177.085 2.177.792v6.195c-1.018-1.047-2.29-1.556-3.818-1.556-3.507 0-6.11 3.055-6.11 6.477 0 4.243 2.292 7.1 5.63 7.1 2.12 0 3.224-.623 4.298-2.009v1.81h3.96v-.876h-1.16c-.735 0-1.357-.368-1.357-1.556V5.673zm-1.443 16.942c-.367 1.556-1.866 3.112-3.931 3.112-3.253 0-4.412-3.48-4.412-6.11 0-3.649 2.375-5.487 4.525-5.487 2.065 0 3.507 1.442 3.818 2.15v6.335z", style "fill: #4d4d4d" ]
            []
        ]
