module Franka.Lang.Data exposing (..)

import Franka.Name
import Franka.Lang.Exp exposing (LibraryRef)

type Data a
  = SimpleData LibraryRef (List Name)
  | ComplexData Operator (Container a)
  
type Operator
  = Product
  | Sum
  
type Container a
  = DataSeq (List (Data a))
  | DataMap (Dict Name (Data a))
  | DataSet (Set.Set (Data a))