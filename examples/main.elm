import Html exposing (Html, div, input, text, dl, dt, dd)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Franka.Name exposing (..)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { content : Name
  }


model : Model
model =
  Model (fromString "")



-- UPDATE


type Msg
  = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = (fromString newContent) }



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Name to parse", onInput Change ] []
    , dl [] 
      [ dt [] [ text "Snake Case" ]
      , dd [] [ text (snakeCase model.content) ] 
      ]
    ]
