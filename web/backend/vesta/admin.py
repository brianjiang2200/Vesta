from django.contrib import admin
from .models import Listing

class ListingAdmin(admin.ModelAdmin):
    list_display = ('owner', 'property_id', 'unit', 'duration', 'rate')

# Register your models here.
admin.site.register(Listing, ListingAdmin)