module TagSelector where

import Css
import Html
import Html.Attributes as Att
import Urls
import Database.Tag as Tag exposing (Tag)
import Effects exposing (Effects)
import EffectsUtil
import Json.Decode as Decode exposing ((:=))
import Http
import Task
import Html.Events as Events
import List.Extra exposing (singleton)


-- MODEL

type alias Model =
    { selected: List Tag
    , suggestions: List Suggestion 
    }

type alias Suggestion =
    { list: List Tag
    , label: String
    }

init: ( Model, Effects Action )
init =
    ( Model [] []
    , Http.get decoder Urls.suggestedTags
        |> Task.toResult
        |> Task.map UpdateSuggestions
        |> Effects.task
    )

decoder: Decode.Decoder (List Suggestion)
decoder =
    Decode.object2
        Suggestion
        ("list" := Decode.list Tag.decoder)
        ("label" := Decode.string)
    |> Decode.list


-- UPDATE

type Action
    = UpdateSuggestions (Result Http.Error (List Suggestion))
    | AddTag Tag
    | RemoveTag Tag

update: Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        UpdateSuggestions (Result.Ok ls) ->
            EffectsUtil.noFx { model | suggestions = ls }
        UpdateSuggestions (Result.Err err) ->
            EffectsUtil.noFx model
            |> Debug.log (toString err)
        AddTag tag ->
            if List.all (\t -> t.pk /= tag.pk) model.selected
                then EffectsUtil.noFx { model | selected = tag :: model.selected }
                else EffectsUtil.noFx model
        RemoveTag tag ->
            EffectsUtil.noFx { model | selected = List.filter (\t -> t.pk /= tag.pk) model.selected }


-- VIEW

view: Signal.Address Action -> Model -> Html.Html
view address model =
    Html.div [ Att.id "tag-selector" ]
        [ if List.isEmpty model.selected
            then
                Html.div [] []
            else
                List.reverse model.selected
                |> List.map (tagView RemoveTag address)
                |> Html.div [ Att.class "row tag-selector-row" ]
        , List.map 
            (\{list, label} ->
                Html.div [ Att.class "row tag-selector-row" ]
                    [ label ++ ":"
                        |> Html.text
                        |> singleton
                        |> Html.div [ Css.column 1 ]
                    , List.map (tagView AddTag address) list
                        |> Html.div [ Css.column 10 ]
                    ]
            )
            model.suggestions
            |> Html.div []
        ]

tagView: (Tag -> Action) -> Signal.Address Action -> Tag -> Html.Html
tagView actionF address tag =
    Tag.view False tag
        |> singleton
        |> Html.div
            [ Events.onClick address (actionF tag)
            , Att.class "tag-cont-cont"
            ]