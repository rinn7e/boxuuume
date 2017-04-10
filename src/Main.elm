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

        _ ->
            ( game, Cmd.none )


subscriptions : Game -> Sub Msg
subscriptions game =
    Sub.batch [ keyPressedBind, keyReleasedBind, tick ]
