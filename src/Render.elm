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
                        [ if game.flash == True then
                            flashView height width
                          else
                            div [] []
                        , div [] ((List.map boxRender game.stage) ++ (List.map boxRender game.enemyList))
                        , div [] (List.map boxRender game.bulletList)
                        , boxRender game.player
                        , div [] (List.map healthBox (List.range 1 game.health))
                        ]

                Pause ->
                    div
                        [ style
                            [ ( "color", "white" )
                            , ( "position", "relative" )
                            , ( "text-align", "center" )
                            , ( "height", "250px" )
                            ]
                        ]
                        [ h1 [] [ text "Pause" ]
                        , h2 [ onClick (ChangeState Playing) ] [ text "Resume" ]
                        , h2 [ onClick (Restart) ] [ text "Restart" ]
                        , h2 [ onClick (ChangeState Menu) ] [ text "Menu" ]
                        ]

                Dead ->
                    div
                        [ style
                            [ ( "color", "white" )
                            , ( "position", "relative" )
                            , ( "text-align", "center" )
                            , ( "height", "250px" )
                            ]
                        ]
                        [ h1 [] [ text "Dead" ]
                        , h2 [ onClick (Restart) ] [ text "Restart" ]
                        ]

                Victory ->
                    div
                        [ style
                            [ ( "color", "white" )
                            , ( "position", "relative" )
                            , ( "text-align", "center" )
                            , ( "height", "250px" )
                            ]
                        ]
                        [ h1 [] [ text "You Win" ]
                        , h2 [ onClick (Restart) ] [ text "Restart" ]
                        , h2 [ onClick (ChangeState Menu) ] [ text "Menu" ]
                        ]

                Boss ->
                    div
                        [ style
                            [ -- ( "backgroundColor", "purple" )
                              -- ,
                              ( "position", "relative" )
                            , ( "left", (toString 0) ++ "px" )
                            , ( "height", (toString height) ++ "px" )
                            ]
                        ]
                        [ if game.flash == True then
                            flashView height width
                          else
                            div [] []
                        , div [] ((List.map boxRender game.stage) ++ (List.map boxRender game.enemyList))
                        , div [] (List.map boxRender game.bulletList)
                        , boxRender game.player
                        , div [] (List.map healthBox (List.range 1 game.health))
                        , div [] (List.map bossHealthBox (List.range 1 game.bossHealth))
                        ]
            ]


menuView : Html Msg
menuView =
    div
        [ style
            [ ( "color", "white" )
            , ( "position", "relative" )
              -- , ( "left", "250px" )
            , ( "height", "250px" )
            , ( "text-align", "center" )
            ]
        ]
        [ h1 [] [ text "Boxuuume" ]
        , h2 [ onClick (ChangeState Playing) ] [ text "Play" ]
        , h3 [ style [ ( "margin-top", "300px" ), ( "margin-bottom", "0" ) ] ]
            [ a [ href "https://github.com/chmar77", target "_blank" ]
                [ text "Created by rinn7e"
                ]
            ]
        , h4 [ style [ ( "margin-top", "5px" ) ] ]
            [ a [ href "http://elm-lang.org/", target "_blank" ]
                [ text "Built with Elm"
                ]
            ]
        ]


flashView : Int -> Int -> Html Msg
flashView height width =
    div
        [ style
            [ ( "backgroundColor", "white" )
            , ( "position", "fixed" )
            , ( "left", "0" )
            , ( "top", "0" )
            , ( "height", (toString height) ++ "px" )
            , ( "width", (toString width) ++ "px" )
            , ( "overflow", "hidden" )
            ]
        ]
        []


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
            [ ( "backgroundColor", "#ff00ff" )
            , ( "position", "fixed" )
            , ( "height", "20px" )
            , ( "width", "20px" )
            , ( "top", "100px" )
            , ( "left", (toString (amount * 30)) ++ "px" )
            ]
        ]
        []


bossHealthBox amount =
    div
        [ style
            [ ( "backgroundColor", "yellow" )
            , ( "position", "fixed" )
            , ( "height", "20px" )
            , ( "width", "20px" )
            , ( "top", "50px" )
            , ( "left", (toString (amount * 30)) ++ "px" )
            ]
        ]
        []
