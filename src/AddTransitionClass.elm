module AddTransitionClass exposing (addTransitionClass)

import Native.AddTransitionClass


addTransitionClass : String -> String
addTransitionClass =
    Native.AddTransitionClass.addTransitionClass



-- type MenuVisibility
--     = None
--     | OverrideNone
--     | DoTransition
-- type alias Model =
--     { menuVisibility : MenuVisibility }
-- changeMenuVisibility : MenuVisibility -> MenuVisibility
-- changeMenuVisibility menuVisibility =
--     case menuVisibility of
--         None ->
--             OverrideNone
--         OverrideNone ->
--             DoTransition
--         DoTransition ->
--             DoTransition
-- type Msg
--     = Tick Time
-- subscriptions model =
--     AnimationFrame.times Tick
-- update msg model =
--     case msg of
--         Tick _ ->
--             { model | menuVisibility = changeMenuVisibility model.menuVisibility }
-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     if model.menuVisibility == OverrideNone then
--         AnimationFrame.times Tick
--     else
--         Sub.none
