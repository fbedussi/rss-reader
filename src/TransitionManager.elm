module TransitionManager
    exposing
        ( Id
        , TransitionState(..)
        , TransitionStore
        , WithTransitionStore
        , closeAll
        , delay
        , empty
        , getTransitionState
        , hideClosing
        , isOpen
        , isSomethingOpen
        , isTransitionOver
        , manageTransitionClass
        , open
        , prepareOpening
        , toTransitionManagerId
        , toggleState
        , toggleStateSelfish
        , transitionEnd
        , transitionStart
        , triggerClosing
        )

import Process
import Task
import Time exposing (Time)


type alias Id =
    String


type TransitionState
    = Hidden
    | Opening
    | Open
    | Closing


type alias ElementState =
    ( Id, TransitionState )


type TransitionStore
    = T (List ElementState)


type alias WithTransitionStore model =
    { model
        | transitionStore : TransitionStore
        , defaultTransitionDuration : Time
    }


type alias IdPrefix =
    String


empty : TransitionStore
empty =
    T []


toggleState : { a | transitionStore : TransitionStore } -> IdPrefix -> b -> msg -> msg -> Time -> ( { a | transitionStore : TransitionStore }, Cmd msg )
toggleState model prefix id transitionStartMsg transitionEndMsg transitionDuration =
    toggleState_ model prefix id transitionStartMsg transitionEndMsg transitionDuration False


toggleStateSelfish : { a | transitionStore : TransitionStore } -> IdPrefix -> b -> msg -> msg -> Time -> ( { a | transitionStore : TransitionStore }, Cmd msg )
toggleStateSelfish model prefix id transitionStartMsg transitionEndMsg transitionDuration =
    toggleState_ model prefix id transitionStartMsg transitionEndMsg transitionDuration True


toggleState_ : { a | transitionStore : TransitionStore } -> IdPrefix -> b -> msg -> msg -> Time -> Bool -> ( { a | transitionStore : TransitionStore }, Cmd msg )
toggleState_ model prefix id transitionStartMsg transitionEndMsg transitionDuration selfish =
    let
        transitionManagerId =
            toTransitionManagerId prefix id
    in
    if isOpen model.transitionStore transitionManagerId then
        ( { model | transitionStore = triggerClosing transitionManagerId model.transitionStore }, delay transitionDuration transitionEndMsg )
    else
        let
            updatedTransitionStore =
                if selfish then
                    model.transitionStore |> prepareOpening transitionManagerId
                else
                    model.transitionStore |> closeAll prefix |> prepareOpening transitionManagerId
        in
        ( { model | transitionStore = updatedTransitionStore }, Cmd.batch [ delay 10 transitionStartMsg, delay transitionDuration transitionEndMsg ] )


transitionEnd : { a | transitionStore : TransitionStore } -> ( { a | transitionStore : TransitionStore }, Cmd msg )
transitionEnd model =
    ( { model | transitionStore = hideClosing model.transitionStore }, Cmd.none )


transitionStart : { a | transitionStore : TransitionStore } -> ( { a | transitionStore : TransitionStore }, Cmd msg )
transitionStart model =
    ( { model | transitionStore = open model.transitionStore }, Cmd.none )


toTransitionManagerId : String -> a -> Id
toTransitionManagerId prefix a =
    prefix ++ toString a


isOpen : TransitionStore -> Id -> Bool
isOpen (T transitionStore) id =
    transitionStore |> List.member ( id, Open )


triggerClosing : Id -> TransitionStore -> TransitionStore
triggerClosing id transitionStore =
    setElementState transitionStore id Open Closing


hideClosing : TransitionStore -> TransitionStore
hideClosing (T transitionStore) =
    transitionStore
        |> List.filter
            (\elementState ->
                let
                    ( id, state ) =
                        elementState
                in
                state /= Closing
            )
        |> T


prepareOpening : Id -> TransitionStore -> TransitionStore
prepareOpening id (T transitionStore) =
    let
        elementState =
            transitionStore
                |> List.filter
                    (\elementState ->
                        let
                            ( elId, state ) =
                                elementState
                        in
                        elId == id
                    )
                |> List.head
    in
    case elementState of
        Nothing ->
            transitionStore
                ++ [ ( id, Opening ) ]
                |> T

        Just ( id, state ) ->
            setElementState (T transitionStore) id Hidden Opening


open : TransitionStore -> TransitionStore
open (T transitionStore) =
    transitionStore
        |> List.map
            (\elementState ->
                let
                    ( id, state ) =
                        elementState
                in
                if state == Opening then
                    ( id, Open )
                else
                    elementState
            )
        |> T


closeAll : String -> TransitionStore -> TransitionStore
closeAll idMatch (T transitionStore) =
    transitionStore
        |> List.map
            (\elementState ->
                let
                    ( id, state ) =
                        elementState
                in
                if String.contains idMatch id && state == Open then
                    ( id, Closing )
                else
                    elementState
            )
        |> T


setElementState : TransitionStore -> Id -> TransitionState -> TransitionState -> TransitionStore
setElementState (T transitionStore) id oldState newState =
    transitionStore
        |> List.map
            (\elementState ->
                let
                    ( elementId, state ) =
                        elementState
                in
                if elementId == id && state == oldState then
                    ( elementId, newState )
                else
                    elementState
            )
        |> T


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


manageTransitionClass : TransitionStore -> Id -> String
manageTransitionClass (T transitionStore) id =
    let
        elementState =
            transitionStore
                |> List.filter (\elementState -> Tuple.first elementState == id)
                |> List.head
    in
    case elementState of
        Nothing ->
            ""

        Just ( id, status ) ->
            if status == Open then
                " is-visible is-open"
            else if status == Closing || status == Opening then
                " is-visible"
            else
                ""


getTransitionState : TransitionStore -> Id -> TransitionState
getTransitionState (T transitionStore) id =
    let
        elementState =
            transitionStore
                |> List.filter (\elementState -> Tuple.first elementState == id)
                |> List.head
    in
    case elementState of
        Nothing ->
            Hidden

        Just ( id, status ) ->
            status


isSomethingOpen : TransitionStore -> String -> Bool
isSomethingOpen (T transitionStore) partialId =
    transitionStore
        |> List.filter (\elementState -> let (id, state) = elementState in String.contains partialId id && state == Open)
        |> List.isEmpty
        |> not


isTransitionOver : TransitionStore -> Id -> Bool
isTransitionOver (T transitionStore) id =
    transitionStore
        |> List.filter (\elementStore -> elementStore == ( id, Closing ) || elementStore == ( id, Opening ))
        |> List.isEmpty
