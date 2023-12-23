from flask import Flask , request
import paho.mqtt.client as mqtt
import json
from time import sleep
from flask_cors import CORS, cross_origin
# cors = CORS(app, resources={r"/api/*": {"origins": "*"}})
app = Flask(__name__)

boat = {}
sensor = []
coms = []
picked_sensor = {}
info = {}

#cors
cors = CORS(app)
@app.route('/')
def index():
    return "Flask MQTT Subscriber is running!"


@app.route('/boat')
def boat_location():
    return json.dumps(boat), 200, {'ContentType':'application/json'}

@app.route('/sensor')
def sensor_location():
    return json.dumps(sensor), 200, {'ContentType':'application/json'}

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("vanetza/out/cam")
    client.subscribe("vanetza/out/denm")
    print_status()


def on_message(client, userdata, msg):
    on_message = json.loads(msg.payload.decode("utf-8"))
    if "cpm" in msg.topic:
        print("Topic: " + msg.topic)
        new_get_sensor_locations(on_message)
    if "cam" in msg.topic:
        if "accEngaged" in on_message:
            read_boats_positions(on_message)
        # print("cpm")
    if "denm" in msg.topic:
        print("denm:")
        # print content of denm message
        get_sensor_locations(on_message)


def new_get_sensor_locations(on_message):
    print ("NEW GET SENSOR LOCATIONS")
    pass
# process cpm messages from BS to get sensor locations
def get_sensor_locations(msg):
    return
    print("GET SENSOR LOCATIONS")
    global sensor
    latitude = msg["fields"]["denm"]["management"]["eventPosition"]["latitude"]
    longitude = msg["fields"]["denm"]["management"]["eventPosition"]["longitude"]
    if (latitude, longitude) not in sensor:
        sensor.append((latitude, longitude))


def print_status():
    # print("Boats: " + str(boat))
    print("Sensors: " + str(sensor))
    # print("\n")
    pass


def read_boats_positions(msg):
    global boat
    if (msg["accEngaged"] == True and msg["stationType"] == 3):
        sender_position = (msg["latitude"], msg["longitude"])
        sender_id = msg["stationID"]
        boat[sender_id] = sender_position
        print_status()

        # print_status()

# post sensor locations
@app.route('/sensor', methods=['POST'])
def post_sensor_locations():
    # post sensor locations
    data = request.get_json()
    print (data)
    data = json.loads(data)
    latitude = data["latitude"]
    longitude = data["longitude"]

    if (latitude, longitude) not in sensor:
        sensor.append((latitude, longitude))
        return "OK", 200, {'ContentType':'application/json'}
    else:
        return "Already exists", 200, {'ContentType':'application/json'}

    
@app.route('/perimeter', methods=['POST'])
def post_perimeter():
    global coms
    try:
        data = request.get_json()
        coms = json.loads(data)
        return json.dumps(coms), 200, {'ContentType': 'application/json'}
    except:
        return "Error", 400, {'ContentType': 'application/json'}

@app.route('/perimeter', methods=['GET'])
def get_perimeter():
    global coms
    return json.dumps(coms), 200, {'ContentType':'application/json'}

@app.route('/reset', methods=['GET'])
def reset():
    global coms, sensor, boat
    boat = {}
    sensor = []
    coms = []
    jsonresponse = {"status": "OK"}
    return json.dumps(jsonresponse), 200, {'ContentType':'application/json'}


@app.route('/pickedsensor', methods=['POST'])
def post_pickedsensor():
    #     json_data = {
    #     "latitude": picked_sensor[0],
    #     "longitude": picked_sensor[1]
    #     "id": my_id
    # }
    global picked_sensor
    try:
        data = request.get_json()
        latitude = data["latitude"]
        longitude = data["longitude"]
        picked_sensor[data["id"]] = (latitude, longitude)
        return json.dumps(picked_sensor), 200, {'ContentType': 'application/json'}
    except:
        return "Error", 400, {'ContentType': 'application/json'}

@app.route('/pickedsensor', methods=['GET'])
def get_pickedsensor():
    global picked_sensor
    # return the picked sensor but find the id with location
    jsonresponse = {}
    for key, value in picked_sensor.items():
        print(key, value)
        if value == (-1,-1): 
            jsonresponse[key] = -1
        else:
            try:
                jsonresponse[key] = sensor.index(value)
            except:
                jsonresponse[key] = -1

    return json.dumps(jsonresponse), 200, {'ContentType':'application/json'}

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("192.168.98.90", 1883, 60)

client.loop_start()


@app.route('/info', methods=['GET'])
def get_info():
    global info
    return json.dumps(info), 200, {'ContentType':'application/json'}

@app.route('/info', methods=['POST'])
def post_info():
    global info
    try:
        data = request.get_json()
        print(data)
        sensor = data['sensor']
        if 'conductivity' in data:
            conductivity = data['conductivity']
            temperature = data['temperature']
            depth = data['depth']
            newdata = {'conductivity': conductivity, 'temperature': temperature, 'depth': depth}
        elif 'ph' in data:
            ph = data['ph']
            dissolved_oxygen = data['dissolved_oxygen']
            nutrient_levels = data['nutrient_levels']
            newdata = {'ph': ph, 'dissolved_oxygen': dissolved_oxygen, 'nutrient_levels': nutrient_levels}
            pass
        elif 'plankton_levels' in data:
            plankton_levels = data['plankton_levels']
            newdata = {'plankton_levels': plankton_levels}
            pass
        elif 'oxygen' in data:
            oxygen = data['oxygen']
            carbon_dioxide = data['carbon_dioxide']
            methane = data['methane']
            newdata = {'oxygen': oxygen, 'carbon_dioxide': carbon_dioxide, 'methane': methane}
            pass
        else:
            return "Error", 400, {'ContentType': 'application/json'}
        

        info[str(sensor)] = newdata

        return json.dumps(info), 200, {'ContentType': 'application/json'}

    except Exception as e:
        print(e)
        return "Error", 404, {'ContentType': 'application/json'}


if __name__ == '__main__':
    app.run(debug=True, port= 8080)
