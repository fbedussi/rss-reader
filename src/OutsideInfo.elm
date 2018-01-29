port module OutsideInfo exposing (..)

import Decoder exposing (decodeData, decodeDbOpened, decodeError, decodeUser)
import Json.Encode exposing (..)
import Models exposing (..)


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


type InfoForOutside
    = LoginRequest LoginData
    | OpenDb UserUid
    | ReadAllData
    | AddCategory Category
    | DeleteCategories (List Id)
    | UpdateCategory Category
    | AddSite Site
    | DeleteSites (List Id)
    | UpdateSite Site


type InfoForElm
    = UserLoggedIn UserUid
    | DbOpened
    | NewData (List Category)


type alias GenericOutsideData =
    { tag : String
    , data : Json.Encode.Value
    }


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

        AddCategory category ->
            infoForOutside { tag = "addCategory", data = encodeCategory category }

        DeleteCategories categoryToDeleteIds ->
            infoForOutside { tag = "deleteCategories", data = encodeIdList categoryToDeleteIds }

        UpdateCategory category ->
            infoForOutside { tag = "updateCategory", data = encodeCategory category }

        AddSite site ->
            infoForOutside { tag = "addSite", data = encodeSite site }

        DeleteSites siteToDeleteIds ->
            infoForOutside { tag = "deleteSites", data = encodeIdList siteToDeleteIds }

        UpdateSite site ->
            infoForOutside { tag = "updateSite", data = encodeSite site }


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
                        Ok categories ->
                            tagger <| NewData categories

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


switchInfoForElm : InfoForElm -> Model -> ( Model, Cmd msg )
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

        NewData categories ->
            ( { model | categories = categories }, Cmd.none )


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
