import socket
import signal
import sys
import pickle
import requests

#post request to flask server
def post_request(url, data):
    r = requests.post(url, json=data)
    return r

url = 'http://127.0.0.1:5005/api/postppg'

def signal_handler(sig, frame):
    print('\nDone!')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
print('Press Ctrl+C to exit...')

##

ip_addr = "192.168.160.19"
tcp_port = 5005

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

sock.connect((ip_addr, tcp_port))

while True:
    try: 
        response = sock.recv(4096)
        dict_response = pickle.loads(response)
        print('Server response: {}'.format(dict_response))
        post_request(url, dict_response)
            
    except (socket.timeout, socket.error):
        print('Server error. Done!')
        sys.exit(0)

