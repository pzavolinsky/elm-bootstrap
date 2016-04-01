module Test.Dropdown where

import Bootstrap.Dropdown as Dropdown
import StartApp.Simple as StartApp
import Html exposing (Html)
import Html.Attributes


-- MODEL
type alias Model =
  { showDropdown : Bool
  }
init : Model
init =
  { showDropdown = False
  }

-- UPDATE
type Action
  = Dropdown Bool
  | Click String

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

-- VIEW
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
      , Dropdown.Divider
      , Dropdown.Item (Click "a2") "Action 2"
      ]
    in
      Dropdown.viewFor Dropdown button items address showDropdown

view : Signal.Address Action -> Model -> Html
view address model =
  Html.div [] [
    dropdownView address model.showDropdown, Html.text " (check the browser console)
  "]

main : Signal Html
main = StartApp.start
  { model = init
  , update = update
  , view = view
  }
