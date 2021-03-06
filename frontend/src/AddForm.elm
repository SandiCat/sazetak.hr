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
import Urls


-- MODEL

type alias Model =
    { initialData: InitalData
    , tagSelector: TagSelector.Model
    }

type alias InitalData = {}

init: ( Model, Effects Action )
init =
    EffectsUtil.update
        (\x -> Model (InitalData) x)
        TagSelectorAction
        TagSelector.init


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
        , Html.form 
            [ Att.action Urls.postDocument
            , Att.method "post" 
            , Att.id "document-form"
            ]
            [ Html.input [ Att.type' "text", Att.name "name", Css.fullWidth ] []
                |> twoColumn "Ime:"
            , Html.textarea [ Att.name "description", Att.form "document-form", Css.fullWidth ] []
                |> twoColumn "Opis:"
            , Html.textarea [ Att.name "content", Att.form "document-form", Css.fullWidth ] []
                |> twoColumn "Sadržaj:"
            , TagSelector.view (Signal.forwardTo address TagSelectorAction) model.tagSelector
                |> twoColumn "Tagovi:"
            , Html.input [ Att.type' "submit", Att.class "button-primary", Att.value "Objavi"] []
            ] 
        , SharedView.footer
        ]


twoColumn: String -> Html.Html -> Html.Html
twoColumn label input  =
    Html.div [ Css.row ]
        [ Html.h5 [ Css.column 2 ] [ Html.text label ]
        , Html.div [ Css.column 10] [ input ]
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
