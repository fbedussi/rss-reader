port module OutsideInfo exposing (..)

import Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser)
import Json.Encode exposing (..)
import Models exposing (..)


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

        DeleteArticlesInDb articleToDeleteIds ->
            infoForOutside { tag = "deleteArticles", data = encodeIdList articleToDeleteIds }

        SaveAppData appData ->
            infoForOutside { tag = "saveAppData", data = encodeAppData appData }

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
                            tagger <| NewData data.categories data.sites data.articles data.appData

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

        NewData categories sites savedArticles appData ->
            ( { model
                | categories = categories
                , sites = sites
                , articles = savedArticles
                , appData = appData
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


encodeArticle : Article -> Value
encodeArticle article =
    object
        [ ( "id", article.id |> int )
        , ( "siteId", article.siteId |> int )
        , ( "link", article.link |> string )
        , ( "title", article.title |> string )
        , ( "excerpt", article.excerpt |> string )
        , ( "starred", article.starred |> bool )
        ]

encodeAppData : AppData -> Value
encodeAppData appData = 
    object
        [("lastRefreshTime", appData.lastRefreshTime |> round |> int)
        , ("articlesPerPage", appData.articlesPerPage |> int)
        ]