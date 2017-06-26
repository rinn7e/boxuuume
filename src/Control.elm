module Control exposing (..)

import Keyboard exposing (..)
import Type exposing (..)


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

        80 ->
            ChangeState Pause

        32 ->
            ShootBullet

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


shootBullet game =
    let
        newBullet =
            { size = ( 10, 10 )
            , position = game.player.position
            , color = "lawngreen"
            , v = ( 0, 0 )
            , range = 0
            , direction = 1
            }

        newBulletList =
            newBullet :: game.bulletList
    in
        ({ game | bulletList = newBulletList })
