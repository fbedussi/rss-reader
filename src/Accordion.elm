module Accordion exposing (closeTab, openTab)

import Native.Accordion


openTab : String -> Bool
openTab domSelector =
    Native.Accordion.openTab domSelector


closeTab : String -> Bool
closeTab domSelector =
    Native.Accordion.closeTab domSelector
