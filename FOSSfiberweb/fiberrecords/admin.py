from leaflet.admin import LeafletGeoAdmin
from django.contrib import admin
from .models import *

# Register your models here.
admin.site.register(UtilityPole, LeafletGeoAdmin)
