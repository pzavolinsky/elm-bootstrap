module Main where

import Bootstrap.Dropdown as Dropdown
import Bootstrap.Select as Select
import Bootstrap.Modal as Modal
import StartApp.Simple as StartApp
import Signal
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (onClick)


-- MODEL
type alias Model =
  { showDropdown : Bool
  , showModal : Bool
  , simpson : Select.Model String
  }
init : Model
init =
  { showDropdown = False
  , showModal = False
  , simpson = Select.init ["Homer","Marge","Bart","Lisa","Maggie"] "Bart"
  }

type Action
  = Dropdown Bool
  | Click String
  | OpenModal
  | SaveModal
  | CloseModal
  | Select (Select.Action String)

update : Action -> Model -> Model
update action model =
  case action of
    Click s ->
      let
        _ = Debug.log "click" s
      in
        { model | showDropdown = False }
    Dropdown m ->
      { model | showDropdown = m }
    OpenModal ->
      { model | showModal = True, showDropdown = False }
    SaveModal ->
      { model | showModal = False, simpson = Select.set "Maggie" model.simpson }
    CloseModal ->
      { model | showModal = False }
    Select a ->
      { model | simpson = Select.update a model.simpson }


dropdownView : Signal.Address Action -> Bool -> Html
dropdownView address showDropdown =
  let
    button = Dropdown.button
      Html.button [Html.Attributes.attribute "class" "btn btn-primary", Html.Attributes.attribute "type" "button"] [Html.text "
        Dropdown ", Html.span [Html.Attributes.attribute "class" "caret"] []
      ]
    items =
      [ Dropdown.Header "Actions"
      , Dropdown.Item (Click "a1") "Action 1"
      , Dropdown.Item (Click "a2") "Action 2"
      , Dropdown.Divider
      , Dropdown.Item OpenModal "Show modal"
      ]
    in
      Dropdown.viewFor Dropdown button items address showDropdown

modalView : Signal.Address Action -> Html
modalView address =
  let
    title = Modal.title "Choose Maggie"
    body = Html.p [] [Html.text "Should we set that thing to \"Maggie\""]
    footer =
      Html.div [] [
        Html.button [Html.Attributes.attribute "type" "button", Html.Attributes.attribute "class" "btn btn-default", (onClick address CloseModal)] [Html.text "Nop"]
        , Html.button [Html.Attributes.attribute "type" "button", Html.Attributes.attribute "class" "btn btn-primary", (onClick address SaveModal)] [Html.text "Sure!"]
      ]
  in
    Modal.view title body footer address CloseModal


selectView : Signal.Address Action -> Select.Model String -> Html
selectView address = Select.view
  Html.text
  "btn btn-default"
  (Signal.forwardTo address Select)

view : Signal.Address Action -> Model -> Html
view address model =
  let
    modal = if model.showModal
      then [ modalView address ]
      else []
  in
    Html.div [] ([
      dropdownView address model.showDropdown
      ] ++ modal ++ [
      selectView address model.simpson
    ])

main : Signal Html
main = StartApp.start
  { model = init
  , update = update
  , view = view
  }
