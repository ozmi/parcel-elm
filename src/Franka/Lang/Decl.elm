module Franka.Lang.Decl exposing (..)

type Decl a
  = Module (Dict Name (Decl a))
  | Def (Exp a)