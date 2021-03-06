from . import elm
from haystack import query
from django.core import serializers
from django.http import HttpResponse, JsonResponse, HttpResponseRedirect
from .models import Document, Tag, Author
import json
from django.views.decorators.csrf import csrf_exempt
from django.core.urlresolvers import reverse
import datetime
from haystack.management.commands import update_index


def index(request):
    return elm.render_elm(request, "Index", "style", {"text": "Test!!!!"})


def add_form(request):
    return elm.render_elm(request, "AddForm", "style", {"text": "Test!!!!"})


@csrf_exempt
def post_document(request):
    doc = Document(
        name=request.POST["name"],
        description=request.POST["description"],
        content=request.POST["content"],
        date_added=datetime.datetime.now(),
        rating=0.5,
        author=Author.objects.all()[0],
    )
    doc.save()
    update_index.Command().handle()
    return HttpResponseRedirect(reverse("index"))


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
