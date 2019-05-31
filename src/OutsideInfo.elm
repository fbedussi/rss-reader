port module OutsideInfo exposing (encodeArticle, encodeCategory, encodeIdList, encodeOptions, encodeSite, getInfoFromOutside, infoForElmPort, infoForOutside, sendInfoOutside, switchInfoForElm)

import Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser)
import Json.Encode exposing (..)
import Models exposing (..)
import Time exposing (posixToMillis)


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElmPort : (GenericOutsideData -> msg) -> Sub msg


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

        DeleteArticlesInDb articleToDeleteIds ->
            infoForOutside { tag = "deleteArticles", data = encodeIdList articleToDeleteIds }

        SaveOptions options ->
            infoForOutside { tag = "saveOptions", data = encodeOptions options }

        SaveLastRefreshedTime lastRefreshedTime ->
            let
                refreshedTimeData =
                    object
                        [ ( "lastRefreshedTime", lastRefreshedTime |> posixToMillis |> int ) ]
            in
            infoForOutside { tag = "saveLastRefreshedTime", data = refreshedTimeData }

        SaveAllData ( categories, sites, articles ) ->
            let
                allData =
                    object
                        [ ( "categories", categories |> list encodeCategory )
                        , ( "sites", sites |> list encodeSite )
                        , ( "articles", articles |> list encodeArticle )
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
    infoForElmPort
        (\outsideInfo ->
            case outsideInfo.tag of
                "loginResult" ->
                    case decodeUser outsideInfo.data of
                        Ok userUid ->
                            tagger <| UserLoggedIn userUid

                        Err e ->
                            onError "Login error"

                "dbOpened" ->
                    case decodeDbOpened outsideInfo.data of
                        Ok dbOpened ->
                            tagger <| DbOpened

                        Err e ->
                            onError "Cannot open the DB"

                "allData" ->
                    case decodeData outsideInfo.data of
                        Ok data ->
                            tagger <| NewData data.categories data.sites data.articles data.options data.lastRefreshedTime

                        Err e ->
                            onError "Error receiving data"

                "error" ->
                    case decodeError outsideInfo.data of
                        Ok errorString ->
                            onError errorString

                        Err e ->
                            onError "Error received"

                _ ->
                    onError <| "Unexpected info from outside " {- ++ Debug.toString outsideInfo -}
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
        , ( "categoriesId", site.categoriesId |> list int )
        , ( "name", site.name |> string )
        , ( "rssLink", site.rssLink |> string )
        , ( "webLink", site.webLink |> string )
        , ( "starred", site.starred |> bool )
        ]


encodeIdList : List Id -> Value
encodeIdList ids =
    list int ids


encodeArticle : Article -> Value
encodeArticle article =
    object
        [ ( "id", article.id |> int )
        , ( "siteId", article.siteId |> int )
        , ( "link", article.link |> string )
        , ( "title", article.title |> string )
        , ( "excerpt", article.excerpt |> string )
        , ( "starred", article.starred |> bool )
        , ( "date", article.date |> posixToMillis |> int )
        ]


encodeOptions : Options -> Value
encodeOptions options =
    object
        [ ( "articlesPerPage", options.articlesPerPage |> int )
        , ( "articlePreviewHeightInEm", options.articlePreviewHeightInEm |> float )
        ]
