from django.db import models
from django.contrib.postgres import fields

# Create your models here.
class Listing(models.Model):
    owner = models.CharField(max_length=120, db_column='owner')
    property_id = models.IntegerField(db_column='propertyid')
    unit = models.CharField(max_length=120, db_column='unit')
    duration = fields.DateRangeField(db_column='duration')
    rate = fields.IntegerRangeField(db_column='rate')

    def _str_(self):
        return self.unit