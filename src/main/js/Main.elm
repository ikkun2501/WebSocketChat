module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import WebSocket exposing (..)


{-| Model
messages チャットでやりとりしているメッセージのリスト
message 現在入力しているメッセージ
-}
type alias Model =
    { messages : List String
    , message : String
    }


{-| initModel
初期モデル
-}
initModel : Model
initModel =
    { messages = []
    , message = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


{-| Msg
Send --メッセージ送信
Input String -- メッセージ入力
Receive String --メッセージ受信
-}
type Msg
    = Send
    | Input String
    | Receive String


{-| View
ModelからViewに変換する
-}
view : Model -> Html Msg
view model =
    div []
        [ --　入力欄
          input [ type_ "text", onInput Input, value model.message ] []

        -- 送信ボタン
        , button [ onClick (Send) ] [ text "送信" ]

        --保持しているメッセージの表示
        , model.messages
            |> List.map (\l -> li [] [ text l ])
            |> ul []
        ]


{-| update
メッセージによってモデルの値を変換する

Input
入力ボックスの値が変更されたときのメッセージ
メッセージの値を変換する

send
送信ボタンが押されたたときのメッセージ
メッセージの値を空にする
メッセージをウェブソケットサーバーに送信する

Receive
WebSocketサーバからメッセージを受信したときのメッセージ
WebSocketサーバから受け取ったメッセージをメッセージリストの先頭に追加する

-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- メッセージ入力
        Input newMessage ->
            ( { model | message = newMessage }, Cmd.none )

        -- 送信処理
        Send ->
            ( { model | message = "" }, WebSocket.send webSocketServerUrl model.message )

        -- メッセージ受信
        Receive str ->
            ( { model | messages = str :: model.messages }, Cmd.none )


{-| subscription
WebSocketServerからのメッセージを購読
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen webSocketServerUrl Receive


{-| Main
-}
main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


{-| webSocketServerUrl
WebSocketサーバーの定数
-}
webSocketServerUrl : String
webSocketServerUrl =
    "ws://localhost:8080/chat"
