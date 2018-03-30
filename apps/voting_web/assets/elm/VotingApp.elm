module VotingApp exposing (..)

import Html exposing (programWithFlags)
import VotingApp.Types exposing (Model, Msg, Flags)
import VotingApp.State exposing (init, update)
import VotingApp.Subscriptions exposing (subscriptions)
import VotingApp.Views exposing (view)

main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
