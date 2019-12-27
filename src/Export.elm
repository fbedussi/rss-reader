module Export exposing (encodeOpml)

import Json.Encode as Encode
import Models exposing (Category, OpmlCategory, Site)


encodeOpml : List Category -> List Site -> Encode.Value
encodeOpml categories sites =
    let
        categoriesToExport =
            categories |> List.map (convertCategoryInCategoryToExport sites)

        orphanSites =
            List.filter (\site -> List.isEmpty site.categoriesId) sites
    in
    opmlEncoder categoriesToExport orphanSites


convertCategoryInCategoryToExport : List Site -> Category -> OpmlCategory
convertCategoryInCategoryToExport sites category =
    OpmlCategory
        category.name
        (List.filter
            (\site -> List.member category.id site.categoriesId)
            sites
        )


opmlEncoder : List OpmlCategory -> List Site -> Encode.Value
opmlEncoder categoriesToExport orphanSites =
    Encode.object
        [ ( "head", headEncoder )
        , ( "categories", Encode.list opmlCategoryEncoder categoriesToExport )
        , ( "orphanSites", Encode.list opmlSiteEncoder orphanSites )
        ]


headEncoder : Encode.Value
headEncoder =
    Encode.object
        [ ( "title", Encode.string "Subscriptions" ) ]


opmlCategoryEncoder : OpmlCategory -> Encode.Value
opmlCategoryEncoder categoryToExport =
    Encode.object
        [ ( "name", Encode.string categoryToExport.name )
        , ( "_children", opmlSitesEncoder categoryToExport.sites )
        ]


opmlSitesEncoder : List Site -> Encode.Value
opmlSitesEncoder sites =
    Encode.list opmlSiteEncoder sites


opmlSiteEncoder : Site -> Encode.Value
opmlSiteEncoder site =
    Encode.object
        [ ( "type", Encode.string "rss" )
        , ( "text", Encode.string site.name )
        , ( "title", Encode.string site.name )
        , ( "xmlurl", Encode.string site.rssLink )
        , ( "htmlUrl", Encode.string site.webLink )
        ]
