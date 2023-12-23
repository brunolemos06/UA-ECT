import json
import paho.mqtt.client as mqtt
import threading
import os
from time import sleep
import sys
import math
import requests

sensor_locations = []
available_sensors = []
picked_sensor = None
unavailable_sensors = []
who_sent_unavailable_sensors = {} # dict with key = (x,y), value = boat_id (who sent the unavailable sensor)
got_sensors = []
requested_sensor = False  # true if we requested a sensor and we are waiting for the info, false otherwise


first_pick = True   # true for first time they pick a sensor
going_home = False  # set to true if there are no other sensor available
boats_positions = {}    # dict with key = boat_id, value = boat_position (x,y)
my_position = (int(sys.argv[5]), int(sys.argv[6])) # (x,y) (latitude, longitude)
initial_position = (int(sys.argv[5]), int(sys.argv[6]))

my_id = int(sys.argv[1])
grid_x = int(sys.argv[3])
grid_y = int(sys.argv[4])

sleep_time = 1

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("vanetza/out/cam")
    client.subscribe("vanetza/out/denm")
    client.subscribe("vanetza/out/cpm")

# Called every time a message is received from the subscribed messages
def on_message(client, userdata, msg):
    on_message = json.loads(msg.payload.decode("utf-8"))

    #print("Topic: " + str(msg.topic))
    #if cpm message, get sensor locations
    #if cam message, update position
    #if denm message, pick sensor
    if "cpm" in msg.topic:
        if on_message["fields"]["cpm"]["cpmParameters"]["managementContainer"]["stationType"] == 5:
            read_unavailable_sensors(on_message)
        else:
            get_sensor_locations(on_message)
    if "cam" in msg.topic:
        # if "accEngaged" in on_message:
        read_boats_positions(on_message)
    elif "denm" in msg.topic:
        pick_sensor_demn(on_message)

# PROCESS/SEND CPM MESSAGES

# process cpm messages from BS to get sensor locations
def get_sensor_locations(msg):
    perceivedObjects = msg["fields"]["cpm"]["cpmParameters"]["perceivedObjectContainer"]    # this is a list of dicts
    for obj in perceivedObjects:
        if (obj["xDistance"]["value"], obj["yDistance"]["value"]) not in sensor_locations:
            sensor_locations.append((obj["xDistance"]["value"], obj["yDistance"]["value"]))
            available_sensors.append((obj["xDistance"]["value"], obj["yDistance"]["value"]))
            # Define the data to be sent in the request body
            data = {'latitude': obj["xDistance"]["value"],'longitude': obj["yDistance"]["value"]}
            
            if not going_home:
                # Convert the data to a JSON-encoded string
                json_data = json.dumps(data)
                # Set the headers for the request
                headers = {'Content-Type': 'application/json'}
                # Send the request with the JSON-encoded data
                response = requests.post('http://localhost:8080/sensor', headers=headers, json=json_data)
                # if response.status_code != 200:
                #     print("Error posting sensor location")
                # else:
                #     print("POST [SENSOR LOCATION]: "+str((obj["xDistance"]["value"], obj["yDistance"]["value"])))

    # print("READ [SENSOR LOCATION ]: "+str(sensor_locations))

    global first_pick
    global picked_sensor
    if first_pick:
        picked_sensor = closest_sensor()
        # print("READ [SENSOR LOCATION ] -> FIRST PICK: "+str(picked_sensor))

        # Convert the data to a JSON-encoded string
        json_data = {
            "latitude": picked_sensor[0],
            "longitude": picked_sensor[1],
            "id": my_id
        }
        # Set the headers for the request
        headers = {'Content-Type': 'application/json'}
        # Send the request with the JSON-encoded data
        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)
        first_pick = False

# process cpm messages from other vehicles to get unavailable sensors
def read_unavailable_sensors(msg):
    global picked_sensor
    perceivedObjects = msg["fields"]["cpm"]["cpmParameters"]["perceivedObjectContainer"]    # this is a list of dicts
    already_picked = False
    for obj in perceivedObjects:
        if ((obj["xDistance"]["value"], obj["yDistance"]["value"]) in available_sensors): #and ((obj["xDistance"]["value"], obj["yDistance"]["value"]) not in unavailable_sensors):
            #remove from available sensors and add to unavailable sensors
            available_sensors.remove((obj["xDistance"]["value"], obj["yDistance"]["value"]))

        if ((obj["xDistance"]["value"], obj["yDistance"]["value"]) not in unavailable_sensors):
            unavailable_sensors.append((obj["xDistance"]["value"], obj["yDistance"]["value"]))
            who_sent_unavailable_sensors[(obj["xDistance"]["value"], obj["yDistance"]["value"])] = obj["classification"][0]["class"]["vehicle"]["confidence"]

        if picked_sensor == (obj["xDistance"]["value"], obj["yDistance"]["value"]):
            already_picked = True

    if already_picked and who_sent_unavailable_sensors[picked_sensor] != my_id:
        print("READ [UNAVAILABLE SENSORS FROM BOAT"+ str(msg["stationID"])+" ]: PICKED SENSOR IS UNAVAILABLE: "+str(picked_sensor)+ " FROM BOAT"+ str(who_sent_unavailable_sensors[picked_sensor]))
        picked_sensor = None
        picked_sensor = closest_sensor()

        json_data = {
            "latitude": picked_sensor[0],
            "longitude": picked_sensor[1],
            "id": my_id
        }
        # Set the headers for the request
        headers = {'Content-Type': 'application/json'}
        # Send the request with the JSON-encoded data
        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)

    print("PROCESS [ UNAVAILABLE SENSORS FROM BOAT"+ str(msg["stationID"])+" ]: "+str(unavailable_sensors))

# sends periodic cpm messages to other vehicles, which contain the unavailable sensors
def announce_unavailable_sensors():
    file_path = os.path.abspath("../vanetza/examples/in_cpm.json")
    f = open(file_path)
    m = json.load(f)

    perceivedObjectContainer = []
    objectID = 0
    # write coords_sensor in ../api/sensor.json
    

    for coords_sensor in unavailable_sensors:
        obj = {
                "objectID": objectID, #who_sent_unavailable_sensors[coords_sensor]*1000 + objectID,
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
                                "confidence": who_sent_unavailable_sensors[coords_sensor]
                            }
                        }
                    }
                ]
            }
        objectID += 1
        perceivedObjectContainer.append(obj)

    m["cpmParameters"]["numberOfPerceivedObjects"] = objectID
    m["cpmParameters"]["perceivedObjectContainer"] = perceivedObjectContainer
    m["cpmParameters"]["managementContainer"]["stationType"] = 5   # 5 is for boat

    print("SEND [ ANNOUCE UNAVAILABLE SENSORS ]: "+str(unavailable_sensors))
    m = json.dumps(m)
    client.publish("vanetza/in/cpm", m)
    f.close()
    sleep(sleep_time)

# PROCESS/SEND CAM MESSAGES

# processes cam messages from other vehicles
def read_boats_positions(msg):
    if (msg["stationID"] != my_id and msg["accEngaged"] == True and msg["stationType"] == 3):
        sender_position = (msg["latitude"], msg["longitude"])
        sender_id = msg["stationID"]
        sender_direction = msg["heading"]
        global boats_positions
        boats_positions[sender_id] = { 'now' : sender_position, 'next' : predict_boat_position(sender_position, sender_direction)}

        print("PROCESS [BOAT"+str(sender_id)+" POSITION]: ON POSITION: "+str(sender_position)+ " TO POSITION: "+str(predict_boat_position(sender_position, sender_direction)))

# sends periodic cam messages to other vehicles
def update_position():
    #update driving direction and position
    file_path = os.path.abspath("../vanetza/examples/in_cam.json")
    f = open(file_path)
    m = json.load(f)

    #update driving direction
    m["stationType"] = 3    # 3 = boat  
    m["heading"], m["latitude"], m["longitude"]  =  move_boat() # string with vector direction [1,0] ... another way? sensor location?
    m["stationID"] = my_id

    m = json.dumps(m)
    client.publish("vanetza/in/cam", m)
    f.close()

    # print("SEND [MY POSITION] : " + str(my_position))
    sleep(sleep_time)

# PROCESS/SEND DENM MESSAGES

# sends periodic denm messages to other vehicles, which contain the picked sensor
def announce_sensor():
    if picked_sensor == None:
        # print("MSG [ DENM SENSOR ]: No sensor picked")
        return

    file_path = os.path.abspath("../vanetza/examples/in_denm.json")
    f = open(file_path)
    m = json.load(f)

    m["management"]["eventPosition"]["latitude"] = picked_sensor[0]
    m["management"]["eventPosition"]["longitude"] = picked_sensor[1]
    m["situation"]["eventType"]["causeCode"] = 89
    
    m = json.dumps(m)
    client.publish("vanetza/in/denm", m)
    f.close()

    print("SEND [ DENM SENSOR ] : " + str(picked_sensor))
    sleep(sleep_time)

# processes denm messages from other vehicles
# checks if we picked the same sensor, if so:
#   if my_distance < other_boat_distance keep sensor
#   else pick a new sensor
# different sensor, we remove it from the list of available sensors
def pick_sensor_demn(msg):
    global picked_sensor
    if msg["fields"]["denm"]["situation"]["eventType"]["causeCode"] == 89:
        print("DENM FROM BOAT"+str(msg["stationID"]))
        incoming_sensor = (msg["fields"]["denm"]["management"]["eventPosition"]["latitude"], msg["fields"]["denm"]["management"]["eventPosition"]["longitude"])
        from_boat = msg["stationID"]
        if (picked_sensor == None and incoming_sensor in available_sensors):
            available_sensors.remove(incoming_sensor)
            # unavailable_sensors.append(incoming_sensor)
            # who_sent_unavailable_sensors[incoming_sensor] = from_boat
            print("PICK SENSOR [SENSOR REMOVED]: " + str(incoming_sensor))
            return
        
        if incoming_sensor == picked_sensor:
            if from_boat in boats_positions.keys():
                x , y = boats_positions[from_boat]['now']   # if future problems with boats positions is THIS
                if math.sqrt((picked_sensor[0] - my_position[0])**2 + (picked_sensor[1] - my_position[1])**2) < math.sqrt((picked_sensor[0] - x)**2 + (picked_sensor[1] - y)**2):
                    print("PICK SENSOR [KEEP SENSOR]")
                #equal distance check id
                elif math.sqrt((picked_sensor[0] - my_position[0])**2 + (picked_sensor[1] - my_position[1])**2) == math.sqrt((picked_sensor[0] - x)**2 + (picked_sensor[1] - y)**2):
                    if my_id < from_boat:
                        print("PICK SENSOR [KEEP SENSOR]")
                    else:
                        # unavailable_sensors.append(incoming_sensor)
                        # who_sent_unavailable_sensors[incoming_sensor] = from_boat
                        picked_sensor = None
                        picked_sensor = closest_sensor()

                        json_data = {
                            "latitude": picked_sensor[0],
                            "longitude": picked_sensor[1],
                            "id": my_id
                        }

                        # Set the headers for the request
                        headers = {'Content-Type': 'application/json'}
                        # Send the request with the JSON-encoded data
                        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)
                        
                        #announce_sensor()
                        print("PICK SENSOR [PICK NEW SENSOR]: "+str(picked_sensor))
                else:
                    # check if there are available sensors
                    if len(available_sensors) > 0:
                        # unavailable_sensors.append(incoming_sensor)
                        # who_sent_unavailable_sensors[incoming_sensor] = from_boat
                        picked_sensor = None
                        picked_sensor = closest_sensor()

                        json_data = {
                            "latitude": picked_sensor[0],
                            "longitude": picked_sensor[1],
                            "id": my_id
                        }
                        # Set the headers for the request
                        headers = {'Content-Type': 'application/json'}
                        # Send the request with the JSON-encoded data
                        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)

                        #announce_sensor()
                        print("PICK SENSOR [PICK NEW SENSOR]: "+str(picked_sensor))
                    else:
                        picked_sensor = None
                        picked_sensor = closest_sensor()

                        json_data = {
                            "latitude": picked_sensor[0],
                            "longitude": picked_sensor[1],
                            "id": my_id
                        }
                        # Set the headers for the request
                        headers = {'Content-Type': 'application/json'}
                        # Send the request with the JSON-encoded data
                        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)

                        print("PICK SENSOR [NO SENSORS]")

            else:
                print("PICK SENSOR [UNKNOW BOAT LOCATION]")
        elif incoming_sensor in available_sensors:
            available_sensors.remove(incoming_sensor)
            # unavailable_sensors.append(incoming_sensor)
            # who_sent_unavailable_sensors[incoming_sensor] = from_boat
            print("PICK SENSOR [SENSOR REMOVED]: "+str(incoming_sensor))
        

### MOVEMENT FUNCS  ###

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
    
# moves boat to the chosen position
def move_boat():
    global picked_sensor
    global my_position
    global going_home
    if going_home and (my_position == initial_position):
        # print("MOVE BOAT [FINISH]")
        next_pos = my_position
        picked_sensor = None
    elif picked_sensor == my_position and len(available_sensors)==0 and not going_home:
        # print("MOVE_BOAT [ALL SENSORS PICKED]")
        unavailable_sensors.append(picked_sensor)
        who_sent_unavailable_sensors[picked_sensor] = my_id

        request_sensor(picked_sensor)
        while requested_sensor: sleep(sleep_time) # wait for sensor info
        
        picked_sensor = initial_position
        announce_unavailable_sensors()

        going_home = True
        my_position = next_move(my_position)
        next_pos = next_move(my_position)

    elif picked_sensor == my_position and len(available_sensors)>0:
        # print("MOVE_BOAT [GOING TO PICK ANOTHER SENSOR]")
        unavailable_sensors.append(picked_sensor)
        who_sent_unavailable_sensors[picked_sensor] = my_id
    
        request_sensor(picked_sensor)
        while requested_sensor: sleep(sleep_time) # wait for sensor info
        
        picked_sensor = None
        announce_unavailable_sensors()
        picked_sensor = closest_sensor()

        json_data = {
            "latitude": picked_sensor[0],
            "longitude": picked_sensor[1],
            "id": my_id
        }
        # Set the headers for the request
        headers = {'Content-Type': 'application/json'}
        # Send the request with the JSON-encoded data
        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)

        my_position = next_move(my_position)
        next_pos = next_move(my_position)
    elif picked_sensor != None :
        my_position = next_move(my_position)
        next_pos = next_move(my_position)
        # print("MOVE_BOAT [NEW POSITION] : " + str(my_position))
    else:
        next_pos = my_position
        # print("MOVE_BOAT [NO SENSOR PICKED]")


    return number_future_position(my_position, next_pos), my_position[0], my_position[1]

# returns the direction of the future boat position
def number_future_position(position, future):
    x1, y1 = position
    x2, y2 = future

    if x2 == x1 and y2 == y1 + 1:
        return 2
    elif x2 == x1 and y2 == y1 - 1:
        return 7
    elif x2 == x1 - 1 and y2 == y1:
        return 4
    elif x2 == x1 + 1 and y2 == y1:
        return 5
    elif x2 == x1 - 1 and y2 == y1 + 1:
        return 1
    elif x2 == x1 + 1 and y2 == y1 + 1:
        return 3
    elif x2 == x1 - 1 and y2 == y1 - 1:
        return 6
    elif x2 == x1 + 1 and y2 == y1 - 1:
        return 8
    elif x2 == x1 and y2 == y1:
        return 0
    else:
        raise ValueError("Invalid coordinates, cannot be transformed")

# uses the actual position and (if possible) tries to find the next one towards the sensor (returns position)
def next_move(my_position):
    pos = future_positions(my_position)
    sorted_coordinates = sorted(pos, key=lambda coord: get_distance(coord[0], coord[1], picked_sensor[0], picked_sensor[1]))
    intersection = False
    for coord in sorted_coordinates:
        intersection = False
        for key in boats_positions.keys():
            x, y = boats_positions[key]['now']
            x1, y1 = boats_positions[key]['next']
            # check if the my next position is the same as at least one boat
            if ((coord[0] == x) and (coord[1] == y)) or ((coord[0] == x1) and (coord[1] == y1)):
                intersection = True
                break

        if not intersection:
            return coord
    
    return my_position

# retuns all posible future positions for the boat (8 positions)
def future_positions(position):
    x, y = position
    possible = [(x-1, y+1), (x, y+1), (x+1, y+1), (x-1, y), (x+1, y), (x-1, y-1), (x, y-1), (x+1, y-1), (x,y)]
    for pos in possible:
        if pos[0] < 0 or pos[0] > grid_x or pos[1] < 0 or pos[1] > grid_y:
            possible.remove(pos)
    return possible
   
# calculates the Euclidean distance between two points
def get_distance(x1, y1, x2, y2):
    return math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

# picks a sensor from the available sensors, based on the closest one to the actual position
def closest_sensor():
    global picked_sensor
    global available_sensors
    global my_position
    global going_home
    if len(available_sensors) > 0:
        if (picked_sensor == None):
            picked_sensor = available_sensors[0]

            json_data = {
                "latitude": picked_sensor[0],
                "longitude": picked_sensor[1],
                "id": my_id
            }
            # Set the headers for the request
            headers = {'Content-Type': 'application/json'}
            # Send the request with the JSON-encoded data
            response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)

            # go through the list of available sensors at the position 1 until the end
            for i in range(1, len(available_sensors)):
                # print("PICKED SENSOR : " + str(picked_sensor) + " DISTANCE : " + str(math.sqrt((picked_sensor[0] - my_position[0])**2 + (picked_sensor[1] - my_position[1])**2)))
                # print("AVAILABLE SENSOR : " + str(available_sensors[i]) + " DISTANCE : " + str(math.sqrt((available_sensors[i][0] - my_position[0])**2 + (available_sensors[i][1] - my_position[1])**2)))
                if math.sqrt((available_sensors[i][0] - my_position[0])**2 + (available_sensors[i][1] - my_position[1])**2) < math.sqrt((picked_sensor[0] - my_position[0])**2 + (picked_sensor[1] - my_position[1])**2):
                    picked_sensor = available_sensors[i]

            available_sensors.remove(picked_sensor)

            json_data = {
                "latitude": picked_sensor[0],
                "longitude": picked_sensor[1],
                "id": my_id
            }

            # Set the headers for the request
            headers = {'Content-Type': 'application/json'}

            # Send the request with the JSON-encoded data
            response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)
    else:
        picked_sensor = initial_position
        going_home = True
        print("CLOSEST SENSOR [GOING HOME]:")

    print("CLOSEST SENSOR [PICKED]: "+str(picked_sensor))
    return picked_sensor

### SENSORS COMNS ###

def on_connectSensor(clientSensor, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    clientSensor.subscribe("reply_sensors/#")

def on_messageSensor(clientSensor, userdata, msg):
    global requested_sensor
    global picked_sensor

    on_message = json.loads(msg.payload.decode("utf-8"))

    if requested_sensor and "reply_sensors/{}{}".format(picked_sensor[0], picked_sensor[1]) in msg.topic:
        process_sensor_info(on_message)
        requested_sensor = False

# sends periodic req_sensors messages to the picked sensor
# REQ_SENSORS MESSAGE STRUCTURE:
# { "location": (x, y) }
def request_sensor(picked_sensor):
    global my_id
    global requested_sensor
    requested_sensor = True

    unavailable_sensors.append(picked_sensor)
    who_sent_unavailable_sensors[picked_sensor] = my_id
    
    topic = "request_sensors/{}".format(picked_sensor)
    message = { "location": tuple(picked_sensor) , "id": my_id}

    clientSensor.publish(topic, json.dumps(message))
    # print("REQUEST SENSOR [SENT]: "+str(picked_sensor))

# sends gotten sensors to the base station
def announce_gotten_sensors():
    topic = "got_sensors/{}".format(my_id)
    message = { "sensors": got_sensors }

    clientSensor.publish(topic, json.dumps(message))
    # print("ANNOUNCE GOT SENSORS [SENT TO BS] ")


# processes sensor info messages about the picked sensor (asked sensor)
# SENSOR INFO MESSAGE STRUCTURE:
# { "location": (x, y), "type": 0, "info": { "conductivity": 0.0, "temperature": 0.0, "depth": 0.0 } }
# { "location": (x, y), "type": 1, "info": { "ph": 0.0, "dissolved_oxygen": 0.0, "nutrient_levels": 0.0 } }
# { "location": (x, y), "type": 2, "info": { "plankton_levels": 0.0 } }
# { "location": (x, y), "type": 3, "info": { "oxygen": 0.0, "carbon_dioxide": 0.0, "methane": 0.0 } }
# { "location": (x, y), "status": 1 }   already collected
def process_sensor_info(msg):
    # print("PROCESS SENSOR INFO [RECEIVED]: "+str(msg))
    got_sensors.append(msg)

# prints the status of the boat
def print_status():
    print("\n\n-------------------------- STATUS --------------------------")
    print("SENSOR INFO:")
    print("Sensor locations: " + str(sensor_locations))
    print("Available sensors: " + str(available_sensors))
    print("Unavailable sensors: " + str(unavailable_sensors))
    print("Sent unavailable sensors: " + str(who_sent_unavailable_sensors))
    print("\nMY INFO:")
    print("Picked sensor: " + str(picked_sensor))
    print("My position: " + str(my_position))
    print("\nBOATS INFO")
    print("Boats positions: " + str(boats_positions))
    print("-----------------------------------------------------------\n\n")
    sleep(sleep_time)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(sys.argv[2], 1883, 60)
threading.Thread(target=client.loop_forever).start()

clientSensor = mqtt.Client()
clientSensor.on_connect = on_connectSensor
clientSensor.on_message = on_messageSensor
clientSensor.connect("192.168.98.1", 1883, 60)
threading.Thread(target=clientSensor.loop_forever).start()

can_announce_gotten_sensors = True
while True:
    if picked_sensor != None and (not going_home) and not first_pick:
        announce_sensor()
    if len(unavailable_sensors) > 0:
        announce_unavailable_sensors()
    update_position()
    print_status()

    if going_home:
        json_data = {
            "latitude":  -1,
            "longitude": -1,
            "id": my_id
        }
        # Set the headers for the request
        headers = {'Content-Type': 'application/json'}
        # Send the request with the JSON-encoded data
        response = requests.post('http://localhost:8080/pickedsensor', headers=headers, json=json_data)

    if going_home and (my_position == initial_position) and can_announce_gotten_sensors:
        announce_gotten_sensors()
        can_announce_gotten_sensors = False