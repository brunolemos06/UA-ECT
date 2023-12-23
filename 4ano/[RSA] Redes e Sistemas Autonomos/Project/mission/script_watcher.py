import paho.mqtt.client as mqtt
import json
import math
import subprocess
import threading
from sys import argv
from time import sleep
import requests

mac_addresses = {1:"6e:06:e0:03:00:01", 2:"6e:06:e0:03:00:02", 3:"6e:06:e0:03:00:03", 4:"6e:06:e0:03:00:99"}
boats_positions = {4: { 'now' : (0, 0), 'next' : (0, 0)}}
max_distance = float(argv[1])
coms = [ [2, 1, 1, 1]
        ,[1, 2, 1, 1]
        ,[1, 1, 2, 1]
        ,[1, 1, 1, 2] ]

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("vanetza/out/cam")
    # client.subscribe("vanetza/out/denm")
    # client.subscribe("vanetza/out/cpm")

def on_message(client, userdata, msg):
    on_message = json.loads(msg.payload.decode("utf-8"))
    if "cam" in msg.topic:
        if on_message["stationType"] == 3:
            sender_id = read_boats_positions(on_message)
            dynamic_vanetza(sender_id)

def read_boats_positions(msg):
    if msg["accEngaged"] == True and msg["stationType"] == 3:
        sender_position = (msg["latitude"], msg["longitude"])
        sender_id = msg["stationID"]
        sender_direction = msg["heading"]
        # print("SENDER DIRECTION: "+str(sender_direction))
        global boats_positions
        boats_positions[sender_id] = { 'now' : sender_position, 'next' : predict_boat_position(sender_position, sender_direction)}
        return sender_id

# returns the predicted position for the boat using the direction
def predict_boat_position(position, direction):
    # 1 : (x,y) = (x-1, y+1)
    # 2 : (x,y) = (x, y+1)
    # 3 : (x,y) = (x+1, y+1)
    # 4 : (x,y) = (x-1, y)
    # 5 : (x,y) = (x+1, y)
    # 6 : (x,y) = (x-1, y-1)
    # 7 : (x,y) = (x, y-1)
    # 8 : (x,y) = (x+1, y-1)
    x, y = position
    # print("GOOT CORRD: "+str(position))
    # print("GOOT DIRECTION: "+ str(direction))
    if direction == 1:
        x -= 1
        y += 1
    elif direction == 2:
        y += 1
    elif direction == 3:
        x += 1
        y += 1
    elif direction == 4:
        x -= 1
    elif direction == 5:
        x += 1
    elif direction == 6:
        x -= 1
        y -= 1
    elif direction == 7:
        y -= 1
    elif direction == 8:
        x += 1
        y -= 1
    elif direction == 0 or direction == "UNAVAILABLE":    #doesn't move
        pass
    else:
        raise ValueError("Invalid number, must be between 1 and 8")
    return (x,y)

# returns the distance between two points
def distance_between_points(p1, p2):
    return math.sqrt((p2[0]-p1[0])**2 + (p2[1]-p1[1])**2)

def dynamic_vanetza(key):
    global coms 
    x, y = boats_positions[key]['now']
    for key_target in boats_positions.keys():
        if key != key_target:
            x_target, y_target = boats_positions[key_target]['now']
            if distance_between_points((x,y), (x_target, y_target)) <= max_distance and coms[key-1][key_target-1] == 0:
                unblock("obu"+str(key), mac_addresses[key_target])
                if key_target != 4:
                    unblock("obu"+str(key_target), mac_addresses[key])
                else:
                    unblock("rsu", mac_addresses[key])
                coms[key-1][key_target-1] = 1
                coms[key_target-1][key-1] = 1
            elif distance_between_points((x,y), (x_target, y_target)) > max_distance and coms[key-1][key_target-1] == 1:
                block("obu"+str(key), mac_addresses[key_target])
                if key_target != 4:
                    block("obu"+str(key_target), mac_addresses[key])
                else:
                    block("rsu", mac_addresses[key])
                coms[key-1][key_target-1] = 0
                coms[key_target-1][key-1] = 0
            else:
                pass
    json_data = json.dumps(coms)
    headers = {'Content-Type': 'application/json'}
    # Send the request with the JSON-encoded data
    response = requests.post('http://localhost:8080/perimeter', headers=headers, json=json_data)
    
# subfunction to block vanetza from one boat to another         
def block(name, mac):
    command = f'cd ../docker ; docker compose exec {name} block {mac}'
    try:
        subprocess.run(command, shell=True, check=True)
        print("OBU"+name+" blocked mac: "+mac) 
    except subprocess.CalledProcessError as e:
        print(f"Error executing Docker Compose command: {e}")

# subfunction to unblock vanetza from one boat to another
def unblock(name, mac):
    command = f'cd ../docker ; docker compose exec {name} unblock {mac}'
    try:
        subprocess.run(command, shell=True, check=True)
        print("OBU"+name+" unblocked mac: "+mac) 
    except subprocess.CalledProcessError as e:
        print(f"Error executing Docker Compose command: {e}")

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("192.168.98.90", 1883, 60)

thread = threading.Thread(target=client.loop_forever).start()
