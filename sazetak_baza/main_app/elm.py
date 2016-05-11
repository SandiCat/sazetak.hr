from django.shortcuts import render
import json


def render_elm(request, elmfile, cssfile, inital_data):
    context = {
        "script": elmfile + ".js",
        "css": cssfile + ".css",
        "elmfile": elmfile,
        "data": json.dumps(inital_data),
    }
    return render(request, "elm.html", context=context)
