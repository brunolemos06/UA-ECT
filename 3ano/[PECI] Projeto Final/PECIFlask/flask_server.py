from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

ppg_value = 0

def update_ppg_value(value):
    global ppg_value
    ppg_value = value

# This is the route that will be called by the client
@app.route('/', methods=['GET'])
def index():
    return jsonify({"message": "Hello World"})

@app.route('/api/postppg', methods=['POST'])
def postppg():
    data = request.get_json()
    print(data)
    update_ppg_value(data['num_people'])
    return data

@app.route('/api/getppg', methods=['GET'])
def getppg():
    global ppg_value
    print(ppg_value)
    return jsonify({"num_people": ppg_value})

#start app
if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5005, debug=True)
