from leaflet.admin import LeafletGeoAdmin
from django.contrib import admin
from . import importedModels

# Register your models here.
admin.site.register(importedModels.UtilityPole, LeafletGeoAdmin)
