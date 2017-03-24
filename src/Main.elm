module Main exposing (..)

import Html exposing (..)
import Type exposing (..)
import Render exposing (..)
import Logic exposing (..)


main : Program Never Game Msg
main =
    Html.program
        { init = ( game, Cmd.none )
        , update = update
        , view = render
        , subscriptions = subscriptions
        }


update : Msg -> Game -> ( Game, Cmd Msg )
update msg game =
    case msg of
        Tick time ->
            gameUpdate game

        KeyPressed key ->
            keyPressedUpdate game key

        --
        KeyReleased key ->
            keyReleasedUpdate game key

        --     let
        --         ( x, y ) =
        --             model.direction
        --
        --         keyPressed =
        --             model.keyPressed
        --
        --         direction_ =
        --             case key of
        --                 LeftKey ->
        --                     if keyPressed == RightKey then
        --                         ( x, y )
        --                     else
        --                         ( 0, y )
        --
        --                 RightKey ->
        --                     if keyPressed == LeftKey then
        --                         ( x, y )
        --                     else
        --                         ( 0, y )
        --
        --                 UpKey ->
        --                     if keyPressed == DownKey then
        --                         ( x, y )
        --                     else
        --                         ( x, 0 )
        --
        --                 DownKey ->
        --                     if keyPressed == UpKey then
        --                         ( x, y )
        --                     else
        --                         ( x, 0 )
        --
        --                 _ ->
        --                     ( 0, 0 )
        --     in
        --         ( { model | direction = direction_ }, Cmd.none )
        _ ->
            ( game, Cmd.none )



-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     Sub.none


subscriptions : Game -> Sub Msg
subscriptions game =
    Sub.batch [ keyPressedBind, keyReleasedBind, tick ]
