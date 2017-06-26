module Type exposing (..)

import Time exposing (..)


type alias Game =
    { title : String
    , windowSize : ( Int, Int )
    , state : StateModel
    , player : Box
    , health : Int
    , bossHealth : Int
    , enemyTouch : Bool
    , stage : List Box
    , stageLeft : Int
    , bossStage : List Box
    , bossBulletTimer : Int
    , enemyList : List Box
    , enemyRange : Int
    , direction : ( Int, Int )
    , isJump : Bool
    , keyPressed : Key
    , keyReleased : Key
    , isShooting : Bool
    , bulletList : List Box
    , flash : Bool
    }


init : Game
init =
    { title = "hello world"
    , windowSize = ( 600, 600 )
    , state = Menu
    , player = initPlayerBox
    , health = 5
    , bossHealth = 5
    , enemyTouch = False
    , isJump = True
    , stageLeft = 0
    , stage = initStageBoxList
    , bossStage = initBossStage
    , bossBulletTimer = bossBulletTimerValue
    , enemyList = enemyList
    , enemyRange = 0
    , direction = ( 0, 0 )
    , keyPressed = NoKey
    , keyReleased = NoKey
    , isShooting = False
    , bulletList = bulletList
    , flash = False
    }


type alias Box =
    { size : ( Int, Int )
    , position : ( Int, Int )
    , color : String
    , v : ( Float, Float )
    , range : Int
    , direction : Int
    }



-- type alias EnemyBox =
--     { size : ( Int, Int )
--     , position : ( Int, Int )
--     , color : String
--     , enemyType : EnemyType
--     }


type StateModel
    = Menu
    | Playing
    | Pause
    | Dead
    | Victory
    | Boss


type EnemyType
    = Still
    | Moving



-- Use for finding the edge of box coz of position is in the middle


type PositionModel
    = Top
    | Bottom
    | Left
    | Right


initPlayerBox : Box
initPlayerBox =
    { size =
        ( 30, 30 )
        -- default 100, 400
        -- , position =
        --     ( 2700, 400 )
    , position = ( 100, 400 )
    , color = "#ff00ff"
    , v = ( 0, 0 )
    , range = 0
    , direction = 1
    }


emptyStageBox : Box
emptyStageBox =
    { size = ( 0, 0 )
    , position = ( 0, 0 )
    , color = "black"
    , v = ( 0, 0 )
    , range = 0
    , direction = 1
    }


initBossStage =
    [ { size = ( 100, 30 )
      , position = ( 150, 15 )
      , color = "limegreen"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    ]


initStageBoxList : List Box
initStageBoxList =
    [ { size = ( 300, 30 )
      , position = ( 150, 15 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 300, 30 )
      , position = ( 420, 105 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 195, 45 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 240, 75 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 300, 30 )
      , position = ( 745, 135 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 300, 30 )
      , position = ( 1150, 135 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 1360, 135 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 1390, 165 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 1420, 195 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 100, 30 )
      , position = ( 1540, 225 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 300, 30 )
      , position = ( 1800, 195 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 1965, 240 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 2080, 240 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 2200, 240 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 30, 30 )
      , position = ( 2320, 100 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 600, 30 )
      , position = ( 2700, 100 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    ]


enemyList : List Box
enemyList =
    [ { size = ( 10, 30 )
      , position = ( 350, 135 )
      , color = "yellow"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 10, 30 )
      , position = ( 550, 165 )
      , color = "yellow"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 10, 30 )
      , position = ( 800, 165 )
      , color = "yellow"
      , v = ( 0, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 10, 30 )
      , position = ( 950, 195 )
      , color = "orange"
      , v = ( 1, 0 )
      , range = 0
      , direction = 1
      }
    , { size = ( 10, 30 )
      , position = ( 800, 165 )
      , color = "orange"
      , v = ( 1, 0 )
      , range = 0
      , direction = -1
      }
    , { size = ( 10, 30 )
      , position = ( 500, 135 )
      , color = "orange"
      , v = ( 1, 0 )
      , range = 0
      , direction = 1
      }
    ]


bossEnemyList =
    [ { size = ( 10, 100 )
      , position = ( 550, 100 )
      , color = "yellow"
      , v = ( 2, 0 )
      , range = 0
      , direction = 1
      }
    ]


emptyBossBullet =
    { size = ( 20, 20 )
    , position = ( 550, 40 )
    , color = "yellow"
    , v = ( 3, 0 )
    , range = 0
    , direction = 1
    }


bossBulletTimerValue =
    30


bulletList =
    []


type Key
    = NoKey
    | LeftKey
    | RightKey
    | UpKey
    | DownKey


type Msg
    = NoOp
    | Tick Time
    | KeyPressed Key
    | KeyReleased Key
    | ChangeState StateModel
    | ShootBullet
    | Restart
