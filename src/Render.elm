module Render exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Type exposing (..)


render : Game -> Html Msg
render game =
    let
        ( width, height ) =
            game.windowSize
    in
        div
            [ style
                [ ( "backgroundColor", "purple" )
                , ( "position", "relative" )
                , ( "height", (toString height) ++ "px" )
                , ( "width", (toString width) ++ "px" )
                , ( "overflow", "hidden" )
                ]
            ]
            [ case game.state of
                Menu ->
                    menuView

                Playing ->
                    div
                        [ style
                            [ -- ( "backgroundColor", "purple" )
                              -- ,
                              ( "position", "relative" )
                            , ( "left", (toString game.stageLeft) ++ "px" )
                            , ( "height", (toString height) ++ "px" )
                            ]
                        ]
                        [ div [] ((List.map boxRender game.stage) ++ (List.map boxRender game.enemyList))
                        , boxRender game.player
                        , div [] (List.map healthBox (List.range 1 game.health))
                        ]

                Pause ->
                    div
                        [ style
                            [ ( "color", "white" )
                            , ( "position", "relative" )
                            , ( "left", "250px" )
                            , ( "height", "250px" )
                            ]
                        ]
                        [ h1 [] [ text "Pause" ]
                        , p [ onClick (ChangeState Playing) ] [ text "Resume" ]
                        , p [ onClick (Restart) ] [ text "Restart" ]
                        ]

                Dead ->
                    div
                        [ style
                            [ ( "color", "white" )
                            , ( "position", "relative" )
                            , ( "left", "250px" )
                            , ( "height", "250px" )
                            ]
                        ]
                        [ h1 [] [ text "Dead" ]
                        , p [ onClick (Restart) ] [ text "Restart" ]
                        ]
            ]


menuView : Html Msg
menuView =
    div
        [ style
            [ ( "color", "white" )
            , ( "position", "relative" )
            , ( "left", "250px" )
            , ( "height", "250px" )
            ]
        ]
        [ h1 [] [ text "Menu" ]
        , p [ onClick (ChangeState Playing) ] [ text "Play" ]
        ]


boxRender : Box -> Html msg
boxRender box =
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


healthBox amount =
    div
        [ style
            [ ( "backgroundColor", "red" )
            , ( "position", "fixed" )
            , ( "height", "20px" )
            , ( "width", "20px" )
            , ( "top", "100px" )
            , ( "left", (toString (amount * 30)) ++ "px" )
            ]
        ]
        []
