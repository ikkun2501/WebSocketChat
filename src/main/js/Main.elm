module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import WebSocket exposing (..)


-- MODEL


type alias Model =
    { messages : List String
    , message : String
    }


initModel : Model
initModel =
    { messages = [ ]
    , message = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- MESSAGES


type Msg
    = Send
    | Change String
    | NewMessage String



-- VIEW


view : Model -> Html Msg
view model =
    --    ul []
    --        (List.map (\l -> li [] [ text l ]) model)
    div []
        [ input [ type_ "text", onInput Change, value model.message ] []
        , button [ onClick (Send) ] [ text "送信" ]
        , model.messages
            |> List.map (\l -> li [] [ text l ])
            |> ul []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Send ->
            ( { model | message = "" }, WebSocket.send wsserver model.message )

        --            ( { model
        --                | messages = model.message :: model.messages
        --                , message = ""
        --              }
        --            , Cmd.none
        --            )
        Change newMessage ->
            ( { model | message = newMessage }, Cmd.none )

        NewMessage str ->
            ( { model | messages = str :: model.messages }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen wsserver NewMessage



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


wsserver : String
wsserver =
    --    "ws://localhost:3000"
    "ws://localhost:8080/chat"
