from flask import Flask, request, jsonify
from flask_cors import CORS
import json
from werkzeug.utils import secure_filename

#create a flask app
app = Flask(__name__)
CORS(app)

#create a route for the app
@app.route('/api/main_cars', methods=['GET'])
def home():
    #import json from ../src/database/cars.json and return it
    with open('./database/cars.json') as json_file:
        data = json.load(json_file)
        print("fetched cars from database")
        return jsonify(data)

@app.route('/api/agent_cars', methods=['GET'])
def agent_cars():
    with open('./database/agent_cars.json') as json_file:
        data = json.load(json_file)
        print("fetched agent cars from database")
        return jsonify(data)

@app.route('/api/sellcar', methods=['POST'])
def sellcar():
    #get the data from the request
    file = request.files['image']
    filename = secure_filename(file.filename)
    destination = "../src/images/" + filename
    file.save(destination)
    print("saved image to images folder")
    data = request.form
    print("got data from request")
    #import the data from the request and save it to the database
    with open('./database/cars.json') as json_file:
        cars = json.load(json_file)
        last_id = 1
        for car in cars:
            if int(car) > last_id:
                last_id = int(car)

        new_car_key = last_id + 1


        #add to the end of json cars file data from the request
        cars.update({new_car_key+1 : {"marca": data['brand'], "modelo": data['model'], "ano": data['year'], "preco": data['price'], "kms" : data['kms'], "imagem": filename}})
        print("added car to database")
        with open('./database/cars.json', 'w') as outfile:
            json.dump(cars, outfile)
            print("saved database")

    #do the same but also for the profile_cars.json file
    with open('./database/profile_cars.json') as json_file:
        profile_cars = json.load(json_file)
        
        last_id = 1
        for car in profile_cars:
            if int(car) > last_id:
                last_id = int(car)

        new_car_key = last_id + 1

        profile_cars.update({new_car_key+1 : {"marca": data['brand'], "modelo": data['model'], "ano": data['year'], "preco": data['price'], "kms" : data['kms'], "imagem": filename}})
        print("added car to profile_cars database")
        with open('./database/profile_cars.json', 'w') as outfile:
            json.dump(profile_cars, outfile)
            print("saved profile_cars database")

    #do the same but also for the agent_cars.json file
    with open('./database/agent_cars.json') as json_file:
        agent_cars = json.load(json_file)
        
        last_id = 1
        for car in agent_cars:
            if int(car) > last_id:
                last_id = int(car)

        new_car_key = last_id + 1
        agent_cars.update({new_car_key+1 : {"marca": data['brand'], "modelo": data['model'], "ano": data['year'], "preco": data['price'], "kms" : data['kms'], "imagem": filename}})
        print("added car to agent_cars database")
        with open('./database/agent_cars.json', 'w') as outfile:
            json.dump(agent_cars, outfile)
            print("saved agent_cars database")

    return jsonify({"success": True})

@app.route('/api/deletecar', methods=['POST'])
def deletecar():
    #get the data from the request
    data = request.form
    print(data)

    #import the data from the request and delete it from the database
    with open('./database/cars.json') as json_file:
        cars = json.load(json_file)
        
        #delete the car from the database based on the name, model and image name
        for car in cars:
            if cars[car]['marca'] == data['brand'] and cars[car]['modelo'] == data['model'] and cars[car]['imagem'] == data['image']:
                del cars[car]
                print("deleted car from database")
                with open('./database/cars.json', 'w') as outfile:
                    json.dump(cars, outfile)
                    print("saved database")
                break

    #do the same but also for the profile_cars.json file
    with open('./database/profile_cars.json') as json_file:
        profile_cars = json.load(json_file)
        print(len(profile_cars))
        #delete the car from the database based on the name, model and image name
        for car in profile_cars:
            if profile_cars[car]['marca'] == data['brand'] and profile_cars[car]['modelo'] == data['model'] and profile_cars[car]['imagem'] == data['image']:
                del profile_cars[car]
                print("deleted car from profile_cars database")
                with open('./database/profile_cars.json', 'w') as outfile:
                    json.dump(profile_cars, outfile)
                    print("saved profile_cars database")
                break

    #do the same but also for the agent_cars.json file
    with open('./database/agent_cars.json') as json_file:
        agent_cars = json.load(json_file)
        print(len(agent_cars))
        #delete the car from the database based on the name, model and image name
        for car in agent_cars:
            if agent_cars[car]['marca'] == data['brand'] and agent_cars[car]['modelo'] == data['model'] and agent_cars[car]['imagem'] == data['image']:
                del agent_cars[car]
                print("deleted car from agent_cars database")
                with open('./database/agent_cars.json', 'w') as outfile:
                    json.dump(agent_cars, outfile)
                    print("saved agent_cars database")
                break

    return jsonify({"success": True})

@app.route('/api/profile_cars', methods=['GET'])
def profile_cars():
    with open('./database/profile_cars.json') as json_file:
        data = json.load(json_file)
        print("fetched profile cars from database")
        return jsonify(data)

#start the app
if __name__ == '__main__':
    app.run(debug=True)