from django.shortcuts import render
from django.http import HttpResponse

from rest_framework.views import APIView

from .models import payments
from .serializers import paymentsSerializer

from payments.settings import CLIENT_ID, CLIENT_SECRET

import requests
import json
import base64
import random
import string

from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi

def PaypalToken(client_ID, client_Secret):

    url = "https://api-m.sandbox.paypal.com/v1/oauth2/token"
    data = {
                "client_id" : client_ID,
                "client_secret" : client_Secret,
                "grant_type":"client_credentials"
            }
    headers = {
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": "Basic {0}".format(base64.b64encode((CLIENT_ID + ":" + CLIENT_SECRET).encode()).decode())
            }

    token = requests.post(url, data, headers=headers)
    print(token.json())
    return token.json()['access_token']

#on request add reference_id, description, custom_id, soft_descriptor, amount: currency_code, value
class CreateOrderViewRemote(APIView):
    amount_param = openapi.Parameter('amount', openapi.IN_QUERY, description="amount of order in EUR", type=openapi.TYPE_STRING)
    @swagger_auto_schema(manual_parameters=[amount_param], responses={200: '{order_id: integer, linkForPayment: Link for paypal payment page}', 400: '{error: error message}', 422: '{error: error message}'})
    def post(self, request):
        token = PaypalToken(CLIENT_ID, CLIENT_SECRET)
        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer '+token,
            'PayPal-Request-Id': ''.join(random.choices(string.ascii_uppercase + string.digits + string.ascii_lowercase, k=random.randint(1, 36)))
        }

        json_data = {
            "intent": "CAPTURE",
            "purchase_units": [
                {
                "reference_id": ''.join(random.choices(string.ascii_uppercase + string.digits + string.ascii_lowercase, k=random.randint(1, 265))),
                "amount": {
                    "currency_code": "EUR",
                    "value": request.data['amount']
                }
                }
            ],
            "payment_source": {
                "paypal": {
                "experience_context": {
                    "payment_method_preference": "IMMEDIATE_PAYMENT_REQUIRED",
                    "payment_method_selected": "PAYPAL",
                    "brand_name": "RideMate",
                    "landing_page": "LOGIN",
                    "user_action": "PAY_NOW",
                    "return_url": "http://127.0.0.1:8080/paypal/finish",  #change this later to the actual return url
                    "cancel_url": "http://127.0.0.1:8080/paypal/finish"
                }
                }
            }
        }
        response = requests.post('https://api-m.sandbox.paypal.com/v2/checkout/orders', headers=headers, json=json_data)
        #print(response.json())
        try:
            linkForPayment = response.json()['links'][1]['href']
            #create a new entry in the ongoing_payments table
            ongoing = paymentsSerializer(data={'order_id': response.json()['id'], 'pp_id': headers['PayPal-Request-Id']})
            if ongoing.is_valid():
                ongoing.save()
            else:
                return HttpResponse(json.dumps({'error': 'something went wrong with order creation'}), status=422)
        except:
            return HttpResponse(json.dumps({'error': 'something went wrong with order creation'}), status=400)
        
        return HttpResponse(json.dumps({'order_id': response.json()['id'], 'linkForPayment': linkForPayment}), status=201)

class CaptureOrderView(APIView):
    #capture order aims to check whether the user has authorized payment.
    id_param = openapi.Parameter('id', openapi.IN_QUERY, description="order id", type=openapi.TYPE_STRING)
    @swagger_auto_schema(manual_parameters=[id_param], responses={201: '{status: success}', 400: '{error: error message}'})
    def post(self, request):
        #check if the id exists and payment is not payed
        print("ODERID: " + str(request.data['id']))
        if payments.objects.filter(order_id=request.data['id'], payed=False).exists():
            token = PaypalToken(CLIENT_ID, CLIENT_SECRET)  
            captureurl = 'https://api.sandbox.paypal.com/v2/checkout/orders/' + request.data['id'] + '/capture'   #see transaction status
            headers = {"Content-Type": "application/json", "Authorization": "Bearer "+token, "PayPal-Request-Id": payments.objects.get(order_id=request.data['id'], payed=False).pp_id, "Prefer": "return=representation"}
            response = requests.post(captureurl, headers=headers)

        else:
            return HttpResponse(json.dumps({'error': 'the order doesn\'t exist'}), status=400)

        print(response.json())

        #check if key 'status' exists in the response
        if 'status' in response.json() and response.json()['status'] == 'COMPLETED':

            print('order_id: ', response.json()['id'])
            print('reference_id: ', response.json()['purchase_units'][0]['reference_id'])
            print('amount: ', response.json()['purchase_units'][0]['amount']['value'])
            
            completed = payments.objects.get(order_id=request.data['id'], payed=False)
            completed.payed = True
            completed.save()
            return HttpResponse(json.dumps({'status': 'success'}), status=201)
        else:
            return HttpResponse(json.dumps({'error': 'something went wrong with order capture'}), status=400)