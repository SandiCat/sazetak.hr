from . import elm
from haystack import query
from django.core import serializers
from django.http import HttpResponse, JsonResponse
from .models import Document, Tag
import json


def index(request):
    return elm.render_elm(request, "Index", "style", {"text": "Test!!!!"})


def add_form(request):
    return elm.render_elm(request, "AddForm", "style", {"text": "Test!!!!"})


def document_display(request, pk):
    return elm.render_elm(
        request,
        "DocumentDisplay",
        "style",
        {"documentJson": json.dumps(_expand_document_tags(Document.objects.get(pk=pk)))}
    )


def search_documents(request, text, tags):
    if not text and not tags:
        return _json_response([_expand_document_tags(q) for q in Document.objects.all().order_by("-date_added")[:10]])

    ls = query.SearchQuerySet().filter(content=text).order_by("-rating")
    if tags:
        tags = tags.split(",")
        for tag in tags:
            ls = ls.filter(tags__in=[int(tag)])
    return _json_response([_expand_document_tags(q.object) for q in ls])


def suggested_tags(request):
    l = [
        ("Razredi", Tag.objects.filter(kind="GRADE")),
        ("Predmeti", Tag.objects.filter(kind="SBJCT")),
        ("Popularno", sorted(Tag.objects.all(), key=lambda t: t.document_set.count())[:10])
    ]
    return _json_response([{"label": label, "list": _to_obj(ls)} for label, ls in l])


def _to_obj(data):
    return json.loads(serializers.serialize("json", data))


def _expand_document_tags(doc):
    # ovo je uzasno sporo, mozda koristit tastypie/REST poslje
    s = serializers.serialize("json", [doc])
    obj = json.loads(s)
    obj[0]["expanded_tags"] = json.loads(serializers.serialize("json", doc.tags.get_queryset()))
    return obj[0]


def _json_response(data):
    return HttpResponse(json.dumps(data), content_type="application/json")
