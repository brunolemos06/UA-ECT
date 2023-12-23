import json
import paho.mqtt.client as mqtt
import threading
import random
import sys

#TYPES OF SENSORS:
# 0: CTD (Conductivity, Temperature, and Depth)
# 1: Water Sampler (pH, Dissolved Oxygen, Nutrient Levels)
# 2: Plankton Samplers (Plankton Levels)
# 3: Dissolved Gas Sensors (Oxygen, Carbon Dioxide, Methane)

#INFO STRUCTURE JSON:
#info: { "conductivity": 0.0, "temperature": 0.0, "depth": 0.0 } }
#info: { "ph": 0.0, "dissolved_oxygen": 0.0, "nutrient_levels": 0.0 } }
#info: { "plankton_levels": 0.0 } }
#info: { "oxygen": 0.0, "carbon_dioxide": 0.0, "methane": 0.0 } }

sensor_status = {}  # {(x, y): status} status = {0: not collected, 1: collected}  

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("request_sensors/#")       # FOR RECEIVING REQUESTS FOR SENSOR LOCATIONS FROM BOATS

def on_message(client, userdata, msg):
    on_message = json.loads(msg.payload.decode("utf-8"))

    if "request_sensors" in msg.topic:
        reply_sensors(client, on_message)


# REQ_SENSORS MESSAGE STRUCTURE:
# { "location": (x, y) }
# REPLIES WITH:
# { "location": (x, y), "type": 0, "info": { "conductivity": 0.0, "temperature": 0.0, "depth": 0.0 } }
# { "location": (x, y), "type": 1, "info": { "ph": 0.0, "dissolved_oxygen": 0.0, "nutrient_levels": 0.0 } }
# { "location": (x, y), "type": 2, "info": { "plankton_levels": 0.0 } }
# { "location": (x, y), "type": 3, "info": { "oxygen": 0.0, "carbon_dioxide": 0.0, "methane": 0.0 } }
# { "location": (x, y), "status": 1 }   already collected
def reply_sensors(client, msg):
    loc = tuple(msg["location"])
    if loc not in sensor_status.keys():
        sensor_status[loc] = 1
        type, info = generate_sensor_info()
        reply = {
            "location": loc,
            "type": type,
            "info": info
        }
        print("REPLIED SENSOR: "+ str(loc) + " FROM: "+ str(msg["id"]))
    else:
        reply = {
            "location": loc,
            "status": 1
        }
        print("DUPPED REQUEST: "+ str(loc) + " FROM: "+ str(msg["id"]))
    
    # topic = "rep_sensors/" + str(loc[0]) + "" + str(loc[1])
    client.publish("reply_sensors/" + str(loc[0]) + "" + str(loc[1]), json.dumps(reply))

# function to generate sensor type and info
def generate_sensor_info():
    # generate random number between 0 and 3
    sensor_type = random.randint(0, 3)
    #generate info based on sensor type
    if sensor_type == 0:
        info = {
            "conductivity": random.uniform(0.0, 1.0),
            "temperature": random.uniform(0.0, 1.0),
            "depth": random.uniform(0.0, 1.0)
        }
    elif sensor_type == 1:
        info = {
            "ph": random.uniform(0.0, 1.0),
            "dissolved_oxygen": random.uniform(0.0, 1.0),
            "nutrient_levels": random.uniform(0.0, 1.0)
        }
    elif sensor_type == 2:
        info = {
            "plankton_levels": random.uniform(0.0, 1.0)
        }
    elif sensor_type == 3:
        info = {
            "oxygen": random.uniform(0.0, 1.0),
            "carbon_dioxide": random.uniform(0.0, 1.0),
            "methane": random.uniform(0.0, 1.0)
        }
    return sensor_type, info

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(sys.argv[1], 1883, 60)

threading.Thread(target=client.loop_forever).start()