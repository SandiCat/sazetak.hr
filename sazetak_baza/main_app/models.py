from django.db import models
from django.contrib.auth.models import User
from enum import Enum


class Tag(models.Model):
    kind_choices = (
        ("GRADE", "Razred"),
        ("SBJCT", "Predmet")
    )

    label = models.CharField(max_length=100)
    kind = models.CharField(max_length=5, choices=kind_choices)

    def __str__(self):
        return "{} : {}".format(self.label, self.kind)


class Author(User):
    pass


class Document(models.Model):
    tags = models.ManyToManyField(Tag)
    content = models.TextField()
    date_added = models.DateTimeField()
    author = models.ForeignKey(Author, on_delete=models.CASCADE)
    rating = models.FloatField()
    name = models.CharField(max_length=200)
    description = models.TextField()

    def __str__(self):
        return self.name
