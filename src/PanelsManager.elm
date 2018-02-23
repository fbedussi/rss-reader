module PanelsManager exposing (PanelsState, closeAllPanels, closePanel, getPanelClass, getPanelState, initialPanelsState, isPanelClosed, isPanelHidden, isPanelOpen, openPanel, isSomePanelOpen)


type PanelsState
    = PanelsState (List PanelStateContainer)


type alias PanelStateContainer =
    ( PanelId, PanelState )


type alias PanelId =
    String


type PanelState
    = Hidden
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
                    Hidden


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
                |> List.append [ ( panelId, Open ) ]
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
getPanelClass hiddenClass openClass closedClass panelState =
    if panelState == Open then
        " " ++ openClass ++ " "
    else if panelState == Closed then
        " " ++ closedClass ++ " "
    else
        " " ++ hiddenClass ++ " "


isPanelOpen : PanelState -> Bool
isPanelOpen panelState =
    panelState == Open


isPanelClosed : PanelState -> Bool
isPanelClosed panelState =
    panelState == Closed


isPanelHidden : PanelState -> Bool
isPanelHidden panelState =
    panelState == Hidden


isSomePanelOpen : String -> PanelsState -> Bool
isSomePanelOpen panelId panelsState =
    case panelsState of
            PanelsState stateWrappers ->
                stateWrappers
                    |> List.filter (\stateWrapper -> let (id, state) = stateWrapper in state == Open && (String.contains panelId id))
                    |> List.isEmpty
                    |> not