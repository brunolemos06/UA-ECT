import socket
import threading
import signal
import sys

clients = set()
clients_lock = threading.Lock()

def signal_handler(sig,frame):
	print('\nDone!')
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
print('Press CtrlC to exit...')

def handle_client_connection(client_socket,address):
	print('Accepted conn from {}:{}'.format(address[0], address[1]))
	with clients_lock:
		clients.add(client_socket)
	try:
		while True:
			request = client_socket.recv(1024)
			if not request:
				client_socket.close()
			else:
				msg=request.decode()
				print('Received {}'.format(msg))
				msg = ("ECHO: "+msg).encode()
				with clients_lock:
					for c in clients:
						if c != client_socket:
							c.send(msg)
	finally: 
		print('CLient {} error. DOne!'.format(address))
		with clients_lock:
			clients.remove(client_socket)
			client:socket().close()

ip_addr = '0.0.0.0'
tcp_port = 5005

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((ip_addr, tcp_port))
server.listen(5)

print('Listening on {}:{}'.format(ip_addr,tcp_port))

while True:
	client_sock, address = server.accept()
	client_handler = threading.Thread(target=handle_client_connection, args=(client_sock,address), daemon=True)
	client_handler.start()
