module Bootstrap.Modal where

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)

title : String -> Html
title = Html.text

view : Html -> Html -> Html -> Signal.Address a -> a -> Html
view title body footer address closeAction =
  let
    close = onClick address closeAction
  in
    Html.div [Html.Attributes.attribute "class" "modal fade in", Html.Attributes.attribute "tabindex" "-1", Html.Attributes.attribute "role" "dialog"] [
      Html.div [Html.Attributes.attribute "class" "modal-backdrop fade in", close] []
      , Html.div [Html.Attributes.attribute "class" "modal-dialog", Html.Attributes.attribute "role" "document"] [
        Html.div [Html.Attributes.attribute "class" "modal-content"] [
          Html.div [Html.Attributes.attribute "class" "modal-header"] [
            Html.button [Html.Attributes.attribute "type" "button", Html.Attributes.attribute "class" "close", Html.Attributes.attribute "aria-label" "Close", close] [
              Html.span [Html.Attributes.attribute "aria-hidden" "true"] [Html.text "×"]
            ]
            , Html.h4 [Html.Attributes.attribute "class" "modal-title"] [title]
          ]
          , Html.div [Html.Attributes.attribute "class" "modal-body"] [body]
          , Html.div [Html.Attributes.attribute "class" "modal-footer"] [footer]
        ]
      ]
    ]
