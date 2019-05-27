module HtmlParserUtils exposing (findElements, getElementsByTagName, getValue, mapElements)

import Html.Parser exposing (..)


getElementsByTagName : String -> List Node -> List Node
getElementsByTagName tagName nodes =
    let
        targetTagName =
            String.toLower tagName

        match tagNameToCheck _ =
            tagNameToCheck == targetTagName
    in
    findElements match nodes


findElements : (String -> List Attribute -> Bool) -> List Node -> List Node
findElements match nodes =
    let
        f node results =
            case node of
                Element tagName attrs children ->
                    if match tagName attrs then
                        results ++ (node :: findElements match children)

                    else
                        results ++ findElements match children

                _ ->
                    results
    in
    List.foldl f [] nodes


mapElements : (String -> List Attribute -> List Node -> b) -> List Node -> List b
mapElements f nodes =
    List.filterMap
        (\node ->
            case node of
                Element tagName attrs children ->
                    Just (f tagName attrs children)

                _ ->
                    Nothing
        )
        nodes


getValue : String -> List Attribute -> Maybe String
getValue targetName attrs =
    case attrs of
        [] ->
            Nothing

        ( name, value ) :: tail ->
            if name == targetName then
                Just value

            else
                getValue targetName tail
