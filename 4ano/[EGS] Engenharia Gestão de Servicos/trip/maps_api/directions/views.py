from django.http import JsonResponse
from directions.serializers import *
from maps_api.settings import GOOGLE_DIRECTIONS_API_KEY
import requests
import datetime
from directions.models import Trip, Participant
from datetime import datetime
from rest_framework.decorators import APIView
import json
from rest_framework import status
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from django.utils.dateparse import parse_datetime
import uuid

url = 'https://maps.googleapis.com/maps/api/directions/json'

class TripView(APIView):
    @swagger_auto_schema(query_serializer=TripSerializer, responses={201: '{v: True, msg: Trip created successfully.}'})
    def post(self, request):
        # print(request.data.get('id'))
        # print(request.data)
        # print(request)
        # id = uuid.UUID(request.data.get('id'))
        id = uuid.uuid4()
        origin = request.data.get('origin')
        destination = request.data.get('destination')
        owner_id = uuid.UUID(request.data.get('owner_id'))
        # starting_date = datetime.fromtimestamp(int(request.data.get('starting_date')))
        starting_date = parse_datetime(request.data.get('starting_date'))
        available_sits = int(request.data.get('available_sits'))
        params = {
            'origin': origin,
            'destination': destination,
            'key': GOOGLE_DIRECTIONS_API_KEY
        }

        info = requests.get(url, params=params)
        if (info.json().get('status')) != 'OK':
            return JsonResponse({'v': False, 'error': 'Cannot get directions.'}, status = 404)

        trip = Trip(id=id, origin=origin, destination=destination, owner_id=owner_id, starting_date=starting_date, available_sits=available_sits, info=info.json())
        trip.save()
        return JsonResponse({'v': True, 'msg':'Trip created successfully.'}, status = 201)

    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="trip id", type=openapi.TYPE_STRING)
    trip_response = openapi.Response('response description', TripSerializer)
    @swagger_auto_schema(manual_parameters=[id_param], responses={200: trip_response, 404: '{v: False, error: Cannot get Trip.}'})
    def get(self, request):
        # print the request url
        print(request.build_absolute_uri())
        query_set = Trip.objects.all()
        id = request.GET.get('id')
        if id is not None:
            query_set = query_set.filter(id=id)

        if query_set is None:
            return JsonResponse({'v': False, 'error': 'Cannot get Trip.'}, status = 404)
        else:
            # query_set = jsonpickle.dumps(list(query_set))
            query_set = list(query_set.values())
            
            return JsonResponse({'v': True, 'msg': query_set}, status = 200)

    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="trip id", type=openapi.TYPE_STRING)
    @swagger_auto_schema(manual_parameters=[id_param], responses={200: '{v: True, msg: Trip removed successfully}', 404: '{v: False, error: Cannot get Trip.}'})
    def delete(self, request):
        id = request.data.get('id')
        print(id)
        if id is None:
            return JsonResponse({'v': False, 'error': 'Id not provided.'}, status = 404)
        trip = Trip.objects.get(id=id)
        if trip is not None:
            trip.delete()
            
            return JsonResponse({'v': True, 'msg': f'Trip {id} removed successfully'}, status = 200)
        return JsonResponse({'v': False, 'error': f'No Trip with id {id}'}, status = 404)

class OwnerView(APIView):
    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="owner id", type=openapi.TYPE_STRING)
    owner_response = openapi.Response('response description', OwnerSerializer)
    @swagger_auto_schema(manual_parameters=[id_param], responses={200: owner_response, 404: '{v: False, error: Cannot get Owner.}'})
    def get(self, request):
        query_set = Trip.objects.all()
        owner_id = request.GET.get('id')
        print(list(query_set.values('owner_id').distinct()))
        res = {}
        if owner_id is None:
            for trip in query_set.values():
                '''
                    res = [
                        {
                            'owner_id': id,
                            'trips': []
                    ]
                '''
                if str(trip['owner_id']) not in list(res.keys()):
                    res[str(trip['owner_id'])] = []
                res[str(trip['owner_id'])].append({'id': trip['id'], 'origin': trip['origin'], 'destination': trip['destination'], 'starting_date': trip['starting_date'], 'available_sits': trip['available_sits']})
            return JsonResponse({'v': True, 'msg': res}, status = 200)
            
        query_set = query_set.filter(owner_id=owner_id)

        if query_set is None:
            return JsonResponse({'v': False, 'error': 'Cannot get Owner.'}, status = 404)

        for trip in query_set.values():
            if str(trip['owner_id']) not in list(res.keys()):
                res[str(trip['owner_id'])] = []
            res[str(trip['owner_id'])].append({'id': trip['id'], 'origin': trip['origin'], 'destination': trip['destination'], 'starting_date': trip['starting_date'], 'available_sits': trip['available_sits']})
        return JsonResponse({'v': True, 'msg': res}, status = 200)

class ParticipantView(APIView):
    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="participant id", type=openapi.TYPE_STRING)
    trip_id_param = openapi.Parameter('trip_id', openapi.IN_QUERY, description="trip id", type=openapi.TYPE_STRING)
    pickup_location_param = openapi.Parameter('pickup_location', openapi.IN_QUERY, description="pickup location", type=openapi.TYPE_STRING)
    
    @swagger_auto_schema(manual_parameters=[id_param, trip_id_param, pickup_location_param], responses={200: '{v: True, msg: Participant created successfully}', 404: '{v: False, error: Cannot get Trip.}'})
    def post(self, request):
        print("ENTROU")
        print(request.data)
        id = request.data.get('id')
        trip_id = request.data.get('trip_id')
        pickup_location = request.data.get('pickup_location')
        print(id, trip_id, pickup_location)
        trip = Trip.objects.get(id=trip_id)
        if trip is None:
            return JsonResponse({'v': False, 'error': f'No Trip with id {trip_id}'}, status = 404)
        if trip.available_sits == 0:
            return JsonResponse({'v': False, 'error': f'No available sits in Trip {trip_id}'}, status = 404)
        
        trip.available_sits -= 1
        
        
        trip.save()

        participant = Participant(id=id, trip_id=trip, pickup_location=pickup_location)
        participant.save()

        participant = Participant.objects.get(id=id)
        participant.price = self.get_price(id)
        participant.save()


        pickup_locations = []
        for p in Participant.objects.filter(trip_id=trip_id):
            pickup_locations.append(p.pickup_location)

        params = {
            'origin': trip.origin,
            'destination': trip.destination,
            'waypoints': '|'.join(pickup_locations),
            'key': GOOGLE_DIRECTIONS_API_KEY
        }

        info = requests.get(url, params=params)
        trip.info = info.json()
        trip.save()
    
        return JsonResponse({'v': True, 'msg': f'Participant {id} added to Trip {trip_id} successfully.', 'money': participant.price, 'participant_id':id}, status = 201)
    
    # @swagger_auto_schema(query_serializer=ParticipantSerializer)
    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="participant id", type=openapi.TYPE_STRING)
    participant_response = openapi.Response('response description', ParticipantSerializer)
    @swagger_auto_schema(manual_parameters=[id_param], responses={200: participant_response, 404: '{v: False, error: Cannot get Participant.}'})
    def get(self, request):
        print("PARTICIAPNT GET")
        print(request.data)
        query_set = Participant.objects.all()
        id = request.data.get('id')
        print(id)
        if id is not None:
            query_set = query_set.filter(id=id)

        if query_set is None:
            return JsonResponse({'v': False, 'error': 'Cannot get Participant.'}, status = 404)
        else:
            query_set = list(query_set.values())
            return JsonResponse({'v': True, 'msg': query_set}, status = 200)
    
    # @swagger_auto_schema(query_serializer=ParticipantSerializer)
    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="participant id", type=openapi.TYPE_STRING)
    @swagger_auto_schema(manual_parameters=[id_param], responses={200: '{v: True, msg: Participant deleted successfully}', 404: '{v: False, error: Cannot get Participant.}'})
    def delete(self, request):
        print("PARTICIAPNT DELETE")
        print(request.data)
        id = request.data.get('id')
        if id is None:
            return JsonResponse({'v': False, 'error': 'Id not provided.'}, status = 404)
        participant = Participant.objects.get(id=id)
        if participant is not None:
            trip = Trip.objects.get(id=participant.trip_id.id)
            if trip is not None:
                trip.available_sits += 1
                trip.save()
            participant.delete()

            pickup_locations = []
            for p in Participant.objects.filter(trip_id=trip.id):
                pickup_locations.append(p.pickup_location)

            params = {
                'origin': trip.origin,
                'destination': trip.destination,
                'waypoints': '|'.join(pickup_locations),
                'key': GOOGLE_DIRECTIONS_API_KEY
            }

            info = requests.get(url, params=params)
            trip.info = info.json()
            trip.save()

            return JsonResponse({'v': True, 'msg': f'Participant {id} removed successfully'}, status = 200)
        return JsonResponse({'v': False, 'error': f'No Participant with id {id}'}, status = 404)

    # get the total distance between the participant pickup location and the trip origin plus the distance
    # between the pickup location and the trip destination
    def get_distance(self, participant_id):
        participant = Participant.objects.get(id=participant_id)
        trip = Trip.objects.get(id=participant.trip_id.id)

        origin = trip.origin
        destination = trip.destination

        # calculate the distance between the origin and the pickup location
        params = {
            'origin': origin,
            'destination': participant.pickup_location,
            'key': GOOGLE_DIRECTIONS_API_KEY
        }

        request = requests.get(url, params=params)
        response = request.json()
        distance = 0
        for route in response['routes']:
            for leg in route['legs']:
                distance += leg['distance']['value']
        
        # calculate the distance between the pickup location and the destination
        params = {
            'origin': participant.pickup_location,
            'destination': destination,
            'key': GOOGLE_DIRECTIONS_API_KEY
        }

        request = requests.get(url, params=params)
        response = request.json()
        for route in response['routes']:
            for leg in route['legs']:
                distance += leg['distance']['value']
        
        return distance

    # get the price of the trip for the participant
    def get_price(self, participant_id):
        distance = self.get_distance(participant_id)
        return distance * 0.0001
