module Franka.Lang.Exp exposing (..)

import Franka.Name

type Exp a
  = Const a
  | Ident Name
  | Apply (Exp a) (Exp a)
  | Lambda Name (Exp a)
  | Let Name (Exp a) (Exp a)
  | Select (Exp a) (Selector a)
  | Branch (Exp a) (List ((Selector a), (Exp a)))
  

type Selector a
  = SelectIndex Int
  | SelectName Name
  | SelectValue a