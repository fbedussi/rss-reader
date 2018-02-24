module PanelsManager exposing (PanelsState, closeAllPanels, closePanel, getPanelClass, getPanelState, initialPanelsState, isPanelClosed, isPanelOpen, isPanleInitial, isSomePanelOpen, openPanel, initPanel)


type PanelsState
    = PanelsState (List PanelStateContainer)


type alias PanelStateContainer =
    ( PanelId, PanelState )


type alias PanelId =
    String


type PanelState
    = Initial
    | Open
    | Closed


initialPanelsState : PanelsState
initialPanelsState =
    PanelsState []


getPanelState : PanelId -> PanelsState -> PanelState
getPanelState panelId panelsState =
    case panelsState of
        PanelsState stateWrappers ->
            let
                panelState =
                    stateWrappers
                        |> List.filter
                            (\stateWrapper ->
                                let
                                    ( id, state ) =
                                        stateWrapper
                                in
                                panelId == id
                            )
                        |> List.head
            in
            case panelState of
                Just ( id, state ) ->
                    state

                Nothing ->
                    Initial


closePanel : PanelId -> PanelsState -> PanelsState
closePanel panelId panelsState =
    case panelsState of
        PanelsState stateWrappers ->
            stateWrappers
                |> List.map
                    (\stateWrapper ->
                        let
                            ( id, state ) =
                                stateWrapper
                        in
                        if panelId == id then
                            ( id, Closed )
                        else
                            ( id, state )
                    )
                |> PanelsState


openPanel : PanelId -> PanelsState -> PanelsState
openPanel panelId panelsState =
    initPanel_ panelId panelsState Open


initPanel : PanelId -> PanelsState -> PanelsState
initPanel panelId panelsState =
    initPanel_ panelId panelsState Initial


initPanel_ : PanelId -> PanelsState -> PanelState -> PanelsState
initPanel_ panelId panelsState panelState =
    case panelsState of
        PanelsState stateWrappers ->
            stateWrappers
                |> List.filter
                    (\stateWrapper ->
                        let
                            ( id, state ) =
                                stateWrapper
                        in
                        panelId /= id
                    )
                |> List.append [ ( panelId, panelState ) ]
                |> PanelsState


closeAllPanels : PanelsState -> PanelsState
closeAllPanels panelsState =
    case panelsState of
        PanelsState stateWrappers ->
            stateWrappers
                |> List.map
                    (\stateWrapper ->
                        let
                            ( id, state ) =
                                stateWrapper
                        in
                        ( id, Closed )
                    )
                |> PanelsState


getPanelClass : String -> String -> String -> PanelState -> String
getPanelClass initialClass openClass closedClass panelState =
    if panelState == Open then
        " " ++ openClass ++ " "
    else if panelState == Closed then
        " " ++ closedClass ++ " "
    else
        " " ++ initialClass ++ " "


isPanelOpen : PanelState -> Bool
isPanelOpen panelState =
    panelState == Open


isPanelClosed : PanelState -> Bool
isPanelClosed panelState =
    panelState == Closed


isPanleInitial : PanelState -> Bool
isPanleInitial panelState =
    panelState == Initial


isSomePanelOpen : String -> PanelsState -> Bool
isSomePanelOpen panelId panelsState =
    case panelsState of
        PanelsState stateWrappers ->
            stateWrappers
                |> List.filter
                    (\stateWrapper ->
                        let
                            ( id, state ) =
                                stateWrapper
                        in
                        state == Open && String.contains panelId id
                    )
                |> List.isEmpty
                |> not
