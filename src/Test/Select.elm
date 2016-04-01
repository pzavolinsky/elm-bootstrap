module Test.Select where

import Bootstrap.Select as Select
import StartApp.Simple as StartApp
import Html exposing (Html)
import Html.Attributes


-- MODEL
type Color = Red | Green | Blue
type alias Model =
  { color : Select.Model Color
  }
init : Model
init =
  { color = Select.init [ Red, Green, Blue ] Green
  }

-- UPDATE
type Action
  = Select (Select.Action Color)

update : Action -> Model -> Model
update action model =
  case action of
    Select a ->
      { model | color = Select.update a model.color }

-- VIEW
colorClass : Color -> String
colorClass color = case color of
  Red ->
    "danger"
  Green ->
    "success"
  Blue ->
    "primary"

selectView : Signal.Address Action -> Select.Model Color -> Html
selectView address model =
  let
    color = Select.value model
    class = colorClass color
    renderValue = Html.text << toString
    renderItem c = Html.span [Html.Attributes.attribute "class" ("text-"++(colorClass c))] [Html.text (toString c)]
  in
    Select.view'
      renderValue
      renderItem
      ("btn btn-" ++ class)
      (Signal.forwardTo address Select)
      model

view : Signal.Address Action -> Model -> Html
view address model =
  Html.div [] [
    selectView address model.color
  ]

main : Signal Html
main = StartApp.start
  { model = init
  , update = update
  , view = view
  }
