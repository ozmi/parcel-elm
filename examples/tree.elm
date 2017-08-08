module Tree exposing (..)

import Html exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type Branch
    = Branch String (List Branch)


type alias Model =
    Branch


model : Branch
model =
    Branch "root"
        [ Branch "a"
            [ Branch "a.a" []
            , Branch "a.b" []
            ]
        , Branch "b"
            [ Branch "b.a" []
            , Branch "b.b" []
            ]
        ]



-- UPDATE


type Msg
    = SelectPath (List String)


update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectPath path ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [] (viewNode model)


viewNode : Branch -> List (Html Msg)
viewNode (Branch name children) =
    ((span [] [ text name ])
        :: [ ul [] (List.map (\child -> li [] (viewNode child)) children) ]
    )
