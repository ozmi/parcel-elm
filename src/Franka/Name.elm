module Franka.Name exposing (..)

import String exposing (words, join)
import Regex exposing (..)

type alias Name
    = List String

fromString : String -> Name
fromString string =
    List.map 
        (\word -> replace All (regex "\\W") (\{match} -> "") word)
        (words string)

snakeCase : Name -> String
snakeCase name = 
    join "_" name