module Test.Modal where

import Bootstrap.Modal as Modal
import StartApp.Simple as StartApp
import Signal
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (onClick)


-- MODEL
type alias Model =
  { showModal : Bool
  }
init : Model
init =
  { showModal = False
  }

-- UPDATE
type Action
  = OpenModal
  | CloseModal

update : Action -> Model -> Model
update action model =
  case action of
    OpenModal ->
      { model | showModal = True }
    CloseModal ->
      { model | showModal = False }

-- VIEW
modalView : Signal.Address Action -> Html
modalView address =
  let
    title = Modal.title "Question:"
    body = Html.p [] [Html.text "Should we close this modal?"]
    footer =
      Html.div [] [
        Html.button [Html.Attributes.attribute "type" "button", Html.Attributes.attribute "class" "btn btn-default", (onClick address CloseModal)] [Html.text "Yes"]
        , Html.button [Html.Attributes.attribute "type" "button", Html.Attributes.attribute "class" "btn btn-primary", (onClick address CloseModal)] [Html.text "Sure!"]
      ]
  in
    Modal.view title body footer address CloseModal

view : Signal.Address Action -> Model -> Html
view address model =
  let
    modal = if model.showModal
      then [ modalView address ]
      else []
    click = onClick address OpenModal
  in
    Html.div [] ([
      ] ++ modal ++ [
      Html.button [Html.Attributes.attribute "type" "button", Html.Attributes.attribute "class" "btn btn-success", click] [Html.text "Open modal!"]
    ])

main : Signal Html
main = StartApp.start
  { model = init
  , update = update
  , view = view
  }
