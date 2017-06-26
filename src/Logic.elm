module Logic exposing (..)

import Type exposing (..)
import Keyboard exposing (..)
import List.Extra as ListEx


-- Update


gameUpdate : Game -> ( Game, Cmd msg )
gameUpdate game =
    ( game
        |> motion
        |> enemyMotion
        |> bulletMotion
        |> bulletCollision
        |> collisionHorizontal
        |> collisionVertical
        |> enemyCollision
        |> victoryCheck
        |> bossMotion
        |> bossBullet
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


enemyMotion game =
    let
        enemyList =
            List.map
                (\enemy ->
                    let
                        ( x, y ) =
                            enemy.position

                        ( vx, vy ) =
                            enemy.v

                        ( newX, newRange, newDirection ) =
                            if vx == 1 then
                                if enemy.direction == 1 then
                                    if enemy.range > 30 then
                                        ( x + 1, enemy.range + 1, -1 )
                                    else
                                        ( x + 1, enemy.range + 1, enemy.direction )
                                else
                                    (if enemy.range < -30 then
                                        ( x - 1, enemy.range - 1, 1 )
                                     else
                                        ( x - 1, enemy.range - 1, enemy.direction )
                                    )
                            else
                                ( x, enemy.range, enemy.direction )
                    in
                        { enemy | position = ( newX, y ), range = newRange, direction = newDirection }
                )
                game.enemyList

        newEnemyRange =
            game.enemyRange
    in
        { game | enemyList = enemyList }


bossMotion game =
    let
        enemyList =
            List.map
                (\enemy ->
                    let
                        ( x, y ) =
                            enemy.position

                        ( vx, vy ) =
                            enemy.v

                        ( newY, newRange, newDirection ) =
                            if vx == 2 then
                                if enemy.direction == 1 then
                                    if enemy.range > 20 then
                                        ( y + 5, enemy.range + 1, -1 )
                                    else
                                        ( y + 5, enemy.range + 1, enemy.direction )
                                else
                                    (if enemy.range < -20 then
                                        ( y - 5, enemy.range - 1, 1 )
                                     else
                                        ( y - 5, enemy.range - 1, enemy.direction )
                                    )
                            else
                                ( y, enemy.range, enemy.direction )
                    in
                        { enemy | position = ( x, newY ), range = newRange, direction = newDirection }
                )
                game.enemyList

        newEnemyRange =
            game.enemyRange
    in
        { game | enemyList = enemyList }


bulletMotion game =
    let
        bulletList =
            game.bulletList
                |> List.map
                    (\bullet ->
                        let
                            ( x, y ) =
                                bullet.position

                            ( vx, vy ) =
                                bullet.v

                            ( newX, newRange ) =
                                if bullet.range < 500 then
                                    ( x + 8, bullet.range + 8 )
                                else
                                    -- Remove
                                    ( x, bullet.range )
                        in
                            { bullet | position = ( newX, y ), range = newRange }
                    )
                |> List.filter
                    (\bullet ->
                        bullet.range < 500
                    )
    in
        { game | bulletList = bulletList }


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
                game.state

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


victoryCheck game =
    let
        ( x, y ) =
            game.player.position

        ( state, newX, newY, newStage, newEnemyList ) =
            if x > 2800 then
                (if game.state /= Boss then
                    ( Boss, 30, 400, initBossStage, bossEnemyList )
                 else
                    ( game.state, x, y, game.stage, game.enemyList )
                )
            else
                ( game.state, x, y, game.stage, game.enemyList )

        gamePlayer =
            game.player
    in
        { game
            | state = state
            , player = { gamePlayer | position = ( newX, newY ) }
            , stage = newStage
            , enemyList = newEnemyList
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

        ( enemyTouch, health, flash ) =
            if List.length boxTouchHorzPlayer == 0 then
                ( False, game.health, False )
            else
                let
                    ( newHealth, flash ) =
                        if game.enemyTouch == True then
                            ( game.health, False )
                        else
                            ( game.health - 1, True )
                in
                    ( True, newHealth, flash )

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
            , flash = flash
        }


bulletCollision : Game -> Game
bulletCollision game =
    let
        bullet =
            Maybe.withDefault emptyStageBox <| ListEx.last game.bulletList

        playerBottom =
            findPos Bottom bullet

        playerTop =
            findPos Top bullet

        playerLeft =
            findPos Left bullet

        playerRight =
            findPos Right bullet

        boxBetweenPlayerList =
            game.enemyList
                |> List.filter (isBoxBetweenPlayer playerTop playerBottom)

        boxTouchHorzPlayer =
            boxBetweenPlayerList |> List.filter (isBoxTouchHorzPlayer playerLeft playerRight)

        bulletList =
            if List.length boxTouchHorzPlayer == 0 then
                game.bulletList
            else
                game.bulletList
                    |> List.take (List.length game.bulletList - 1)

        enemyList =
            game.enemyList
                |> List.filter
                    (\enemy ->
                        let
                            ( vx, vy ) =
                                enemy.v
                        in
                            if vx == 1 then
                                not (List.member enemy boxTouchHorzPlayer)
                            else
                                True
                    )

        minus =
            game.enemyList
                |> List.filter
                    (\enemy ->
                        let
                            ( vx, vy ) =
                                enemy.v
                        in
                            if vx == 2 && (List.member enemy boxTouchHorzPlayer) then
                                True
                            else
                                False
                    )
                |> List.length

        newBossHealth =
            game.bossHealth - minus

        newState =
            if newBossHealth == 0 then
                Victory
            else
                game.state
    in
        { game
            | enemyList = enemyList
            , bulletList = bulletList
            , bossHealth = newBossHealth
            , state = newState
        }


bossBullet : Game -> Game
bossBullet game =
    let
        ( newEnemyList, newBulletTimer ) =
            case game.state of
                Boss ->
                    let
                        bulletTimer =
                            if game.bossBulletTimer == 0 then
                                bossBulletTimerValue
                            else
                                game.bossBulletTimer - 1

                        enemyList =
                            game.enemyList
                                |> (\enemyList ->
                                        if game.bossBulletTimer == 0 then
                                            emptyBossBullet :: enemyList
                                        else
                                            enemyList
                                   )
                                |> List.map
                                    (\enemy ->
                                        let
                                            ( x, y ) =
                                                enemy.position

                                            ( vx, vy ) =
                                                enemy.v

                                            ( newX, newRange ) =
                                                if vx == 3 then
                                                    ( x - 5, enemy.range )
                                                else
                                                    ( x, enemy.range )
                                        in
                                            { enemy | position = ( newX, y ), range = newRange }
                                    )
                                |> List.filter (\enemy -> (Tuple.first enemy.position) > 70)
                    in
                        ( enemyList, bulletTimer )

                _ ->
                    ( game.enemyList, game.bossBulletTimer )

        newEnemyRange =
            game.enemyRange
    in
        { game | enemyList = newEnemyList, bossBulletTimer = newBulletTimer }



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
