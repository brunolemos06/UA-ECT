import socket
import sys
import psutil
ip_addr = "127.0.0.1"
tcp_port = 5005

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((ip_addr, tcp_port))

while True:
    try: 
        message=input("Want to send info?")
        if message.lower() == "yes" or message.lower() == "ok":
            print("Sending info...")
            data = str(psutil.cpu_percent(interval=1)) + "|" + str(psutil.virtual_memory().percent)
            sock.send(data.encode())
            response = sock.recv(1024).decode()
            print('Server response: {}'.format(response))

    except (socket.timeout, socket.error):
        print('Server error. Done!')
        sys.exit(0)