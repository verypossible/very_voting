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
         ,div [] (List.map (nominationView model) model.nominations)
         ])

nominationView : Model -> Nomination -> Html Msg
nominationView model nomination =
    form [ chooseEvent model |> Events.onSubmit ]
        [ nominationOrInput model nomination
        , nameOrEditButton model
        ]

chooseEvent : Model -> Msg
chooseEvent model =
    if model.editing then
        SaveNomination
    else
        StartEditing

nominationOrInput : Model -> Nomination -> Html Msg
nominationOrInput model nomination =
    if model.editing && nomination.nominator == model.user.email then
        input [ placeholder nomination.nominee, value model.nominee, Events.onInput ChangeNomination ] []
    else
        span [] [ text nomination.nominee ]

nameOrEditButton : Model -> Html Msg
nameOrEditButton model =
    if model.nomination.nominator == model.user.email then
        button [ ] [ text (editButtonText model) ]
    else
        span [] [ text (" - " ++ model.nomination.nominatorName) ]

editButtonText : Model -> String
editButtonText model =
    if model.editing then
        "Save"
    else
        "Change Nomination"

connectionMessage : String -> Html Msg
connectionMessage message =
    p [] [ text message ]

defaultLayout : Html Msg -> Html Msg
defaultLayout msg =
    div []
        [button [ Events.onClick ResetElection ] [ text "Reset" ]
        , msg
        ]
