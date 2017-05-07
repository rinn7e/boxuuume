module Logic exposing (..)

import Type exposing (..)
import Keyboard exposing (..)


-- Update


gameUpdate : Game -> ( Game, Cmd msg )
gameUpdate game =
    ( game
        |> motion
        |> collisionHorizontal
        |> collisionVertical
        |> enemyCollision
    , Cmd.none
    )


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

        newStageLeft =
            if (-x2 + 100) >= 0 then
                game.stageLeft
            else
                -x2 + 100
    in
        { game | player = { gamePlayer | position = ( x2, y2 ) }, stageLeft = newStageLeft }


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
            boxBelowPlayerList |> List.filter (isBoxTouchVertPlayer playerBottom)

        debugBoxTouchPlayer =
            Debug.log "boxTouchPlayer" boxTouchPlayer

        ( vx2, vy2, newPosY, jumpStatus ) =
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

        _ =
            Debug.log "Debug:" y

        gameState =
            if y < 0 then
                Dead
            else
                Playing

        -- _ =
        --     Debug.log "Debug:" state
        gamePlayer =
            game.player
    in
        { game
            | player =
                { gamePlayer
                    | v = ( vx2, vy2 )
                    , position = ( x, newPosY )
                }
            , isJump = jumpStatus
            , state = gameState
        }


collisionHorizontal game =
    let
        ( vx, vy ) =
            game.player.v

        ( x, y ) =
            game.player.position

        ( width, height ) =
            game.player.size

        playerBottom =
            findPos Bottom game.player

        playerTop =
            findPos Top game.player

        playerLeft =
            findPos Left game.player

        playerRight =
            findPos Right game.player

        boxBetweenPlayerList =
            game.stage
                |> List.filter (isBoxBetweenPlayer playerTop playerBottom)

        _ =
            Debug.log "boxBetweenPlayer" boxBetweenPlayerList

        boxTouchHorzPlayer =
            boxBetweenPlayerList |> List.filter (isBoxTouchHorzPlayer playerLeft playerRight)

        _ =
            Debug.log "boxTouchHorzPlayer" boxTouchHorzPlayer

        ( vx2, newPosX ) =
            if List.length boxTouchHorzPlayer == 0 then
                ( vx, x )
            else
                let
                    box =
                        List.head boxTouchHorzPlayer
                            |> Maybe.withDefault Type.emptyStageBox

                    boxPosX =
                        Tuple.first box.position

                    boxWidth =
                        Tuple.first box.size
                in
                    ( vx
                    , round
                        (((toFloat boxPosX) - ((toFloat boxWidth) / 2))
                            - (toFloat width / 2)
                        )
                        - 1
                    )

        gamePlayer =
            game.player
    in
        { game
            | player =
                { gamePlayer
                    | v = ( vx2, vy )
                    , position = ( newPosX, y )
                }
        }



-- game
-- { game
--     | player =
--         { gamePlayer
--             | v = ( vx2, vy )
--             , position = ( newPosX, y )
--         }
-- }
-- ( game, Cmd.none )


enemyCollision : Game -> Game
enemyCollision game =
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

        playerTop =
            findPos Top game.player

        boxBetweenPlayerList =
            game.enemyList
                |> List.filter (isBoxBetweenPlayer playerTop playerBottom)

        boxTouchHorzPlayer =
            boxBetweenPlayerList |> List.filter (isBoxTouchHorzPlayer playerLeft playerRight)

        ( enemyTouch, health ) =
            if List.length boxTouchHorzPlayer == 0 then
                ( False, game.health )
            else
                let
                    newHealth =
                        if game.enemyTouch == True then
                            game.health
                        else
                            game.health - 1
                in
                    ( True, newHealth )

        gameState =
            if health <= 0 then
                Dead
            else
                game.state

        gamePlayer =
            game.player
    in
        { game
            | health = health
            , state = gameState
            , enemyTouch = enemyTouch
        }



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


isBoxTouchVertPlayer : Int -> Box -> Bool
isBoxTouchVertPlayer playerBottom box =
    let
        boxTop =
            findPos Top box
    in
        (playerBottom - boxTop) <= 0 && (playerBottom - boxTop) >= -5


isBoxBetweenPlayer : Int -> Int -> Box -> Bool
isBoxBetweenPlayer playerTop playerBottom box =
    let
        boxTop =
            findPos Top box

        boxBottom =
            findPos Bottom box
    in
        (boxBottom < playerTop && playerTop <= boxTop)
            || (boxBottom <= playerBottom && playerBottom < boxTop)


isBoxTouchHorzPlayer : Int -> Int -> Box -> Bool
isBoxTouchHorzPlayer playerLeft playerRight box =
    let
        boxLeft =
            findPos Left box

        boxRight =
            findPos Right box
    in
        (0 <= (playerRight - boxLeft) && (playerRight - boxLeft) <= 15)



-- || (0 >= (boxRight - playerLeft) && (boxRight - playerLeft) <= 15)
-- || ((playerLeft - boxRight) <= 0)
--prevent from edge shrinking
