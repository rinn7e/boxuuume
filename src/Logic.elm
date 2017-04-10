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
    ( game |> motion |> collisionVertical |> collisionHorizontal, Cmd.none )



-- gravity : Game -> Game
-- gravity game =
--     let
--         ( vx, vy ) =
--             game.player.v
--
--         ( vx2, vy2 ) =
--             if vy >= -4 then
--                 ( vx, vy - 1 )
--             else
--                 ( vx, -4 )
--
--         gamePlayer =
--             game.player
--     in
--         { game | player = { gamePlayer | v = ( vx2, vy2 ) } }


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


collisionVertical : Game -> Game
collisionVertical game =
    let
        ( vx, vy ) =
            game.player.v

        ( x, y ) =
            game.player.position

        playerLeft =
            findPos Left game.player

        playerRight =
            findPos Right game.player

        playerBottom =
            findPos Bottom game.player

        boxBelowPlayerList =
            game.stage
                |> List.filter (isBoxBelowPlayer playerLeft playerRight)

        boxTouchPlayer =
            boxBelowPlayerList |> List.filter (isBoxTouchPlayer playerBottom)

        debugBoxTouchPlayer =
            Debug.log "boxTouchPlayer" boxTouchPlayer

        ( vx2, vy2, newPoxY, jumpStatus ) =
            if List.length boxTouchPlayer == 0 then
                -- GRAVITY
                if vy >= -4 then
                    ( vx, vy - 1, y, True )
                else
                    ( vx, -4, y, True )
            else
                let
                    box =
                        List.head boxTouchPlayer
                            |> Maybe.withDefault Type.emptyStageBox

                    boxPosY =
                        Tuple.second box.position

                    boxHeight =
                        Tuple.second box.size
                in
                    ( vx, 0, boxPosY + boxHeight, False )

        gamePlayer =
            game.player
    in
        { game
            | player =
                { gamePlayer
                    | v = ( vx2, vy2 )
                    , position = ( x, newPoxY )
                }
            , isJump = jumpStatus
        }


collisionHorizontal game =
    game



-------------------------------------------------


keyPressedUpdate : Game -> Key -> ( Game, Cmd msg )
keyPressedUpdate game key =
    let
        ( vx, vy ) =
            game.player.v

        ( vx2, vy2 ) =
            case key of
                LeftKey ->
                    ( -4, vy )

                RightKey ->
                    ( 4, vy )

                UpKey ->
                    if game.isJump then
                        ( vx, vy )
                    else
                        ( vx, 10 )

                DownKey ->
                    ( vx, vy )

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



-- ( game, Cmd.none )
----------------------------------
-- helper function
-----------------------------


findPos : PositionModel -> Box -> Int
findPos positionType box =
    let
        ( coordinateX, coordinateY ) =
            box.position

        ( width, height ) =
            box.size
    in
        case positionType of
            Left ->
                coordinateX - (round ((toFloat width) / 2))

            Right ->
                coordinateX + (round ((toFloat width) / 2))

            Top ->
                coordinateY + (round ((toFloat height) / 2))

            Bottom ->
                coordinateY - (round ((toFloat height) / 2))


isBoxBelowPlayer : Int -> Int -> Box -> Bool
isBoxBelowPlayer playerLeft playerRight box =
    let
        boxLeft =
            findPos Left box

        boxRight =
            findPos Right box
    in
        (boxLeft <= playerLeft && playerLeft <= boxRight)
            || (boxLeft <= playerRight && playerRight <= boxRight)


isBoxTouchPlayer : Int -> Box -> Bool
isBoxTouchPlayer playerBottom box =
    let
        boxTop =
            findPos Top box
    in
        (playerBottom - boxTop) <= 0 && (playerBottom - boxTop) >= -5



--prevent from edge shrinking
