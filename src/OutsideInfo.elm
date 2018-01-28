port module OutsideInfo exposing (..)

import Decoder exposing (decodeData, decodeDbOpened, decodeUser)
import Json.Encode exposing (..)
import Models exposing (..)


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


type InfoForOutside
    = LoginRequest LoginData
    | OpenDb UserUid
    | ReadAllData
    | AddCategory Category



-- | UpdateCategory Category
-- | DeleteCategory Category
-- | AddSite Site
-- | UpdateSite Site
-- | DeleteSite Site


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
            let
                addCategoryPayload =
                    object
                        [ ( "id", category.id |> int )
                        , ( "name", category.name |> string )
                        ]
            in
            infoForOutside { tag = "addCategory", data = addCategoryPayload }


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
