module Franka.Lang.TypeExp exposing (..)

import Franka.Name exposing (Name)
import Json.Decode exposing (..)


type TypeExp
    = Literal TypeLit


type TypeLit
    = Module (List ( Name, TypeExp ))
    | Record (List ( Name, TypeExp ))


typeExpDecoder : Decoder TypeExp
typeExpDecoder =
    map Literal (lazy (\_ -> typeLitDecoder))


typeLitDecoder : Decoder TypeLit
typeLitDecoder =
    lazy (\_ -> field "tag" string |> andThen typeLitTagDecoder)


typeLitTagDecoder : String -> Decoder TypeLit
typeLitTagDecoder t =
    case t of
        "module" ->
            moduleDecoder

        "record" ->
            recordDecoder

        other ->
            fail <| "unexpected tag: " ++ other


recordDecoder : Decoder TypeLit
recordDecoder =
    map Record (field "fields" (list nameTypeExpDecoder))


moduleDecoder : Decoder TypeLit
moduleDecoder =
    map Module (field "children" (list nameTypeExpDecoder))


nameTypeExpDecoder : Decoder ( Name, TypeExp )
nameTypeExpDecoder =
    map2 (\a b -> ( a, b )) Franka.Name.nameDecoder (lazy (\_ -> typeExpDecoder))
