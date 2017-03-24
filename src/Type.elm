module Type exposing (..)

import Time exposing (..)


type alias Game =
    { title : String
    , windowSize : ( Int, Int )
    , player : Box
    , stage : List Box
    , direction : ( Int, Int )
    , keyPressed : Key
    , keyReleased : Key
    }


game : Game
game =
    { title = "hello world"
    , windowSize = ( 600, 600 )
    , player = initPlayerBox
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


initPlayerBox : Box
initPlayerBox =
    { size = ( 30, 30 )
    , position = ( 300, 400 )
    , color = "red"
    , v = ( 0, 0 )
    }


initStageBoxList : List Box
initStageBoxList =
    [ { size = ( 30, 30 )
      , position = ( 15, 15 )
      , color = "blue"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 45, 15 )
      , color = "green"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 75, 15 )
      , color = "blue"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 105, 15 )
      , color = "green"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 135, 15 )
      , color = "blue"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 165, 15 )
      , color = "green"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 195, 15 )
      , color = "blue"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 225, 15 )
      , color = "green"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 255, 15 )
      , color = "blue"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 285, 15 )
      , color = "green"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 315, 15 )
      , color = "blue"
      , v = ( 0, 0 )
      }
    , { size = ( 30, 30 )
      , position = ( 195, 15 )
      , color = "blue"
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
