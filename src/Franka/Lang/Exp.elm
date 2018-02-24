module Franka.Lang.Exp exposing (..)

import Franka.Name

type Selector a
  = SelectIndex Int
  | SelectName Name
  | SelectValue a