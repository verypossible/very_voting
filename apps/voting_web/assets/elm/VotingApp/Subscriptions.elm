module VotingApp.Subscriptions exposing (subscriptions)

import Phoenix
import Phoenix.Socket as Socket exposing (Socket)
import Phoenix.Channel as Channel exposing (Channel)
import VotingApp.Types exposing (..)
import VotingApp.Vars exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.connect (socket model)
        <| [ channel ]

socket : Model->Socket Msg
socket model =
    Socket.init (endPoint model)
        |> Socket.reconnectTimer (\backoffIteration -> (backoffIteration + 1) * 5000 |> toFloat)
        |> Socket.onOpen (Connected)

channel : Channel Msg
channel =
    Channel.init "election:vote"
        |> Channel.on "load_nominations" (\nominations -> LoadNominations nominations)
        |> Channel.on "load_nomination" (\nomination -> LoadNomination nomination)
