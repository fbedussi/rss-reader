module StyledAria exposing(..)

import Html
import Html.Styled
import Html.Styled.Attributes exposing (fromUnstyled)

toStyledAria : Html.Attribute msg -> Html.Styled.Attribute msg
toStyledAria attribute =
    attribute |> fromUnstyled