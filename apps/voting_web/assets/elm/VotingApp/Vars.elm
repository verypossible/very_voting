module VotingApp.Vars exposing (..)

import VotingApp.Types exposing (..)

endPoint : Model->String
endPoint model =
    let
        token = model.user.token
        location = model.location
    in
        "ws://" ++ location ++ "/socket/websocket?token=" ++ token
