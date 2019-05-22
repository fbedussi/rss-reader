module Import exposing (executeImport)

import Helpers exposing (createErrorMsg)
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
                ( filteredCategories, looseSites ) =
                    opmlCategories
                        |> List.foldl
                            (\opmlCategory ( filteredCategories_intermediate, looseSites_intermediate ) ->
                                if String.isEmpty opmlCategory.name then
                                    ( filteredCategories_intermediate, looseSites_intermediate ++ opmlCategory.sites )

                                else
                                    ( filteredCategories_intermediate ++ [ opmlCategory ], looseSites_intermediate )
                            )
                            ( [], [] )

                categories =
                    filteredCategories |> List.indexedMap extractCategoryFromOpml

                sites =
                    filteredCategories |> List.indexedMap extractSitesFromOpml |> List.concat |> List.append looseSites |> List.indexedMap (\index site -> { site | id = index })
            in
            { model
                | categories = categories
                , sites = sites
            }

        Err err ->
            { model | errorMsgs = model.errorMsgs ++ [ opmlErrorToString err |> createErrorMsg ] }


opmlErrorToString : Error -> String
opmlErrorToString err =
    "opmlCategory decoding error"


extractCategoryFromOpml : Int -> OpmlCategory -> Category
extractCategoryFromOpml index opmlCategory =
    Category
        index
        opmlCategory.name
        False
        False


extractSitesFromOpml : Int -> OpmlCategory -> List Site
extractSitesFromOpml categoryIndex opmlCategory =
    opmlCategory.sites
        |> List.map (extractSiteFromOpml categoryIndex)


extractSiteFromOpml : Int -> Site -> Site
extractSiteFromOpml categoryId site =
    { site | categoriesId = [ categoryId ] }


decodeOpml : String -> Result Error (List OpmlCategory)
decodeOpml importData =
    Json.Decode.decodeString opmlDecoder importData


opmlDecoder : Decoder (List OpmlCategory)
opmlDecoder =
    field "body" (field "outline" (list (oneOf [ opmlCategoryDecoder, opmlLooseSiteDecoder ])))


opmlCategoryDecoder : Decoder OpmlCategory
opmlCategoryDecoder =
    map2 OpmlCategory
        (field "outline" (list opmlSiteDecoder))
        (field "_title" string)


opmlLooseSiteDecoder : Decoder OpmlCategory
opmlLooseSiteDecoder =
    map2 OpmlCategory
        (map6 fakeSiteList
            (succeed 0)
            (succeed [])
            (field "_title" string)
            (field "_xmlUrl" string)
            (field "_htmlUrl" string)
            (succeed False)
        )
        (succeed "")


fakeSiteList : Models.Id -> List Int -> String -> String -> String -> Bool -> List Site
fakeSiteList id categoriesId name rssLink webLink starred =
    Site
        id
        categoriesId
        name
        rssLink
        webLink
        starred
        False
        0
        |> List.singleton


opmlSiteDecoder : Decoder Site
opmlSiteDecoder =
    map8 Site
        (succeed 0)
        (succeed [])
        (field "_title" string)
        (field "_xmlUrl" string)
        (field "_htmlUrl" string)
        (succeed False)
        (succeed False)
        (succeed 0)
