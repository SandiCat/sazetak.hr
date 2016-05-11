module Css where

import Html.Attributes
import Html
import Array


container: Html.Attribute
container =
    Html.Attributes.class "container"

row: Html.Attribute
row =
    Html.Attributes.class "row"

column: Int -> Html.Attribute
column num =
    Html.Attributes.class
        ((Array.get (num - 1) numberWord |> Maybe.withDefault "one")
        ++ " column"
        ++ (if num /= 1 then "s" else ""))

numberWord: Array.Array String
numberWord =
    ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"]
    |> Array.fromList

columnImage: Html.Attribute
columnImage =
    Html.Attributes.class "u-max-full-width"

fullWidth: Html.Attribute
fullWidth =
    Html.Attributes.class "u-full-width"