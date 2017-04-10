module Type exposing (..)

import Time exposing (..)


type alias Game =
    { title : String
    , windowSize : ( Int, Int )
    , player : Box
    , stage : List Box
    , direction : ( Int, Int )
    , isJump : Bool
    , keyPressed : Key
    , keyReleased : Key
    }


game : Game
game =
    { title = "hello world"
    , windowSize = ( 600, 600 )
    , player = initPlayerBox
    , isJump = True
    , stage = initStageBoxList
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
    , { size = ( 30, 30 )
      , position = ( 255, 75 )
      , color = "#0095ff"
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
