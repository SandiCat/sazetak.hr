from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^search_documents/([\w\d ]*)$', views.search_documents),
    url(r'^document/(\d+)$', views.document_display),
]