module Search where

import Database.Document as Document
import Effects exposing (Effects)
import EffectsUtil
import Html
import Html.Attributes as Att
import Html.Events as Events
import Css
import Urls
import Http
import Task
import Json.Decode
import Server


-- MODEL

type alias Model =
    { query: String
    , documents: List Document.Document
    }

init: ( Model, Effects Action )
init =
    ( Model "" [], getDocuments "" )


-- UPDATE

type Action
    = InputChange String
    | NewSearchResults (Result Http.Error (List Document.Document))

update: Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        InputChange text ->
            ( { model | query = text }
            , getDocuments text
            )
        NewSearchResults (Result.Ok docs) ->
            { model | documents = docs }
            |> EffectsUtil.noFx
        NewSearchResults (Result.Err err) ->
            model
            |> Debug.log (toString err)
            |> EffectsUtil.noFx

getDocuments: String -> Effects Action
getDocuments text =
    Server.searchDocuments text
    |> Task.toResult
    |> Task.map NewSearchResults
    |> Effects.task


-- VIEW

view: Signal.Address Action -> Model -> Html.Html
view address model =
    Html.div []
        (
            [ Html.div [ Css.row ]
                [ Html.input
                    [ Att.value model.query
                    , Events.on
                        "input"
                        Events.targetValue
                        (InputChange >> Signal.message address)
                    , Att.class "u-full-width"
                    ]
                    []
                ]
            ]
            ++
            List.map Document.preview model.documents
        )
