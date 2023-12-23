from django.db import models

# class Owner(models.Model):
#     id = models.UUIDField(primary_key=True)
#     # trip_id = models.ForeignKey('Trip', on_delete=models.CASCADE)

#     def __str__(self):
#         return self.id

class Trip(models.Model):
    id = models.UUIDField(primary_key=True)
    origin = models.TextField()
    destination = models.TextField()
    info = models.JSONField(blank=True, null=True)
    available_sits = models.IntegerField()
    starting_date = models.DateTimeField()
    # owner_id = models.ForeignKey(Owner, on_delete=models.CASCADE)
    owner_id = models.TextField()

    def __str__(self):
        return {'id': self.id, 'origin': self.origin, 'destination': self.destination, 'owner_id': self.owner_id, 'info': self.info}

class Participant(models.Model):
    id = models.TextField(primary_key=True)
    pickup_location = models.TextField()
    trip_id = models.ForeignKey(Trip, on_delete=models.CASCADE)
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True)

    def __str__(self):
        return {'id': self.id, 'pickup_location': self.pickup_location, 'trip_id': self.trip_id, 'price': self.price}
