module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Keyboard
import Time exposing (..)


main =
    Html.program
        { init = ( model, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { title : String
    , size : ( Int, Int )
    , player : Box
    , stage : List Box
    , direction : ( Int, Int )
    , keyPressed : Key
    , keyReleased : Key
    }


model : Model
model =
    { title = "hello world"
    , size = ( 600, 600 )
    , player = { size = ( 30, 30 ), position = ( 300, 400 ), color = "red", v = -1 }
    , stage = [ { size = ( 30, 30 ), position = ( 15, 45 ), color = "blue", v = 0 }, { size = ( 30, 30 ), v = 0, position = ( 300, 45 ), color = "blue" } ]
    , direction = ( 0, 0 )
    , keyPressed = NoKey
    , keyReleased = NoKey
    }


type alias Box =
    { size : ( Int, Int )
    , position : ( Int, Int )
    , color :
        String
    , v : Float
    }


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            -- ( model
            --     |> checkGravity
            --     |> checkKey
            -- , Cmd.none
            -- )
            ( model |> checkKey
            , Cmd.none
            )

        KeyPressed key ->
            let
                ( x, y ) =
                    model.direction

                direction_ =
                    case key of
                        LeftKey ->
                            ( -1, y )

                        RightKey ->
                            ( 1, y )

                        UpKey ->
                            ( x, 1 )

                        DownKey ->
                            ( x, -1 )

                        _ ->
                            ( 0, 0 )
            in
                ( { model | direction = direction_, keyPressed = key }, Cmd.none )

        KeyReleased key ->
            let
                ( x, y ) =
                    model.direction

                keyPressed =
                    model.keyPressed

                direction_ =
                    case key of
                        LeftKey ->
                            if keyPressed == RightKey then
                                ( x, y )
                            else
                                ( 0, y )

                        RightKey ->
                            if keyPressed == LeftKey then
                                ( x, y )
                            else
                                ( 0, y )

                        UpKey ->
                            if keyPressed == DownKey then
                                ( x, y )
                            else
                                ( x, 0 )

                        DownKey ->
                            if keyPressed == UpKey then
                                ( x, y )
                            else
                                ( x, 0 )

                        _ ->
                            ( 0, 0 )
            in
                ( { model | direction = direction_ }, Cmd.none )

        _ ->
            ( model, Cmd.none )


checkGravity model =
    let
        ( x, y ) =
            model.player.position

        ( width, height ) =
            model.player.size

        xStart =
            x - (truncate ((toFloat width) / 2))

        xEnd =
            x + (truncate ((toFloat width) / 2))

        yStart =
            y - (truncate ((toFloat height) / 2))

        gravity =
            let
                collisionListX =
                    List.filter
                        (\stageBox ->
                            let
                                ( xBox, yBox ) =
                                    stageBox.position

                                ( widthBox, heightBox ) =
                                    stageBox.size

                                start =
                                    xBox - (truncate ((toFloat widthBox) / 2))

                                end =
                                    xBox + (truncate ((toFloat widthBox) / 2))
                            in
                                ((xStart >= start && xStart <= end) || (xEnd >= start && xEnd <= end))
                        )
                        model.stage

                collisionListY =
                    List.filter
                        (\stageBox ->
                            let
                                ( xBox, yBox ) =
                                    stageBox.position

                                ( widthBox, heightBox ) =
                                    stageBox.size

                                start =
                                    xBox - (truncate ((toFloat heightBox) / 2))

                                end =
                                    yBox + (truncate ((toFloat heightBox) / 2))
                            in
                                (yStart - end) == 0
                        )
                        collisionListX

                test =
                    Debug.log "test" collisionListX

                test2 =
                    Debug.log "test2" collisionListY
            in
                if y /= (truncate ((toFloat height) / 2)) && List.length collisionListY == 0 then
                    1
                else
                    0

        modelPlayer =
            model.player

        player_ =
            { modelPlayer | position = ( x, y - gravity ) }
    in
        { model | player = player_ }


checkKey model =
    let
        ( x, y ) =
            model.player.position

        ( dx, dy ) =
            model.direction

        modelPlayer =
            model.player

        sp =
            model.player.v

        player_ =
            { modelPlayer | position = ( x + dx * sp, y + dy * sp ) }
    in
        { model | player = player_ }


view model =
    let
        ( width, height ) =
            model.size
    in
        div
            [ style
                [ ( "backgroundColor", "purple" )
                , ( "position", "relative" )
                , ( "height", (toString height) ++ "px" )
                , ( "width", (toString width) ++ "px" )
                ]
            ]
            [ div [] (List.map boxView model.stage)
            , boxView model.player
            ]


boxView box =
    let
        ( x, y ) =
            box.position

        ( width, height ) =
            box.size

        -- ( width, height ) =
        --     size
    in
        div
            [ style
                [ ( "backgroundColor", box.color )
                , ( "position", "absolute" )
                , ( "height", (toString height) ++ "px" )
                , ( "width", (toString width) ++ "px" )
                , ( "bottom", (toString (y - (truncate ((toFloat height) / 2)))) ++ "px" )
                , ( "left", (toString (x - (truncate ((toFloat width) / 2)))) ++ "px" )
                ]
            ]
            []



-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     Sub.none


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ keyPressedBind, keyReleasedBind, tick ]


tick : Sub Msg
tick =
    Time.every ((1000 / 60) * Time.millisecond) Tick


keyPressedBind : Sub Msg
keyPressedBind =
    Keyboard.downs keyPressed


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
