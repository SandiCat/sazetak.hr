# -*- coding: utf-8 -*-
# Generated by Django 1.9.5 on 2016-05-08 12:35
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='document',
            name='rating',
            field=models.DecimalField(decimal_places=3, max_digits=3),
        ),
    ]
