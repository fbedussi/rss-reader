module Import exposing (executeImport)

import Json.Decode exposing (..)
import Models exposing (Category, Model, Site)


type alias OpmlCategory =
    { sites : List Site
    , name : String
    }


executeImport : Model -> Model
executeImport model =
    let
        opmlCategoriesResult =
            decodeOpml model.importData
    in
    case opmlCategoriesResult of
        Ok opmlCategories ->
            let
                categories =
                    opmlCategories |> List.indexedMap extractCategoryFromOpml

                sites =
                    opmlCategories |> List.indexedMap extractSitesFromOpml |> List.concat |> List.indexedMap (\index site -> { site | id = index })
            in
            { model
                | categories = categories
                , sites = sites
            }

        Err err ->
            { model | errorMsg = err }


extractCategoryFromOpml : Int -> OpmlCategory -> Category
extractCategoryFromOpml index opmlCategory =
    Category
        index
        opmlCategory.name


extractSitesFromOpml : Int -> OpmlCategory -> List Site
extractSitesFromOpml categoryIndex opmlCategory =
    opmlCategory.sites
        |> List.map (extractSiteFromOpml categoryIndex)


extractSiteFromOpml : Int -> Site -> Site
extractSiteFromOpml categoryId site =
    { site | categoriesId = [ categoryId ] }


decodeOpml : String -> Result String (List OpmlCategory)
decodeOpml importData =
    Json.Decode.decodeString opmlDecoder importData


opmlDecoder : Decoder (List OpmlCategory)
opmlDecoder =
    field "body" (field "outline" (list opmlCategoryDecoder))


opmlCategoryDecoder : Decoder OpmlCategory
opmlCategoryDecoder =
    map2 OpmlCategory
        (field "outline" (list opmlSiteDecoder))
        (field "_title" string)


opmlSiteDecoder : Decoder Site
opmlSiteDecoder =
    map6 Site
        (succeed 0)
        (succeed [])
        (field "_title" string)
        (field "_xmlUrl" string)
        (field "_htmlUrl" string)
        (succeed False)
