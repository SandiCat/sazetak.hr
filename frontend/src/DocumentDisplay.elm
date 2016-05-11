module DocumentDisplay where

import Effects exposing (Effects)
import EffectsUtil
import CustomStartApp
import Task
import Html
import Html.Attributes as Att
import SharedView
import Css
import Json.Decode
import Database.Document as Document
import Database.Tag as Tag
import Markdown


-- MODEL

type alias Model =
    { initialData: InitalData
    , document: Document.Document
    }

type alias InitalData =
    { documentJson: String 
    }

init: ( Model, Effects Action )
init =
    Model (InitalData "") Document.empty
    |> EffectsUtil.noFx


-- UPDATE

type Action
    = ChangeInitialData InitalData

update: Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        ChangeInitialData data ->
            { model 
                | initialData = data
                , document =
                    case Json.Decode.decodeString Document.decoder data.documentJson of
                        Result.Ok doc ->
                            doc
                        Result.Err err ->
                            Document.empty
                            |> Debug.log (toString err)
            }
            |> EffectsUtil.noFx


-- VIEW

view: Signal.Address Action -> Model -> Html.Html
view address model =
    Html.div [ Css.container ]
        [ SharedView.header
        , Html.div [ Css.row ] 
            [ Html.div [ Att.class "eight columns document" ] [ Markdown.toHtml model.document.content ]
            , Document.detailView model.document 
                |> (++) 
                    [ Html.h4 [ Css.row ] [ Html.text model.document.name ]
                    , Html.div [ Css.row ] [ Html.text model.document.description ]
                    ] 
                |> Html.div [ Css.column 4 ]
            ]
        ]

markdownOptions: Markdown.Options
markdownOptions =
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Nothing
    , sanitize = True
    , smartypants = True
    }


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
