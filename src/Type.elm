module Type exposing (..)

import Time exposing (..)


type alias Game =
    { title : String
    , windowSize : ( Int, Int )
    , state : StateModel
    , player : Box
    , health : Int
    , enemyTouch : Bool
    , stage : List Box
    , enemyList : List Box
    , direction : ( Int, Int )
    , isJump : Bool
    , stageLeft : Int
    , keyPressed : Key
    , keyReleased : Key
    }


init : Game
init =
    { title = "hello world"
    , windowSize = ( 600, 600 )
    , state = Playing
    , player = initPlayerBox
    , health = 3
    , enemyTouch = False
    , isJump = True
    , stageLeft = 0
    , stage = initStageBoxList
    , enemyList = enemyList
    , direction = ( 0, 0 )
    , keyPressed = NoKey
    , keyReleased = NoKey
    }


type alias Box =
    { size : ( Int, Int )
    , position : ( Int, Int )
    , color : String
    , v : ( Float, Float )
    }


type StateModel
    = Menu
    | Playing
    | Pause
    | Dead



-- Use for finding the edge of box coz of position is in the middle


type PositionModel
    = Top
    | Bottom
    | Left
    | Right


initPlayerBox : Box
initPlayerBox =
    { size = ( 30, 30 )
    , position = ( 100, 400 )
    , color = "#ff00ff"
    , v = ( 0, 0 )
    }


emptyStageBox : Box
emptyStageBox =
    { size = ( 0, 0 )
    , position = ( 0, 0 )
    , color = "black"
    , v = ( 0, 0 )
    }


initStageBoxList : List Box
initStageBoxList =
    [ { size = ( 300, 30 )
      , position = ( 150, 15 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      }
    , { size = ( 300, 30 )
      , position = ( 420, 105 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 195, 45 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      }
      -- , { size = ( 30, 30 )
      --   , position = ( 100, 45 )
      --   , color = "#0095ff"
      --   , v = ( 0, 0 )
      --   }
    , { size = ( 30, 30 )
      , position = ( 240, 75 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      }
    , { size = ( 300, 30 )
      , position = ( 745, 135 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      }
    , { size = ( 300, 30 )
      , position = ( 1150, 135 )
      , color = "#0095ff"
      , v = ( 0, 0 )
      }
    ]


enemyList =
    [ { size = ( 10, 30 )
      , position = ( 350, 135 )
      , color = "yellow"
      , v = ( 0, 0 )
      }
    , { size = ( 10, 30 )
      , position = ( 550, 165 )
      , color = "yellow"
      , v = ( 0, 0 )
      }
    , { size = ( 10, 30 )
      , position = ( 800, 165 )
      , color = "yellow"
      , v = ( 0, 0 )
      }
    ]


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
    | Restart
