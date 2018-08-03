port module OutsideInfo exposing (..)

import Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser)
import Json.Encode exposing (..)
import Models exposing (..)
import Time exposing (Time)

port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        LoginRequest loginData ->
            let
                loginPayload =
                    object
                        [ ( "method", string "email" )
                        , ( "email", string loginData.email )
                        , ( "password", string loginData.password )
                        ]
            in
            infoForOutside { tag = "login", data = loginPayload }

        OpenDb userUid ->
            infoForOutside { tag = "openDb", data = string userUid }

        ReadAllData ->
            infoForOutside { tag = "readAllData", data = Json.Encode.string "" }

        AddCategoryInDb category ->
            infoForOutside { tag = "addCategory", data = encodeCategory category }

        DeleteCategoriesInDb categoryToDeleteIds ->
            infoForOutside { tag = "deleteCategories", data = encodeIdList categoryToDeleteIds }

        UpdateCategoryInDb category ->
            infoForOutside { tag = "updateCategory", data = encodeCategory category }

        AddSiteInDb site ->
            infoForOutside { tag = "addSite", data = encodeSite site }

        DeleteSitesInDb siteToDeleteIds ->
            infoForOutside { tag = "deleteSites", data = encodeIdList siteToDeleteIds }

        UpdateSiteInDb site ->
            infoForOutside { tag = "updateSite", data = encodeSite site }

        AddArticleInDb article ->
            infoForOutside { tag = "addArticle", data = encodeArticle article }

        AddArticlesInDb articles ->
            infoForOutside { tag = "addArticles", data = encodeArticles articles }

        DeleteArticlesInDb articleToDeleteIds ->
            infoForOutside { tag = "deleteArticles", data = encodeIdList articleToDeleteIds }

        SaveOptions options ->
            infoForOutside { tag = "saveOptions", data = encodeOptions options }

        SaveLastRefreshedTime lastRefreshedTime ->
            let
                refreshedTimeData =
                    object
                        [ ( "lastRefreshedTime", lastRefreshedTime |> float ) ]
            in
            infoForOutside { tag = "saveLastRefreshedTime", data = refreshedTimeData }
        

        SaveAllData ( categories, sites, articles ) ->
            let
                allData =
                    object
                        [ ( "categories", categories |> List.map encodeCategory |> list )
                        , ( "sites", sites |> List.map encodeSite |> list )
                        , ( "articles", articles |> List.map encodeArticle |> list )
                        ]
            in
            infoForOutside { tag = "saveAllData", data = allData }

        ToggleExcerptViaJs domId toOpen articlePreviewHeight ->
            let
                excerptData =
                    object
                        [ ( "domId", domId |> string )
                        , ( "toOpen", toOpen |> bool )
                        , ( "originalMaxHeight", articlePreviewHeight |> float )
                        ]
            in
            infoForOutside { tag = "toggleExcerpt", data = excerptData }

        InitReadMoreButtons ->
            infoForOutside { tag = "initReadMoreButtons", data = null }

        ScrollToTopViaJs ->
            infoForOutside { tag = "scrollToTop", data = null }

        SignOutViaJs ->
            infoForOutside { tag = "signOut", data = null }
        
            
                        


getInfoFromOutside : (InfoForElm -> msg) -> (String -> msg) -> Sub msg
getInfoFromOutside tagger onError =
    infoForElm
        (\outsideInfo ->
            case outsideInfo.tag of
                "loginResult" ->
                    case decodeUser outsideInfo.data of
                        Ok userUid ->
                            tagger <| UserLoggedIn userUid

                        Err e ->
                            onError e

                "dbOpened" ->
                    case decodeDbOpened outsideInfo.data of
                        Ok dbOpened ->
                            tagger <| DbOpened

                        Err e ->
                            onError e

                "allData" ->
                    case decodeData outsideInfo.data of
                        Ok data ->
                            tagger <| NewData data.categories data.sites data.articles data.options data.lastRefreshedTime

                        Err e ->
                            onError e

                "error" ->
                    case decodeError outsideInfo.data of
                        Ok errorString ->
                            onError errorString

                        Err e ->
                            onError e

                _ ->
                    onError <| "Unexpected info from outside: " ++ toString outsideInfo
        )


switchInfoForElm : InfoForElm -> Model -> ( Model, Cmd Msg )
switchInfoForElm infoForElm model =
    case infoForElm of
        UserLoggedIn userUid ->
            let
                loginData =
                    LoginData
                        "model.loginData.email"
                        ""
                        True
            in
            ( model
            , OpenDb userUid |> sendInfoOutside
            )

        DbOpened ->
            ( model, sendInfoOutside ReadAllData )

        NewData categories sites savedArticles options lastRefreshedTime ->
            ( { model
                | categories = categories
                , sites = sites
                , articles = savedArticles
                , options = options
                , lastRefreshTime = lastRefreshedTime
              }
            , Cmd.none
            )


encodeCategory : Category -> Value
encodeCategory category =
    object
        [ ( "id", category.id |> int )
        , ( "name", category.name |> string )
        ]


encodeSite : Site -> Value
encodeSite site =
    object
        [ ( "id", site.id |> int )
        , ( "categoriesId", site.categoriesId |> List.map int |> list )
        , ( "name", site.name |> string )
        , ( "rssLink", site.rssLink |> string )
        , ( "webLink", site.webLink |> string )
        , ( "starred", site.starred |> bool )
        ]


encodeIdList : List Id -> Value
encodeIdList ids =
    Json.Encode.list (List.map Json.Encode.int ids)


encodeArticles : List Article -> Value
encodeArticles articles =
    Json.Encode.list (List.map encodeArticle articles)


encodeArticle : Article -> Value
encodeArticle article =
    object
        [ ( "id", article.id |> int )
        , ( "siteId", article.siteId |> int )
        , ( "link", article.link |> string )
        , ( "title", article.title |> string )
        , ( "excerpt", article.excerpt |> string )
        , ( "starred", article.starred |> bool )
        , ( "date", article.date |> float)
        ]

encodeOptions : Options -> Value
encodeOptions options = 
    object
        [("articlesPerPage", options.articlesPerPage |> int)
        , ("articlePreviewHeightInEm", options.articlePreviewHeightInEm |> float)
        ]