module Parcel.Main exposing (..)

import Franka.Lang.TypeExp exposing (TypeLit(Module))
import Html exposing (..)
import Html.Attributes exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    { rootModule : TypeLit
    }

