module Bootstrap.Dropdown where

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Json
import Bootstrap.Types exposing (HtmlCtor, View)


-- TYPES
type alias Button a = (Model -> a) -> Signal.Address a -> Model -> Html
type MenuItem a
  = ItemHtml a Html
  | DisabledHtml Html
  | HeaderHtml Html
  | Item a String
  | Disabled String
  | Header String
  | Divider
  | Custom Html

-- MODEL
type alias Model = Bool
init : Bool -> Model
init = identity


-- UPDATE
type alias Action = Model
update : Action -> Model -> Model
update action _ = action

-- VIEW
button : HtmlCtor -> List Html.Attribute -> List Html -> Button a
button f attrs children wrap address model =
  let
    expanded = if model then [ attribute "aria-expanded" "true" ] else []
    click = onClick address (wrap (not model))
  in
    f (attrs ++ expanded ++ [click]) children

view : Button Action -> List (MenuItem Action) -> View Action Model
view button address model = viewFor identity button address model

menu : Signal.Address a -> List (MenuItem a) -> Html
menu address items =
  let
    click a = onWithOptions "click"
      { stopPropagation = True
      , preventDefault = True
      }
      Json.value (\_ -> Signal.message address a)
    mapItem item =
      case item of
        ItemHtml a h ->
          Html.li [] [Html.a [Html.Attributes.attribute "href" "#", (click a)] [h]]
        Item a t ->
          Html.li [] [Html.a [Html.Attributes.attribute "href" "#", (click a)] [Html.text t]]
        DisabledHtml h ->
          Html.li [Html.Attributes.attribute "class" "disabled"] [Html.a [Html.Attributes.attribute "href" "#"] [h]]
        Disabled t ->
          Html.li [Html.Attributes.attribute "class" "disabled"] [Html.a [Html.Attributes.attribute "href" "#"] [Html.text t]]
        HeaderHtml h ->
          Html.li [Html.Attributes.attribute "class" "dropdown-header"] [h]
        Header t ->
          Html.li [Html.Attributes.attribute "class" "dropdown-header"] [Html.text t]
        Divider ->
          Html.li [Html.Attributes.attribute "role" "separator", Html.Attributes.attribute "class" "divider"] []
        Custom h ->
          h
    lis = List.map mapItem items
  in
    Html.ul [Html.Attributes.attribute "class" "dropdown-menu"] lis

viewFor : (Model -> a) -> Button a -> List (MenuItem a) -> View a Model
viewFor = viewWithClass "dropdown"

viewWithClass : String -> (Model -> a) -> Button a -> List (MenuItem a) -> View a Model
viewWithClass containerClass wrap button children address model =
  let
    open = if model then " open" else ""
    backdrop = if model
      then [Html.div [Html.Attributes.attribute "class" "modal-backdrop fade", (onClick address (wrap False))] []]
      else []
  in
    Html.div [Html.Attributes.attribute "class" (containerClass ++ open)] ([
      button wrap address model
      , menu address children
      ] ++ backdrop ++ [
    ])
