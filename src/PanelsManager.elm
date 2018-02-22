module PanelsManager exposing (PanelsOpen, closeAllPanels, closePanel, isPanelOpen, openPanel, initialPanelsOpen)


type PanelsOpen
    = PanelsOpen PanelsInited (List PanelId)


type alias PanelsInited =
    Bool


type alias PanelId =
    String

initialPanelsOpen : PanelsOpen
initialPanelsOpen = 
    PanelsOpen False []


isPanelOpen : PanelId -> PanelsOpen -> (Bool, Bool)
isPanelOpen panelId panelsOpen =
    case panelsOpen of
        PanelsOpen panelsInited panels ->
            (panelsInited, panels |> List.member panelId)


closePanel : PanelId -> PanelsOpen -> PanelsOpen
closePanel panelId panelsOpen =
    case panelsOpen of
        PanelsOpen panelsInited panels ->
            PanelsOpen True (panels |> List.filter (\panel -> panel /= panelId))


openPanel : PanelId -> PanelsOpen -> PanelsOpen
openPanel panelId panelsOpen =
    case panelsOpen of
        PanelsOpen panelsInited panels ->
            PanelsOpen True (panels |> List.append [ panelId ])


closeAllPanels : PanelsOpen
closeAllPanels =
    PanelsOpen True []
