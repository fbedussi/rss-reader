module PartialViews.Icons exposing (..)

import Html exposing (Html)
import Svg exposing (svg, path)
import Svg.Attributes exposing (..)
import Msgs exposing (..)

starIcon : Html Msg
starIcon =
    svg
        [ viewBox "0 0 79.087 75.38"]
        [Svg.path
            [d "M63.743 73.86L39.757 56.285 15.939 74.18l9.303-28.243L.862 28.815l29.735.12L39.347.458l9.076 28.317 29.787-.478-24.127 17.38z"
            , strokeWidth "3"
            , strokeLinecap "round"
            , strokeLinejoin "bevel"
            ]
            []
        ]