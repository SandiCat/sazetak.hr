module Database.Tag where

import Json.Decode as Decode exposing ((:=))
import Html
import Html.Attributes as Att
import Urls


-- MODEL

type alias Tag =
    { label: String
    , kind: Kind
    , pk: Int
    }

type Kind
    = GRADE
    | SBJCT
    | Error

decoder: Decode.Decoder Tag
decoder =
    Decode.object3
        (\l k p -> Tag l (decodeKind k) p)
        (Decode.at ["fields", "label"] Decode.string)
        (Decode.at ["fields", "kind"] Decode.string)
        ("pk" := Decode.int)

decodeKind: String -> Kind
decodeKind s =
    case s of
        "GRADE" -> GRADE
        "SBJCT" -> SBJCT
        _ -> Error |> Debug.log "Unknown Kind in Tag decoding"


-- VIEW

view: Bool -> Tag -> Html.Html
view haveLink tag =
    Html.div [ Att.class "tag-cont" ]
        [ Html.div [ Att.class "tag" ] 
            [ if haveLink 
                then Html.a [ Urls.docsWithTag tag.pk |> Att.href, Att.class "link" ] [ Html.text tag.label ] 
                else Html.text tag.label
            ] 
        ]