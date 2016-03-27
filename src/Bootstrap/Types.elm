module Bootstrap.Types where

import Html exposing (Html)

type alias HtmlCtor = List Html.Attribute -> List Html -> Html
type alias View a m = Signal.Address a -> m -> Html
