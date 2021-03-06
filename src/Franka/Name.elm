module Franka.Name exposing (..)

import Json.Decode exposing (..)
import Regex exposing (..)
import String exposing (join, words)


type alias Name =
    List String


fromString : String -> Name
fromString string =
    List.map
        (\word -> replace All (regex "\\W") (\{ match } -> "") word)
        (words string)


snakeCase : Name -> String
snakeCase name =
    join "_" name


nameDecoder : Decoder Name
nameDecoder =
    map fromString string