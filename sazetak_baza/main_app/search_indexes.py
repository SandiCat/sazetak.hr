from .models import Document
from haystack import indexes
import datetime
from django.template import loader, Context


class DocumentIndex(indexes.Indexable, indexes.SearchIndex):
    text = indexes.EdgeNgramField(
        document=True, use_template=True, template_name="search/indexes/main_app/document_text.txt")
    author = indexes.CharField(model_attr="author")
    date_added = indexes.DateTimeField(model_attr="date_added")
    rating = indexes.FloatField(model_attr="rating")
    tags = indexes.MultiValueField()

    def get_model(self):
        return Document

    def prepare_tags(self, obj):
        return [tag.pk for tag in obj.tags.all()]

    def index_queryset(self, using=None):
        return self.get_model().objects
