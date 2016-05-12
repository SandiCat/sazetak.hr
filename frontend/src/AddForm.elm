module AddForm where

import Effects exposing (Effects)
import EffectsUtil
import CustomStartApp
import Task
import Html
import Html.Attributes as Att
import SharedView
import Css
import Material.Icons.Action
import Color
import Search
import TagSelector
import Dict exposing (Dict)


-- MODEL

type alias Model =
    { initialData: InitalData 
    , documentInputs: Dict String String
    , tagSelector: TagSelector.Model
    }

type alias InitalData = {}

init: ( Model, Effects Action )
init =
    let
        inputs =
            ["name", "description", "content", "rating"]
            |> List.map (\s -> (s, ""))
            |> Dict.fromList
    in
        EffectsUtil.update
            (\x -> Model (InitalData) inputs x)
            TagSelectorAction
            TagSelector.init

niceName: Dict String String
niceName =
    [ ("name", "Ime")
    , ("description", "Opis")
    , ("content", "Sadržaj")
    , ("rating", "Ocjena")
    ]


-- UPDATE

type Action
    = ChangeInitialData InitalData
    | TagSelectorAction TagSelector.Action

update: Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        ChangeInitialData data ->
            { model | initialData = data }
            |> EffectsUtil.noFx
        TagSelectorAction action ->
            TagSelector.update action model.tagSelector
            |> EffectsUtil.update
                (\x -> {model | tagSelector = x })
                TagSelectorAction


-- VIEW

view: Signal.Address Action -> Model -> Html.Html
view address model =
    Html.div
        [ Css.container ]
        [ SharedView.header
        , List.map
            (\())
        , SharedView.footer
        ]


-- SIGNALS

port initialData: Signal InitalData

inputs: List (Signal Action)
inputs =
    [ initialData
        |> Signal.map ChangeInitialData
    ]

init': List Action -> ( Model, Effects Action )
init' =
    let
        update' action (model, fx) =
            let
                (model', fx') = update action model
            in
                (model', Effects.batch [fx, fx'])
    in
        List.foldr update' init

app: CustomStartApp.App Model
app =
    CustomStartApp.start
        { init = init'
        , update = update
        , view = view
        , inputs = inputs
        }

main: Signal Html.Html
main =
    app.html

port tasks: Signal (Task.Task Effects.Never ())
port tasks =
    app.tasks
