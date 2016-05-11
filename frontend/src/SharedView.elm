module SharedView where

import Html
import Html.Attributes as Att
import Css
import Urls


header: Html.Html
header =
    Html.div []
        [ Html.div
            [ Css.row 
            , Att.id "header"
            ]
            [ Html.div [ Css.column 2 ]
                [ Html.a [ Att.href "/" ]
                    [ Html.img
                        [ Urls.image "logo.svg" |> Att.src
                        , Css.columnImage
                        ]
                        []
                    ]
                ]
            , Html.div [ Css.column 8 ]
                [ Html.h1 [ Att.id "title" ] 
                    [ Html.a [ Att.href "/", Att.class "link" ] [ Html.text "SAŽETAK.hr" ] ] 
                ]
            ]
        , Html.hr [] []
        ]