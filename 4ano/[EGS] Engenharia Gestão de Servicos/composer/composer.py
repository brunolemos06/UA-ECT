# auth                      -> port     =   5100
# review                    -> port     =   5005
# mensagem                  -> port     =   5010
# trip                      -> port     =   5015
# payment                   -> port     =   8000
# frontendauth              -> port     =   3000

# RIDE-MATE API [composer]  -> port     =   8080

from flask import Flask, jsonify, request , render_template
from flask_restful import Api, Resource, reqparse
import datetime
import sqlite3
from flask_swagger_ui import get_swaggerui_blueprint
import requests
from flask import redirect
import json
import uuid


# import file located in the same directory
from db_func import *

app = Flask(__name__)

ip = '0.0.0.0'

####################### IP/NAMES AND PORTS #######################
auth_ip_backend = 'auth-backend'
auth_port_backend = 5100

auth_ip_frontend = 'auth-frontend'
auth_port_frontend = 3000

review_ip = 'reviews'
review_port = 5005

chat_ip = 'chat-api'
chat_port = 5010

trip_ip = 'trip'
trip_port = 5015

payment_ip = 'payments'
payment_port = 8000
##################################################################

SWAGGER_URL = '/api/docs'   # URL for exposing Swagger UI (without trailing '/')
API_URL = '/static/swagger.yml'  # Our API url (can of course be a local resource)

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': "My App"
    }
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

api = Api(app)

new_user_args = reqparse.RequestParser()

appendurl = '/service-review/v1/'

@app.route('/')
def index():
    return 'Ridemate API',200

# ------------------ TRIP ------------------

@app.route('/trip/', methods=['GET', 'POST', 'DELETE'])
def trip():
    print('ON TRIP METHOD')
    # print the received request url
    print(request.url)
    url = f'http://{trip_ip}:{trip_port}/directions/trip/'
    if (request.method == 'GET'):
        trip_id = request.args.get('id')
        if (trip_id == None):
            response = requests.get(url)
        else:
            params = {'id': trip_id}
            response = requests.get(url, data=params)

        response_short = {'v': response.json()['v'], 'msg': [{'id': None, 'origin': None, 'destination': None, 'available_sits': None, 'starting_date': None, 'owner_id': None, 'info': {'origin_coords': None, 'destination_coords': None}} for i in range(len(response.json()['msg']))]}
        for i in range(len(response.json()['msg'])):
            print(i)
            response_short['msg'][i]['id'] = response.json()['msg'][i]['id']
            response_short['msg'][i]['origin'] = response.json()['msg'][i]['origin']
            response_short['msg'][i]['destination'] = response.json()['msg'][i]['destination']
            response_short['msg'][i]['available_sits'] = response.json()['msg'][i]['available_sits']
            response_short['msg'][i]['starting_date'] = response.json()['msg'][i]['starting_date']
            response_short['msg'][i]['owner_id'] = response.json()['msg'][i]['owner_id']
            origin_coords = response.json()['msg'][i]['info']['routes'][0]['bounds']['northeast']
            destination_coords = response.json()['msg'][i]['info']['routes'][0]['bounds']['southwest']
            response_short['msg'][i]['info'] = {'origin_coords': origin_coords, 'destination_coords': destination_coords, 'geocoded_waypoints': []}
            # if len(response.json()['msg'][i]['info']['geocoded_waypoints']) > 2:
            #     print(len(response.json()['msg'][0]['info']['geocoded_waypoints']))
            #     for w in range(2, len(response.json()['msg'][0]['info']['geocoded_waypoints'])):
            #         print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww :" + str(w))
            #         response_short['msg'][i]['info']['geocoded_waypoints'].append(response.json()['msg'][i]['info']['geocoded_waypoints'][w]['place_id'])
        print(response_short)
        return response_short, response.status_code
    elif (request.method == 'POST'):
        request.data = request.json
        id = request.data.get('id')
        origin = request.data.get('origin')
        destination = request.data.get('destination')
        available_sits = request.data.get('available_sits')
        starting_date = request.data.get('starting_date')
        owner_id = request.data.get('owner_id')
        params = {'id': id, 'origin': origin, 'destination': destination, 'available_sits': available_sits, 'starting_date': starting_date, 'owner_id': owner_id}
        print(params)
        response = requests.post(url, data=params)
    elif (request.method == 'DELETE'):
        id = json.loads(request.data.decode('utf-8'))['id']
        print(id)
        params = {'id': id}
        response = requests.delete(url, data=params)

    return response.json(), response.status_code


@app.route('/participant/', methods=['GET', 'POST', 'DELETE'])
def participant():
    print('ON PARTICIPANT METHOD')
    url = f'http://{trip_ip}:{trip_port}/directions/participant/'
    if (request.method == 'GET'):
        print('ON GET')
        print(request.args)
        id = request.args.get('trip_id')
        params = {'id': id}
        response = requests.get(url, data=params)
        print(response.json())
    elif (request.method == 'POST'):
        request.data = request.json
        print('ON POST')
        id = request.data.get('id')
        print(f'ID: {id}')
        trip_id = request.data.get('trip_id')
        pickup_location = request.data.get('pickup_location')
        params = {'id': id, 'trip_id': trip_id, 'pickup_location': pickup_location}

        print(params)
        response = requests.post(url, data=params)
    elif (request.method == 'DELETE'):
        request.data = request.json
        print('ON DELETE')
        id = request.data.get('id')
        params = {'id': id}
        print(params)
        response = requests.delete(url, data=params)
    return response.json(), response.status_code

@app.route('/owner/', methods=['GET'])
def owner():
    url = f'http://{trip_ip}:{trip_port}/directions/owner/'
    owner_id = request.args.get('id')
    if (request.method == 'GET'):
        if (owner_id == None):
            response = requests.get(url)
        else:
            params = {'id': owner_id}
            response = requests.get(url, data=params)
    return response.json(), response.status_code

# ------------------ REVIEW ------------------

@app.route(appendurl + 'review', methods=['GET', 'POST', 'DELETE', 'PUT'])
def get_all_reviews():
    url = f'http://{review_ip}:{review_port}/api/v1/reviews'
    print(url)
    if (request.method == 'GET'):
        reviewid = request.args.get('reviewid')
        personid = request.args.get('personid')
        trip_id = request.args.get('trip_id')
        if (trip_id != None):
            entry = get_review_id(trip_id)
            if (entry == None):
                return jsonify({'error': 'review not found'}), 404
            else:
                print(entry)
                return jsonify(entry), 200
        # get in http:{ip}:5005/api/v1/review?reviewid=1&personid=1
        if (reviewid == None and personid == None):
            response = requests.get(url)
        elif (reviewid == None and personid != None):
            params = {'personid': personid}
            response = requests.get(url, params=params)
        elif (personid == None and reviewid != None):
            params = {'reviewid': reviewid}
            response = requests.get(url, params=params)
        else:
            params = {'reviewid': reviewid, 'personid': personid}
            response = requests.get(url, params=params)
    elif (request.method == 'POST'):
        try:
            print(request.json)
            personid = request.json.get('person_id')
            title = request.json.get('title')
            description = request.json.get('description')
            rating = request.json.get('rating')
        except Exception as e:
            print(e)
            return jsonify({'error': 'personid, title, description, rating are required'}), 400

        data = {'personid': personid, 'title': title, 'description': description, 'rating': rating}
        response = requests.post(url, data=data)
        
    return response.json(), response.status_code


@app.route(appendurl+'/review/rating/', methods=['GET'])
def rating_reviews():
    if request.method == 'GET':
        url = f'http://{review_ip}:{review_port}/api/v1/reviews/rating'
        personid = request.args.get('personid')
        if personid == None:
            response = requests.get(url)
        else:
            params = {'personid': personid}
            response = requests.get(url, params=params)

    return response.json(), response.status_code


# -------------------- AUTH --------------------

@app.route(appendurl + 'auth/login', methods=['POST'])
def login():
    if request.method == 'POST':
        url = f'http://{auth_ip_backend}:{auth_port_backend}/login'
        data = request.get_json()
        response = requests.post(url, json=data)
        if response.status_code == 202:
            # get token from response
            token = response.json()['token']
            # create a new header with the token
            headers = {
                "x-access-token": token,
                "Content-Type": "application/json"
            }
            # send the new header to the info endpoint
            url = f'http://{auth_ip_backend}:{auth_port_backend}/info'
            response1 = requests.post(url, headers=headers)
            authid = response1.json()['id']
            email = response1.json()['email']
            print(authid)
            entry = get_entry(str(authid))
            if entry == None:
                url = f'http://{chat_ip}:{chat_port}/new_user?identity={email}'
                response2 = requests.post(url)
                jsonresponse = response2.json()
                UID = jsonresponse['UID']
                print(UID)
                # random id for reviewid int
                reviewid = 0
                while(check_free_review_id(reviewid) == False):
                    reviewid += 1
                    print(reviewid)
                uidTRIP = str(uuid.uuid4())
                print(create_full_entry(str(authid), str(UID),reviewid,str(uidTRIP)))
                print("authid: " + str(authid) + " UID: " + str(UID) + " reviewid: " + str(reviewid) + " TRIPID: " + uidTRIP)

            # print entry
            print(get_entry(str(authid)))
            

    return response.json(), response.status_code

@app.route(appendurl + 'auth/register', methods=['POST'])
def register():
    if request.method == 'POST':
        url = f'http://{auth_ip_backend}:{auth_port_backend}/register'
        data = request.get_json()
        response = requests.post(url, json=data)
        print(data)
    return response.json(), response.status_code

@app.route(appendurl + 'auth/auth', methods=['POST', 'GET'])
def auth():
    # get token from header
    print("AUTH/AUTH")
    if request.method == 'POST':
        url = f'http://{auth_ip_backend}:{auth_port_backend}/auth'
        headers = request.headers
        response = requests.post(url, headers=headers)
        print(response.json())
    else:
        print("YOU?RE HERE")
    return response.json(), response.status_code
        

@app.route(appendurl + 'auth/info', methods=['POST'])
def info():
    # get token from header
    if request.method == 'POST':
        url = f'http://{auth_ip_backend}:{auth_port_backend}/info'
        headers = request.headers
        response = requests.post(url, headers=headers)
        print(response.json())
    return response.json(), response.status_code

@app.route(appendurl + 'auth/github')
def github():
    url = f'http://{auth_ip_backend}:{auth_port_backend}/github'
    if request.method == 'GET':
        return redirect(url)

@app.route(appendurl + 'auth/fetchdata', methods=['POST'])
def fetchdata():
    # get authid from request from body
    authid = request.get_json()['auth_id']
    email = request.get_json()['email']
    print(authid)
    print(email)
    entry = get_entry(str(authid))
    try:
        if entry == None:
            url = f'http://{chat_ip}:{chat_port}/new_user?identity={email}'
            response2 = requests.post(url)
            jsonresponse = response2.json()
            UID = jsonresponse['UID']
            print(UID)
            # random id for reviewid int
            reviewid = 0
            while(check_free_review_id(reviewid) == False):
                reviewid += 1
                print(reviewid)
            uidTRIP = str(uuid.uuid4())
            
            print(create_full_entry(str(authid), str(UID),reviewid,str(uidTRIP)))
            print("authid: " + str(authid) + " UID: " + str(UID) + " reviewid: " + str(reviewid))

        # print entry
        print(get_entry(str(authid)))
    except Exception as e:
        print(e)
        print("\n\n\n\nBIG ERROR\n\n\n\n")
        return {"authid": authid, "chat": "error", "reviewid": "error"}, 400
    # entry to json
    entry = get_entry(str(authid))
    print(entry)
    return jsonify({"authid": entry[0], "chat_id": entry[1], "reviewid": entry[2] , "trip_id": entry[3] }), 200

@app.route(appendurl + 'auth/google', methods=['GET'])
def google():
    url = f'http://{auth_ip_backend}:{auth_port_backend}/google'
    if request.method == 'GET':
        return redirect(url)
    #     response = requests.get(url)

    # # response is a redirect to google like this:
    # # https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=...
    # # so we need to redirect to that url

    # return redirect(response.url)

@app.route("/webdiv", methods=['GET'])
def webdiv():
    return render_template('login.html')



# ------------------ CHAT ------------------
@app.route(appendurl + '/conversations', methods=['POST','GET','DELETE'])
def conversations():
    if request.method == 'POST':
        f_name=request.args.get("f_name")
        author=request.args.get("author")
        message=request.args.get("message")
        member=request.args.get("member")
        if author == None and message == None:
            url=f'http://{chat_ip}:{chat_port}/conversations?f_name={f_name}&member={member}'
        elif member == None:
            url=f'http://{chat_ip}:{chat_port}/conversations?f_name={f_name}&author={author}&message={message}'
        response = requests.post(url)
        print(response.json())
    elif request.method == 'GET':
        #get conversations of one user
        
        author=request.args.get("author")
        url=f'http://{chat_ip}:{chat_port}/conversations?author={author}'
        response = requests.get(url)
        print(response.json())
    elif request.method == 'DELETE':
        #delete conversation
        f_name=request.args.get("f_name")
        member=request.args.get("member")
        if member == None:
            url=f'http://{chat_ip}:{chat_port}/conversations?f_name={f_name}'
        else:
            url=f'http://{chat_ip}:{chat_port}/conversations?f_name={f_name}&member={member}'
        response = requests.delete(url)
        print("delete")
    return jsonify(response.json()), response.status_code

@app.route(appendurl + '/new_conversation', methods=['POST'])
def new_conversation():
    if request.method == 'POST':
        friendly_name=request.args.get("friendly_name")
        url=f'http://{chat_ip}:{chat_port}/new_conversation?friendly_name={friendly_name}'
        response=requests.post(url)

    return jsonify(response.json()), response.status_code


# ------------------ PAYMENT ------------------
@app.route('/paypal/create', methods=['POST'])
def create_order():
    print("hello")
    url = f'http://{payment_ip}:{payment_port}/paypal/create/order'
    data = request.get_json()  # Extract the request body as JSON
    print(data)
    
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, json=data, headers=headers)
    return response.json(), response.status_code
    

@app.route('/paypal/capture', methods=['POST'])
def capture_order():
    url = f'http://{payment_ip}:{payment_port}/paypal/capture/order'
    data = request.get_json()  # Extract the request body as JSON
    print(data)
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, json=data, headers=headers)
    return response.json(), response.status_code

if __name__ == "__main__":
    app.run(host='0.0.0.0',debug=True, port=8080)