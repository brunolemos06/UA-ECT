from django.db import models

class payments(models.Model):
    order_id = models.CharField(max_length=256)
    pp_id = models.CharField(max_length=36)
    payed = models.BooleanField(default=False)

    