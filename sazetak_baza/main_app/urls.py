from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^search_documents/([\w\d ]*)/?([\d,]*)?$', views.search_documents),
    url(r'^suggested_tags', views.suggested_tags),
    url(r'^document/(\d+)$', views.document_display),
    url(r'^add_form$', views.add_form),
    url(r'^post_document$', views.post_document)
]