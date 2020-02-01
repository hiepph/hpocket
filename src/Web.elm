module Web exposing (..)

import Browser
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL


type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ = (Success "", Cmd.none)


-- UPDATE

type Msg
  = GotText (Result Http.Error String)
  | Change String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change newQuery ->
      (Loading, query newQuery)

    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  div []
  [ input [ placeholder "Query", onInput Change ] []
  , div []
    [ viewResult model ]
  ]

viewResult : Model -> Html Msg
viewResult model =
  case model of
    Failure ->
      text "Unable to load."

    Loading ->
      text "Loading..."

    Success fullText ->
       text fullText


-- HTTP

query : String -> Cmd Msg
query q =
  Http.get
    { url = "http://localhost:4567/q/" ++ q
    , expect = Http.expectString GotText
    }
