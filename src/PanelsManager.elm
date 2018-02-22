module PanelsManager exposing (PanelsState, initialPanelsState, closeAllPanels, closePanel, getPanelState, openPanel)


type PanelsState
    = PanelsState (List PanelState)

type alias PanelState =
    (PanelId, PanelOpen, PanelClosed)

type alias PanelOpen =
    Bool

type alias PanelClosed =
    Bool


type alias PanelId =
    String

initialPanelsState : PanelsState 
initialPanelsState =
    PanelsState []
    

getPanelState : PanelId -> PanelsState -> (PanelOpen, PanelClosed)
getPanelState panelId panelsState =
    case panelsState of
        PanelsState states ->
            let
                panelState = states |> List.filter (\state -> let (id, open, closed) = state in panelId == id) |> List.head
            in
            case panelState of
                Just (id, open, closed) ->
                    (open, closed)
                
                Nothing ->
                    (False, False)


closePanel : PanelId -> PanelsState -> PanelsState
closePanel panelId panelsState =
    case panelsState of
        PanelsState states ->
            states
                |> List.map (\state -> 
                    let 
                        (id, open, closed) = state 
                    in 
                    if 
                        panelId == id
                    then 
                        (panelId, False, True)
                    else
                        (id, open, closed)
                    )
                |> PanelsState


openPanel : PanelId -> PanelsState -> PanelsState
openPanel panelId panelsState =
    case panelsState of
        PanelsState states ->
            states 
                |> List.filter (\state -> let (id, open, closed) = state in panelId /= id)
                |> List.append [ (panelId, True, False) ]
                |> PanelsState


closeAllPanels : PanelsState -> PanelsState
closeAllPanels panelsState =
    case panelsState of
        PanelsState states ->
            states
                |> List.map (\state -> let (id, open, closed) = state in (id, False, True))
                |> PanelsState
