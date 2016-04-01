Elm Bootstrap wrappers
======================

This projects aims at providing Elm implementations of non-trivial Bootstrap components.

Implemented components:
 - [Dropdown](#Dropdown)
 - [Select](#Select)
 - [Modal](#Modal)

Check the [DEMO](http://pzavolinsky.github.io/elm-bootstrap/)!

Dropdown
--------

A Bootstrap [dropdown](http://getbootstrap.com/javascript/#dropdowns).

Usage:
```elm
import Bootstrap.Dropdown as Dropdown


-- MODEL
type alias Model =
  { showDropdown : Bool
  -- more fields here
  }

-- UPDATE
type Action
  = Dropdown Bool
  -- more actions here

update : Action -> Model -> Model
update action model =
  case action of
    Dropdown m ->
      { model | showDropdown = m }
    -- more actions here

-- VIEW
dropdownView : Signal.Address Action -> Bool -> Html
dropdownView address showDropdown =
  let
    button = Dropdown.button <HTML>
    items =
      [ Dropdown.Header "Actions"
      , Dropdown.Item (<SOME ACTION>) "Action 1"
      , Dropdown.Divider
      , Dropdown.Item (<SOME ACTION>) "Action 2"
      ]
    in
      Dropdown.viewFor Dropdown button items address showDropdown

view : Signal.Address Action -> Model -> Html
view address model =
  let
    dropdown = dropdownView address model.showDropdown
  in
    dropdown
    -- combine with other elements
```

For example the missing bits about could be (using [Elmx syntax](https://github.com/pzavolinsky/elmx)):
```elm
-- UPDATE
type Action
  = Dropdown Bool
  | Click String

-- VIEW
dropdownView : Signal.Address Action -> Bool -> Html
dropdownView address showDropdown =
  let
    button = Dropdown.button
      <button class="btn btn-primary" type="button">
        Dropdown <span class="caret"></span>
      </button>
    items =
      [ Dropdown.Header "Actions"
      , Dropdown.Item (Click "a1") "Action 1"
      , Dropdown.Divider
      , Dropdown.Item (Click "a2") "Action 2"
      ]
    in
      Dropdown.viewFor Dropdown button items address showDropdown
```

Check the full example here: [src/Test/Dropdown.elmx](https://github.com/pzavolinsky/elm-bootstrap/blob/master/src/Test/Dropdown.elmx).

The `items` list can include any of the following:
```elm
type MenuItem a
  = ItemHtml a Html -- An HTML item that triggers action `a` when clicked
  | DisabledHtml Html -- An HTML item that is disabled
  | HeaderHtml Html -- An HTML header
  | Item a String -- A string item that triggers action `a` when clicked
  | Disabled String -- A string item that is disabled
  | Header String -- A string header
  | Divider -- A menu divider
  | Custom Html -- A custom menu item (must include the LI)
```

The `Dropdown.button` function technically wraps an HTML element constructor, but we can think of it as taking an actual HTML element:

```elm
type alias HtmlCtor = List Html.Attribute -> List Html -> Html
button : HtmlCtor -> List Html.Attribute -> List Html -> Button a

-- as in
Dropdown.button <button>Hey</button>

-- or (without Elmx)

Dropdown.button Html.button [] [Html.text "Hey"]
```

Select
------

A fancy `<select>` replacement using Bootstrap dropdowns.

Usage:
```elm
import Bootstrap.Select as Select


-- MODEL
type alias Model =
  { value : Select.Model <TYPE>
  }
init : Model
init =
  { value = Select.init [ <TYPE> ] <TYPE>
  }

-- UPDATE
type Action
  = Select (Select.Action <TYPE>)
  -- more actions here

update : Action -> Model -> Model
update action model =
  case action of
    Select a ->
      { model | value = Select.update a model.value }
    -- more actions here

-- VIEW
selectView : Signal.Address Action -> Select.Model <TYPE> -> Html
selectView address =
  let
    render = Html.text << toString
    btnClass = "btn btn-default"
  in
    Select.view render btnClass (Signal.forwardTo address Select)

view : Signal.Address Action -> Model -> Html
view address model = selectView address model.value
    -- combine with other elements
```

Check the full example here: [src/Test/Select.elmx](https://github.com/pzavolinsky/elm-bootstrap/blob/master/src/Test/Select.elmx).

The `Select.init` function takes a list of elements and the selected element, and returns a model:
```elm
init : List a -> a -> Model a
```

The `Select.value` function can be used to obtain the selected element from a model:
```elm
value : Model a -> a
```

The `Select.set` function can be used to *replace* the selected element in a model:
```elm
set : a -> Model a -> Model a
```

The `Select.update` function will produce a new model from an old model and an action just like any other `update` function:
```elm
update : Action a -> Model a -> Model a
```

The `Select.view` function produces an `Html` from a `render` function (that translates an `a` into an `Html`), the CSS classes to apply to the select button and the regular `view` function arguments (signal address and model):
```elm
view : (a -> Html) -> String -> Signal.Address (Action a) -> Model a -> Html
```

The `Select.view'` function works just like `Select.view` except that takes two *render* functions, one to render the selected value and one to render the items inside the dropdown menu:
```elm
view' : (a -> Html) -> (a -> Html) -> String -> Signal.Address (Action a) -> Model a -> Html
view' renderValue renderItem class address model =
  -- ...
```

Modal
--------

A Bootstrap [modal](http://getbootstrap.com/javascript/#modals).

Usage:
```elm
import Bootstrap.Modal as Modal


-- MODEL
type alias Model =
  { showModal : Bool
  -- more fields here
  }

-- UPDATE
type Action
  = OpenModal
  | CloseModal
  -- more fields here

update : Action -> Model -> Model
update action model =
  case action of
    OpenModal ->
      { model | showModal = True }
    CloseModal ->
      { model | showModal = False }
    -- more fields here

-- VIEW
modalView : Signal.Address Action -> Html
modalView address =
  let
    title = Modal.title <TITLE STRING>
    body = <HTML>
    footer = <HTML>
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
    Html.div [] modal
```

For example the missing bits about could be (using [Elmx syntax](https://github.com/pzavolinsky/elmx)):
```elm
modalView : Signal.Address Action -> Html
modalView address =
  let
    title = Modal.title "Question:"
    body = <p>Should we close this modal?</p>
    footer =
      <div>
        <button type="button" class="btn btn-default" {onClick address CloseModal}>Yes</button>
        <button type="button" class="btn btn-primary" {onClick address CloseModal}>Sure!</button>
      </div>
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
    <div>
      {:modal}
      <button type="button" class="btn btn-success" {click}>Open modal!</button>
    </div>
```

Check the full example here: [src/Test/Modal.elmx](https://github.com/pzavolinsky/elm-bootstrap/blob/master/src/Test/Modal.elmx).

The `Modal.view` function takes three `Html` elements (`title`, `body` and `footer`) and the action (`a`) that will be triggered when closing the modal using the top-right `x`:
```elm
view : Html -> Html -> Html -> Signal.Address a -> a -> Html
```

The `Modal.title` is just an alias for `Html.text` but you can use more fancy titles by passing a custom `Html` element directly to `Modal.view`.

TODO
----
 - pick a namespace that plays nice with the rest of the world.
 - make an Elm package.
