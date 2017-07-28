module Franka.Lang.TypeExp exposing (..)

import Franka.Name exposing (Name)


type TypeExp
    = Literal TypeLit


type TypeLit
    = Module (List ( Name, TypeExp ))
    | Record (List ( Name, TypeExp ))
