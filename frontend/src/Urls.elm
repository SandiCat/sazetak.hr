module Urls where

import Http
import Json.Decode
import Task
import String


image: String -> String
image s =
    "/static/img/" ++ s

searchDocuments: String -> List Int -> String
searchDocuments query tagPks =
    "/search_documents/" ++ query ++ "/" ++
    ( List.map toString tagPks |> String.join "," )

document: Int -> String
document pk =
    "/document/" ++ (toString pk)

docsWithTag: Int -> String
docsWithTag pk =
    "/docs_with_tag/" ++ (toString pk)

suggestedTags: String
suggestedTags =
    "/suggested_tags"