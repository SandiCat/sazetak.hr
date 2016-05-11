from . import elm
from haystack import query
from django.core import serializers
from django.http import HttpResponse, JsonResponse
from .models import Document, Tag
import json


def index(request):
    return elm.render_elm(request, "Index", "style", {"text": "Test!!!!"})


def document_display(request, pk):
    return elm.render_elm(
        request,
        "DocumentDisplay",
        "style",
        {"documentJson": json.dumps(_expand_document_tags(Document.objects.get(pk=pk)))}
    )


def search_documents(request, text):
    if text:
        return _json_response(
            [_expand_document_tags(q.object) for q in query.SearchQuerySet().filter(content=text).order_by("-rating")])
    else:
        return _json_response([_expand_document_tags(q) for q in Document.objects.all().order_by("-date_added")[:10]])


def _expand_document_tags(doc):
    # ovo je uzasno sporo, mozda koristit tastypie/REST poslje
    s = serializers.serialize("json", [doc])
    obj = json.loads(s)
    obj[0]["expanded_tags"] = json.loads(serializers.serialize("json", doc.tags.get_queryset()))
    return obj[0]


def _json_response(data):
    return HttpResponse(json.dumps(data), content_type="application/json")
