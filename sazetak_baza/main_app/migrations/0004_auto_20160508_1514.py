# -*- coding: utf-8 -*-
# Generated by Django 1.9.5 on 2016-05-08 13:14
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0003_auto_20160508_1441'),
    ]

    operations = [
        migrations.AlterField(
            model_name='tag',
            name='kind',
            field=models.CharField(choices=[('GRADE', 'Razred'), ('SUBJECT', 'Predmet')], max_length=5),
        ),
    ]
