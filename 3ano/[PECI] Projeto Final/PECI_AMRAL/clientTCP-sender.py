import socket
import signal
import sys
import random
from threading import *
import threading
import pickle
import time

def signal_handler(sig, frame):
    print('\nDone!')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
print('Press Ctrl+C to exit...')

message = {'num_people': 0}

# create function to update with random number num_people value in message
def update_message():
    while True:
        message['num_people'] = random.randint(0, 10)
        #print(message['num_people'])
        time.sleep(2)


##

ip_addr = "192.168.160.19"
tcp_port = 5005

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

sock.connect((ip_addr, tcp_port))

def main():
    while True:
        try: 
            pickled_message = pickle.dumps(message)
            sock.send(pickled_message)
            time.sleep(1)
            #print pickled_message decode
            print(pickle.loads(pickled_message))
            # response = sock.recv(4096).decode()
            # print('Server response: {}'.format(response))
        except (socket.timeout, socket.error):
            print('Server error. Done!')
            sys.exit(0)

t1 = threading.Thread(target=main) 
t2 = threading.Thread(target=update_message)

t1.start()

t2.start()

