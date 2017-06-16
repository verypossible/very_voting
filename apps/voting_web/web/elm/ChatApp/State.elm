module ChatApp.State exposing (init, update)

import Http
import Phoenix
import Phoenix.Push as Push
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (object, string)
import Update.Extra.Infix exposing ((:>))
import ChatApp.Types exposing (..)
import ChatApp.Vars exposing (..)

init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        user =
            User "" "" "" ""
        nomination =
            Nomination "" "" ""
    in
        Model [] nomination user "Initializing" "" ErrorView flags.location False ! [getUser]

getUser : Cmd Msg
getUser =
    let
        url =
            "/auth/get_user"

        request =
            Http.get url decodeUser
    in
        Http.send NewToken request

decodeUser : Decoder User
decodeUser =
    JD.map4 User
        (JD.field "token" JD.string)
        (JD.field "picture" JD.string)
        (JD.field "name" JD.string)
        (JD.field "email" JD.string)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartEditing ->
            { model | editing = True } ! []
        GetNominations ->
            let
                push =
                    Push.init "election:vote" "get_nominations"
            in
                model ! [ Phoenix.push (endPoint model) push ]
                    :> update GetNomination

        GetNomination ->
            let
                push =
                    Push.init "election:vote" "get_nomination"
                        |> Push.withPayload (JE.object [ ("nominator", JE.string model.user.email) ])
            in
                model ! [ Phoenix.push (endPoint model) push ]

        SaveNomination ->
            let
                nomination = Nomination model.nominee model.user.email model.user.name
                push =
                    Push.init "election:vote" "save_nomination"
                        |> Push.withPayload (JE.object [ ("nominee", JE.string nomination.nominee)
                                                       , ("nominator", JE.string nomination.nominator)
                                                       , ("nominatorName", JE.string nomination.nominatorName) ])
            in
                { model | nominee = "", nomination = nomination, editing = False, view = NominationListView } ! [ Phoenix.push (endPoint model) push ]

        ChangeNomination nominee ->
            { model | nominee = nominee } ! []

        LoadNominations payload ->
            case JD.decodeValue decodeNominations payload of
                Ok nominations ->
                    { model | nominations = nominations } ! []

                Err err ->
                    model ! []

        LoadNomination payload ->
            case JD.decodeValue decodeNomination payload of
                Ok nomination ->
                    { model | nomination = nomination, view = NominationListView } ! []

                Err err ->
                    { model | view = SubmitNominationView } ! []

        NewToken (Ok user) ->
            { model | user = user } ! []
                :> update GetNominations

        NewToken (Err sadNews) ->
            { model | connectionMessage = "You must login", view = ErrorView } ! []

        Connected ->
            { model | connectionMessage = "Connected!", view = EmptyView } ! []

        ResetElection ->
            let
                push =
                    Push.init "election:vote" "reset_election"
            in
                model ! [ Phoenix.push (endPoint model) push ]

decodeNomination : Decoder Nomination
decodeNomination =
    JD.map3 Nomination
        (JD.field "nominee" JD.string)
        (JD.field "nominator" JD.string)
        (JD.field "nominatorName" JD.string)

decodeNominations : Decoder (List Nomination)
decodeNominations =
    JD.field "nominations" (JD.list decodeNomination)
