module Franka.Lang.Data exposing (..)

import Franka.Name

type Data
  = SimpleData String
  | ComplexData Operator Container
  
type Operator
  = Product
  | Sum
  
type Container
  = Seq (List Data)
  | Map (Dict Name Data)
  | Set (ESet Data)