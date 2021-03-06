module SharedView where

import Html
import Html.Attributes as Att
import Css
import Urls
import List.Extra exposing (singleton)


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
            , Html.div [ Css.column 10 ]
                [ Html.h1 [ Att.id "title" ] 
                    [ Html.a [ Att.href "/", Att.class "link" ] [ Html.text "SAŽETAK.hr" ] ] 
                ]
            ]
        , Html.div [ Css.row ]
            [ Html.div [ Css.column 6 ]
                [ Html.a [ Att.class "u-full-width button", Att.href Urls.index ] [ Html.text "traži" ] ]
            , Html.div [ Css.column 6 ]
                [ Html.a [ Att.class "u-full-width button", Att.href Urls.addForm ] [ Html.text "dodaj" ] ]
            ]
        , Html.hr [ Att.id "header-line" ] []
        ]

footer: Html.Html
footer =
    ["By Sandi Dušić, Manuel Žic & Marin Sinožić"
    , "Copyright © 2016"
    ]
    |> List.map (\s -> Html.text s |> singleton |> Html.p [])
    |> (++) [ Html.hr [] [] ]
    |> Html.footer [] 