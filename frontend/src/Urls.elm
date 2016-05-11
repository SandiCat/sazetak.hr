module Urls where

import Http
import Json.Decode
import Task


image: String -> String
image s =
    "/static/img/" ++ s

searchDocuments: String -> String
searchDocuments query =
     "/search_documents/" ++ query

document: Int -> String
document pk =
    "/document/" ++ (toString pk)

docsWithTag: Int -> String
docsWithTag pk =
    "/docs_with_tag/" ++ (toString pk)