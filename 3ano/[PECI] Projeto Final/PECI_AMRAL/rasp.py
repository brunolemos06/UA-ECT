import random
import time
import requests

#post request to flask server
def post_request(url, data):
    r = requests.post(url, json=data)
    return r

url = 'http://127.0.0.1:5005/ppg'
data = {'value': '100'}

#function tu update data with random value from 60 to 130
def update_data():
    data['value'] = str(60 + int(60 * (1 + (random.random() - 0.5))))
    post_request(url, data)
    
while True:
    update_data()
    time.sleep(1)