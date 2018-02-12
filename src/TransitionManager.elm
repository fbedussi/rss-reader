module TransitionManager exposing (WithTransitionStore, closeAll, delay, empty, hideClosing, isOpen, isTransitionOver, manageTransitionClass, open, prepareOpening, toTransitionManagerId, triggerClosing)

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


type alias TransitionStore =
    List ElementState


type alias WithTransitionStore model =
    { model | transitionStore : TransitionStore }


toTransitionManagerId : String -> a -> Id
toTransitionManagerId prefix a =
    prefix ++ toString a


empty : TransitionStore
empty =
    []


isOpen : TransitionStore -> Id -> Bool
isOpen transitionStore id =
    transitionStore |> List.member ( id, Open )


triggerClosing : Id -> TransitionStore -> TransitionStore
triggerClosing id transitionStore =
    setElementState transitionStore id Open Closing


hideClosing : TransitionStore -> TransitionStore
hideClosing transitionStore =
    transitionStore
        |> List.filter
            (\elementState ->
                let
                    ( id, state ) =
                        elementState
                in
                state /= Closing
            )


prepareOpening : Id -> TransitionStore -> TransitionStore
prepareOpening id transitionStore =
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
            transitionStore ++ [ ( id, Opening ) ]

        Just ( id, state ) ->
            setElementState transitionStore id Hidden Opening


open : TransitionStore -> TransitionStore
open transitionStore =
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


closeAll : TransitionStore -> TransitionStore
closeAll transitionStore =
    transitionStore
        |> List.map
            (\elementState ->
                let
                    ( id, state ) =
                        elementState
                in
                if state == Open then
                    ( id, Closing )
                else
                    elementState
            )


setElementState : TransitionStore -> Id -> TransitionState -> TransitionState -> TransitionStore
setElementState transitionStore id oldState newState =
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


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


manageTransitionClass : TransitionStore -> Id -> String
manageTransitionClass transitionStore id =
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


isTransitionOver : TransitionStore -> Id -> Bool
isTransitionOver transitionStore id =
    transitionStore |> List.filter (\elementStore -> elementStore == ( id, Closing ) || elementStore == ( id, Opening )) |> List.isEmpty
