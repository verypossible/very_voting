module ChatApp exposing (..)

import Html exposing (programWithFlags)
import ChatApp.Types exposing (Model, Msg, Flags)
import ChatApp.State exposing (init, update)
import ChatApp.Subscriptions exposing (subscriptions)
import ChatApp.Views exposing (view)

main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
