module ChatApp.Types exposing (..)

import Http
import Json.Decode as JD exposing (Decoder)

type alias Model =
    { nominations : List Nomination
    , nomination : Nomination
    , user : User
    , connectionMessage: String
    , nominee : String
    , view : ViewType
    , location : String
    , editing : Bool
    }

type alias User =
    { token : String
    , picture : String
    , name : String
    , email : String
    }

type alias Nomination =
    { nominee : String
    , nominator : String
    , nominatorName : String
    }

type alias Flags =
  { location : String }

type ViewType
    = SubmitNominationView
    | NominationListView
    | ErrorView
    | EmptyView

type Msg
    = LoadNominations JD.Value
    | LoadNomination JD.Value
    | GetNominations
    | GetNomination
    | SaveNomination
    | NewToken (Result Http.Error User)
    | Connected
    | ChangeNomination String
    | ResetElection
    | StartEditing
