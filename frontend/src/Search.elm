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
import TagSelector


-- MODEL

type alias Model =
    { query: String
    , documents: List Document.Document
    , tagSelector: TagSelector.Model
    }

init: ( Model, Effects Action )
init =
    let
        (tagSelector, fx) = TagSelector.init
        model = Model "" [] tagSelector
    in
        ( model
        , Effects.batch [ getDocuments model, Effects.map TagSelectorAction fx ]
        )


-- UPDATE

type Action
    = InputChange String
    | NewSearchResults (Result Http.Error (List Document.Document))
    | TagSelectorAction TagSelector.Action

update: Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        InputChange text ->
            let
                model' = { model | query = text }
            in
                ( model', getDocuments model' )
        NewSearchResults (Result.Ok docs) ->
            { model | documents = docs }
            |> EffectsUtil.noFx
        NewSearchResults (Result.Err err) ->
            Debug.log (toString err) model
            |> EffectsUtil.noFx
        TagSelectorAction action' ->
            let
                (tagSelector, fx) = TagSelector.update action' model.tagSelector
                model' = { model | tagSelector = tagSelector }
            in
                ( model'
                , Effects.batch [ Effects.map TagSelectorAction fx, getDocuments model' ]
                )

getDocuments: Model -> Effects Action
getDocuments model =
    List.map .pk model.tagSelector.selected
    |> Urls.searchDocuments model.query 
    |> Http.get (Json.Decode.list Document.decoder) 
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
                    , Att.class "u-full-width search-box"
                    ]
                    []
                ]
            , TagSelector.view (Signal.forwardTo address TagSelectorAction) model.tagSelector
            ]
            ++
            List.map Document.preview model.documents
        )
