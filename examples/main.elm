module Main exposing (..)

import Franka.Lang.TypeExp exposing (..)
import Franka.Name exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { content : Name
    , selection : String
    , rootType : TypeLit
    }


type TreeNode a
    = Branch a (List (TreeNode a))
    | Leaf a


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


myTree : TreeNode String
myTree =
    Branch "root"
        [ Leaf "a"
        , Leaf "b"
        ]


model : Model
model =
    Model (fromString "") "" root



-- UPDATE


type Msg
    = Change String
    | SelectTypePath (List Name)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = fromString newContent }

        SelectTypePath path ->
            { model | selection = String.join "." (List.map snakeCase path) }



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
