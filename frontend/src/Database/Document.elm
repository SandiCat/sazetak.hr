module Database.Document where

import Json.Decode as Decode exposing ((:=))
import Html
import Html.Attributes as Att
import Database.Tag as Tag
import Css
import Urls
import String


-- MODEL

type alias Document =
    { tags: List Tag.Tag
    , content: String
    , date_added: String
    , rating: Float
    , authorPk: Int
    , name: String
    , description: String
    , pk: Int
    }

empty: Document
empty =
    Document [] "" "" 0 0 "" "" 0

decoder: Decode.Decoder Document
decoder =
    Decode.object8
        Document
        ("expanded_tags" := (Decode.list Tag.decoder))
        (Decode.at ["fields", "content"] Decode.string)
        (Decode.at ["fields", "date_added"] Decode.string)
        (Decode.at ["fields", "rating"] Decode.float)
        (Decode.at ["fields", "author"] Decode.int)
        (Decode.at ["fields", "name"] Decode.string)
        (Decode.at ["fields", "description"] Decode.string)
        ("pk" := Decode.int)


-- VIEW

ratingView: Document -> Html.Html
ratingView doc =
    Html.div [ Att.class "rating" ]
        [ Html.div 
            [ Att.style 
                [ ( "width", (doc.rating * 100 |> round |> toString) ++ "%" ) 
                , ( "background-color", "#f1c40f")
                ]
            , Att.class "rating"
            ]
            []
        ]

dateView: Document -> Html.Html
dateView doc =
    -- date example: 2016-05-08T13:22:38Z
    String.slice -9 -1 doc.date_added ++ " " ++ String.slice 0 10 doc.date_added
    |> Html.text

detailView: Document -> List Html.Html
detailView doc =
    [ Html.div [ Att.class "row rating-cont" ] [ ratingView doc ]
    , List.map (Tag.view True) doc.tags |> Html.div [ Css.row ]
    , dateView doc
    ]

preview: Document -> Html.Html
preview doc =
    Html.div [ Att.class "document-preview-cont" ]
        [ Html.div [ Att.class "document-preview row" ]
            [ Html.div [ Css.column 8 ]
               [ Html.div [ Css.row ] 
                    [ Html.a [ Urls.document doc.pk |> Att.href, Att.class "link" ]
                        [ Html.h5 [] [ Html.text doc.name ] ]
                    ]
                , Html.div [ Css.row ] [ Html.text doc.description ]
                ]
            , detailView doc |> Html.div [ Css.column 4 ]
            ]
        ]