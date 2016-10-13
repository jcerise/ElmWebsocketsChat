module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import List


main : Program Never
main =
    App.program
    { init = init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }

-- Model

type alias Model =
  { chatMessages : List String,
    userMessage : String
  }

init : (Model, Cmd Msg)
init =
  ( Model [] "",
    Cmd.none
  )

-- Update

type Msg
  = PostChatMessage
  | UpdateUserMessage String
  | NewChatMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PostChatMessage ->
      let
        message = model.userMessage
      in
        { model | userMessage = ""} ! [WebSocket.send "ws://127.0.1.1:8888/chat" message]

    UpdateUserMessage message ->
      { model | userMessage = message} ! []

    NewChatMessage message ->
      let
        messages = message :: model.chatMessages
      in
        { model | chatMessages = messages } ! []

-- View

view : Model -> Html Msg
view model =
  div []
      [ input [ placeholder "message...",
               autofocus True,
               value model.userMessage,
               onInput UpdateUserMessage ] [],
        button [ onClick PostChatMessage ] [ text "Submit" ],
        displayChatMessages model.chatMessages
      ]

displayChatMessages : List String -> Html a
displayChatMessages chatMessages =
  div [] (List.map ( \x -> div [] [ text x ] ) chatMessages)


-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://127.0.1.1:8888/chat" NewChatMessage
