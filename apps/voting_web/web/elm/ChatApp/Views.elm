module ChatApp.Views exposing (view)

import Html exposing (Html, button, div, p, span, text, input, form)
import Html.Attributes exposing (placeholder, value)
import Html.Events as Events
import ChatApp.Types exposing (..)

view : Model -> Html Msg
view model =
    case model.view of
        SubmitNominationView ->
            submitNominationView model
        NominationListView ->
            nominationsListView model
        EmptyView ->
            connectionMessage model.connectionMessage
        ErrorView ->
            connectionMessage model.connectionMessage

submitNominationView : Model -> Html Msg
submitNominationView model =
    defaultLayout (div []
        [ connectionMessage model.connectionMessage
        , form [ Events.onSubmit SaveNomination ]
               [ input [ placeholder "Nomination", value model.nominee, Events.onInput ChangeNomination ] []
               , button [] [ text "Send Nomination" ]
               ]
        ])

nominationsListView : Model -> Html Msg
nominationsListView model =
    defaultLayout (p [] [ connectionMessage model.connectionMessage
         ,div [] (List.map nominationView model.nominations)
         ])

nominationView : Nomination -> Html Msg
nominationView nomination =
    div []
        [ span [] [ text nomination.nominee ]
        , span [] [ text (" - " ++ nomination.nominatorName) ]
        ]

connectionMessage : String -> Html Msg
connectionMessage message =
    p [] [ text message ]

defaultLayout : Html Msg -> Html Msg
defaultLayout msg =
    div []
        [button [ Events.onClick ResetElection ] [ text "Reset" ]
        , msg]
