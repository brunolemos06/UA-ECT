import json
import paho.mqtt.client as mqtt
import threading
import os
from time import sleep
import sys
import random
import requests

sensor_locations = []
gotten_sensors = []
#args: grid_size, num_sensors, generate_sensors_locations
grid_sizex = int(sys.argv[1])
grid_sizey = int(sys.argv[2])
num_sensors = int(sys.argv[3])
generate_sensors_locations = int(sys.argv[4])

info = {}

def generate_sensor_locations():
    global sensor_locations
    global generate_sensors_locations
    #generate random number between grid_size/2 and grid_size
    # sensor_locations.append((29,0))
    # sensor_locations.append((0,14))
    # sensor_locations.append((29,14))
    # sensor_locations.append((7,14))

    while len(sensor_locations) != num_sensors:
        # generate number between grid_size/2 and grid_size -1
        x = random.randint(0, grid_sizex-1)

        # generate number between grid_size/2 and grid_size -1
        if (x < grid_sizex/2):
            y = random.randint(int(grid_sizey/2), grid_sizey-1)
        else:
            y = random.randint(0, grid_sizey-1)
            
        if (x,y) not in sensor_locations:
            sensor_locations.append((x,y))

    if generate_sensors_locations == 0:
        #sensor_locations = [(27,7), (15,2), (22,11), (22,8), (10,7), (27,4), (17,14), (13,12)]
        #sensor_locations = [(4,14), (0,7), (0,14), (7,8), (25,10), (25,2), (18,14), (26,14)]
        sensor_locations = [(6,14), (9,7),(13,2), (15,12)]

    print("GENERATED LOCATIONS: ", sensor_locations)

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

# Called every time a message is received from the subscribed messages
# If i don't subscribe, do i need this?
def on_message(client, userdata, msg):
    on_message = json.loads(msg.payload.decode('utf-8'))

# sends periodic cpm messages to the boats, with the sensor locations
def send_locations():
    file_path = os.path.abspath("../vanetza/examples/in_cpm.json")
    f = open(file_path)
    m = json.load(f)

    perceivedObjectContainer = []
    objectID = 0
    # write coords_sensor in ../api/sensor.json
    for coords_sensor in sensor_locations:
        obj = {
                "objectID": objectID,
                "timeOfMeasurement": 0,
                "objectConfidence": 0,
                "xDistance": {
                	"value": coords_sensor[0],
                	"confidence": 1
                },
                "yDistance": {
                	"value": coords_sensor[1],
                	"confidence": 1
                },
                "xSpeed": {
                    "value": 0,
                    "confidence": 1
                },
                "ySpeed": {
                    "value": 0,
                    "confidence": 1
                },
                "xAcceleration": {
                    "longitudinalAccelerationValue": 0.0,
                    "longitudinalAccelerationConfidence": 0
                },
                "yAcceleration": {
                    "lateralAccelerationValue": 0.0,
                    "lateralAccelerationConfidence": 0
                },
                "objectRefPoint": 0,
                "classification": [
                    {
                        "confidence": 0,
                        "class": {
                            "vehicle": {
                                "type": 13,             # 13 reserved for future use (in our case, sensor)
                                "confidence": 0
                            }
                        }
                    }
                ]
            }
        objectID += 1
        perceivedObjectContainer.append(obj)

    m["cpmParameters"]["numberOfPerceivedObjects"] = len(perceivedObjectContainer)
    m["cpmParameters"]["perceivedObjectContainer"] = perceivedObjectContainer
    m["cpmParameters"]["managementContainer"]["stationType"] = 15   # 15 is for BS
    m = json.dumps(m)
    client.publish("vanetza/in/cpm", m)
    f.close()
    sleep(2)

### SENSORS COMNS ###

def on_connectSensor(clientSensor, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    clientSensor.subscribe("got_sensors/#")

def on_messageSensor(clientSensor, userdata, msg):
    on_message = json.loads(msg.payload.decode("utf-8"))

    if "got_sensors" in msg.topic:
        process_sensors(on_message, msg.topic.split("/")[1])

def process_sensors(msg, boat_id):
    #message is a list of dicts if status in dict is 1, then it's a sensor that has been picked and we ignore it
    print("GOT SENSOR FROM BOAT"+ boat_id)
    for sensor in msg["sensors"]: #sensor is a dict
        if "status" not in sensor.keys():
            # STRUCTURE OF SENSOR
            # { "location": [x, y], "type": 0, "info": { "conductivity": 0.0, "temperature": 0.0, "depth": 0.0 } }
            # { "location": [x, y], "type": 1, "info": { "ph": 0.0, "dissolved_oxygen": 0.0, "nutrient_levels": 0.0 } }
            # { "location": [x, y], "type": 2, "info": { "plankton_levels": 0.0 } }
            # { "location": [x, y], "type": 3, "info": { "oxygen": 0.0, "carbon_dioxide": 0.0, "methane": 0.0 } }
            info[tuple(sensor["location"])] = sensor["info"]
            gotten_sensors.append(tuple(sensor["location"]))
            print("GOT SENSOR: "+str(sensor["location"]))

            json_data = sensor["info"]
            json_data["sensor"] = tuple(sensor["location"])

            headers = {'Content-Type': 'application/json'}
            # Send the request with the JSON-encoded data
            response = requests.post('http://localhost:8080/info', headers=headers, json=json_data)
    print("GOT: "+str(len(gotten_sensors)))
    print("LOC: "+str(len(sensor_locations)))



### CLIENT FOR VANETZA ###
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("192.168.98.99", 1883, 60)
threading.Thread(target=client.loop_forever).start()

### CLIENT FOR SENSORS ###
clientSensor = mqtt.Client()
clientSensor.on_connect = on_connectSensor
clientSensor.on_message = on_messageSensor
clientSensor.connect("192.168.98.1", 1883, 60)
threading.Thread(target=clientSensor.loop_forever).start()

generate_sensor_locations()
i = 0
while True:
    if i < 10:
        send_locations()
        i+=1
    if len(sensor_locations) == len(gotten_sensors):
        #write info in info.json
        f = open("info.json", "w")
        #transform info keys to string
        info = {str(key): value for key, value in info.items()}
        json_data = json.dumps(info, indent=2)
        f.write(json_data)
        f.close()
        break
