module Logic exposing (..)

import Type exposing (..)
import Time exposing (..)
import Keyboard exposing (..)


-- Subscriptions Listen in background


tick : Sub Msg
tick =
    Time.every ((1000 / 60) * Time.millisecond) Tick


keyPressedBind : Sub Msg
keyPressedBind =
    Keyboard.downs keyPressed


keyReleasedBind : Sub Msg
keyReleasedBind =
    Keyboard.ups keyReleased


keyPressed : Keyboard.KeyCode -> Msg
keyPressed code =
    case code of
        37 ->
            KeyPressed LeftKey

        38 ->
            KeyPressed UpKey

        39 ->
            KeyPressed RightKey

        40 ->
            KeyPressed DownKey

        default ->
            KeyPressed NoKey


keyReleased : Keyboard.KeyCode -> Msg
keyReleased code =
    case code of
        37 ->
            KeyReleased LeftKey

        38 ->
            KeyReleased UpKey

        39 ->
            KeyReleased RightKey

        40 ->
            KeyReleased DownKey

        default ->
            KeyReleased NoKey



-- Update


gameUpdate : Game -> ( Game, Cmd msg )
gameUpdate game =
    ( game |> motion |> collision, Cmd.none )


gravity : Game -> Game
gravity game =
    let
        ( vx, vy ) =
            game.player.v

        ( vx2, vy2 ) =
            if vy >= -4 then
                ( vx, vy - 1 )
            else
                ( vx, -4 )

        gamePlayer =
            game.player
    in
        { game | player = { gamePlayer | v = ( vx2, vy2 ) } }


motion : Game -> Game
motion game =
    let
        ( x, y ) =
            game.player.position

        ( vx, vy ) =
            game.player.v

        ( x2, y2 ) =
            ( x + (round vx), y + (round vy) )

        gamePlayer =
            game.player
    in
        { game | player = { gamePlayer | position = ( x2, y2 ) } }


collision : Game -> Game
collision game =
    let
        ( x, y ) =
            game.player.position

        ( vx, vy ) =
            game.player.v

        ( width, height ) =
            game.player.size

        xStart =
            x - (round ((toFloat width) / 2))

        xEnd =
            x + (round ((toFloat width) / 2))

        yStart =
            y - (round ((toFloat height) / 2))

        collisionListX =
            List.filter
                (\stageBox ->
                    let
                        ( xBox, yBox ) =
                            stageBox.position

                        ( widthBox, heightBox ) =
                            stageBox.size

                        start =
                            xBox - (round ((toFloat widthBox) / 2))

                        end =
                            xBox + (round ((toFloat widthBox) / 2))
                    in
                        ((xStart >= start && xStart <= end) || (xEnd >= start && xEnd <= end))
                )
                game.stage

        collisionListY =
            List.filter
                (\stageBox ->
                    let
                        ( xBox, yBox ) =
                            stageBox.position

                        ( widthBox, heightBox ) =
                            stageBox.size

                        start =
                            xBox - (round ((toFloat heightBox) / 2))

                        end =
                            yBox + (round ((toFloat heightBox) / 2))
                    in
                        (yStart - end) <= 0
                )
                collisionListX

        test =
            Debug.log "test" collisionListX

        test2 =
            Debug.log "test2" collisionListY

        ( vx2, vy2 ) =
            if List.length collisionListY == 0 then
                -- ( 0, vy )
                if vy >= -4 then
                    ( vx, vy - 1 )
                else
                    ( vx, -4 )
            else
                ( vx, 0 )

        gamePlayer =
            game.player
    in
        { game | player = { gamePlayer | v = ( vx2, vy2 ) } }



-------------------------------------------------


keyPressedUpdate : Game -> Key -> ( Game, Cmd msg )
keyPressedUpdate game key =
    let
        ( vx, vy ) =
            game.player.v

        ( vx2, vy2 ) =
            case key of
                LeftKey ->
                    ( -2, vy )

                RightKey ->
                    ( 2, vy )

                UpKey ->
                    ( vx, 2 )

                DownKey ->
                    ( vx, -2 )

                _ ->
                    ( 0, 0 )

        gamePlayer =
            game.player
    in
        ( { game | player = { gamePlayer | v = ( vx2, vy2 ) }, keyPressed = key }, Cmd.none )


keyReleasedUpdate : Game -> Key -> ( Game, Cmd msg )
keyReleasedUpdate game key =
    let
        ( vx, vy ) =
            game.player.v

        keyPressed =
            game.keyPressed

        ( vx2, vy2 ) =
            case key of
                LeftKey ->
                    if keyPressed == RightKey then
                        ( vx, vy )
                    else
                        ( 0, vy )

                RightKey ->
                    if keyPressed == LeftKey then
                        ( vx, vy )
                    else
                        ( 0, vy )

                UpKey ->
                    if keyPressed == DownKey then
                        ( vx, vy )
                    else
                        ( vx, 0 )

                DownKey ->
                    if keyPressed == UpKey then
                        ( vx, vy )
                    else
                        ( vx, 0 )

                _ ->
                    ( 0, 0 )

        gamePlayer =
            game.player
    in
        ( { game | player = { gamePlayer | v = ( vx2, vy2 ) } }, Cmd.none )



----------------------------------
-- helper function
-----------------------------
-- checkGravity model =
--     let
--         ( x, y ) =
--             model.player.position
--
--         ( width, height ) =
--             model.player.size
--
--         xStart =
--             x - (truncate ((toFloat width) / 2))
--
--         xEnd =
--             x + (truncate ((toFloat width) / 2))
--
--         yStart =
--             y - (truncate ((toFloat height) / 2))
--
--         gravity =
--             let
--                 collisionListX =
--                     List.filter
--                         (\stageBox ->
--                             let
--                                 ( xBox, yBox ) =
--                                     stageBox.position
--
--                                 ( widthBox, heightBox ) =
--                                     stageBox.size
--
--                                 start =
--                                     xBox - (truncate ((toFloat widthBox) / 2))
--
--                                 end =
--                                     xBox + (truncate ((toFloat widthBox) / 2))
--                             in
--                                 ((xStart >= start && xStart <= end) || (xEnd >= start && xEnd <= end))
--                         )
--                         model.stage
--
--                 collisionListY =
--                     List.filter
--                         (\stageBox ->
--                             let
--                                 ( xBox, yBox ) =
--                                     stageBox.position
--
--                                 ( widthBox, heightBox ) =
--                                     stageBox.size
--
--                                 start =
--                                     xBox - (truncate ((toFloat heightBox) / 2))
--
--                                 end =
--                                     yBox + (truncate ((toFloat heightBox) / 2))
--                             in
--                                 (yStart - end) == 0
--                         )
--                         collisionListX
--
--                 test =
--                     Debug.log "test" collisionListX
--
--                 test2 =
--                     Debug.log "test2" collisionListY
--             in
--                 if y /= (truncate ((toFloat height) / 2)) && List.length collisionListY == 0 then
--                     1
--                 else
--                     0
--
--         modelPlayer =
--             model.player
--
--         player_ =
--             { modelPlayer | position = ( x, y - gravity ) }
--     in
--         { model | player = player_ }
--
--
-- checkKey model =
--     let
--         ( x, y ) =
--             model.player.position
--
--         ( dx, dy ) =
--             model.direction
--
--         modelPlayer =
--             model.player
--
--         sp =
--             model.player.v
--
--         player_ =
--             { modelPlayer | position = ( x + dx * sp, y + dy * sp ) }
--     in
--         { model | player = player_ }
