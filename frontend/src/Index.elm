module Index where

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


-- MODEL

type alias Model =
    { initialData: InitalData 
    , search: Search.Model
    }

type alias InitalData =
    { text: String }

init: ( Model, Effects Action )
init =
    EffectsUtil.update
        (\x -> Model (InitalData "placehold") x)
        SearchAction
        Search.init


-- UPDATE

type Action
    = ChangeInitialData InitalData
    | SearchAction Search.Action

update: Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        ChangeInitialData data ->
            { model | initialData = data }
            |> EffectsUtil.noFx
        SearchAction action ->
            Search.update action model.search
            |> EffectsUtil.update
                (\x -> {model | search = x })
                SearchAction


-- VIEW

view: Signal.Address Action -> Model -> Html.Html
view address model =
    Html.div
        [ Css.container ]
        [ SharedView.header
        , Html.div [ Css.row ]
            [ Html.div [ Css.column 6 ]
                [ Html.button [ Css.fullWidth ] [ Html.text "traži" ] ]
            , Html.div [ Css.column 6 ]
                [ Html.button [ Css.fullWidth ] [ Html.text "dodaj" ] ]
            ]
        , Search.view (Signal.forwardTo address SearchAction) model.search
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
