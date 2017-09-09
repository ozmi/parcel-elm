module Main exposing (..)

import Franka.Lang.TypeExp exposing (..)
import Franka.Name exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import String


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { content : Name
    , selection : String
    , rootType : TypeLit
    }


root : TypeLit
root =
    Module
        [ ( [ "franka" ]
          , Literal
                (Module
                    [ ( [ "name" ], Literal (Record []) )
                    , ( [ "lang" ], Literal (Record []) )
                    ]
                )
          )
        ]


init : ( Model, Cmd Msg )
init =
    ( Model (fromString "") "" root, Cmd.none )



-- UPDATE


type Msg
    = Change String
    | SelectTypePath (List Name)
    | ServerRequest
    | ServerResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | content = fromString newContent }, Cmd.none )

        SelectTypePath path ->
            ( { model | selection = String.join "." (List.map snakeCase path) }, Cmd.none )

        ServerRequest ->
            ( model, Http.send ServerResponse (Http.get "test.txt" Decode.string) )

        ServerResponse (Ok data) ->
            ( { model | selection = data }, Cmd.none )

        ServerResponse (Err _) ->
            ( { model | selection = "error" }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Name to parse", onInput Change ] []
        , dl []
            [ dt [] [ text "Snake Case" ]
            , dd [] [ text (snakeCase model.content) ]
            ]
        , text model.selection
        , viewTypeLit [] model.rootType
        , button [ onClick ServerRequest ] [ text "Request" ]
        ]


viewTypeLit : List Name -> TypeLit -> Html Msg
viewTypeLit path typeLit =
    case typeLit of
        Module subTypes ->
            ul []
                (List.map
                    (\( name, tpe ) ->
                        let
                            childPath =
                                List.append path [ name ]
                        in
                        li []
                            [ span [ onClick (SelectTypePath childPath) ] [ text (snakeCase name) ]
                            , viewTypeExp childPath tpe
                            ]
                    )
                    subTypes
                )

        Record fields ->
            text ""


viewTypeExp : List Name -> TypeExp -> Html Msg
viewTypeExp path typeExp =
    case typeExp of
        Literal typeLit ->
            viewTypeLit path typeLit
