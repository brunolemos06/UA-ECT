from rest_framework import serializers
from .models import Trip, Participant

class TripSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trip
        fields = ['id', 'origin', 'destination', 'info', 'available_sits', 'starting_date', 'owner_id']

class ParticipantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participant
        fields = ['id', 'pickup_location', 'trip_id', 'price']

class OwnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trip
        fields = ['owner_id', 'id', 'origin', 'destination', 'info', 'available_sits', 'starting_date']