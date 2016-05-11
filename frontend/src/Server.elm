module Server where

import Http
import Json.Decode
import Database.Document as Document
import Urls
import Task


searchDocuments: String -> Task.Task Http.Error (List Document.Document)
searchDocuments query =
    Urls.searchDocuments query
    |> Http.get (Json.Decode.list Document.decoder) 