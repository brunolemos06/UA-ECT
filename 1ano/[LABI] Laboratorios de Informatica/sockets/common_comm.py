import socket
import json
import base64
from Crypto.Hash import SHA256
from Crypto.Cipher import AES
#
# Universal function to send a given amount of data to a TCP socket.
# It returns True or False, depending of the success on sending all
# the data to the socket.
#
def exact_send( dst, data ):
    try:
        while len(data) != 0:
            bytes_sent = dst.send( data )
            data = data[bytes_sent : ]
            return True
    except OSError:
        return False
#
# Universal function to receive a given amount of data from a TCP socket.
# It returns None or data, depending of the success on receiving all
# the required data from the socket.
#
def exact_recv( src, count ):
    data = bytearray( 0 )
    while count != 0:
        new_data = src.recv( count )
        if len(new_data) == 0:
            return None
        data += new_data
        count -= len(new_data)
    return data
#
# Universal function to send a dictionary message to a TCP socket.
# It actually transmits a JSON object, prefixed by its length (in
# network byte order).
# The JSON object is created from the dictionary.
# It returns True or False, depending of the success on sending the
# message to the socket.
#
def send_dict( dst, msg ):
    #DEBUG print( 'Send: %s' % (msg) )
    data = bytes(json.dumps( msg ), 'utf8')
    prefixed_data = len(data).to_bytes( 4, 'big' ) + data
    return exact_send( dst, prefixed_data )
#
# Universal function to receive a dictionary message from a TCP socket.
# It actually receives a JSON object, prefixed by its length (in network byte order).
# The dictionary is created from that JSON object.
#
def recv_dict( src ):
    prefix = exact_recv( src, 4 )
    if prefix == None:
        return None
    length = int.from_bytes( prefix, 'big' )
    data = exact_recv( src, length )
    if data == None:
        return None
    msg = json.loads( str(data, 'utf8') )
    # DEBUG print( 'Recv: %s' % (msg) )
    return msg
#
# Universal function to send and receive a dictionary to/from a TCP socket peer.
# It returns None upon an error.
#
def sendrecv_dict( peer, msg ):
    if send_dict( peer, msg ) == True:
        return recv_dict( peer )
    else:
        return None
#
# Convert bytes into a string
#
def bytes_to_string(s):
    return "".join(map(chr, base64.b64encode(s)));
    
#
#convert string to bytes
#
def string_to_bytes(s):
        return base64.b64decode(bytes(s,'utf-8'))
#
# Create a digest from two strings C and K
#        
def digest(C,K):
    hash_f = SHA256.new()
    hash_f.update( C )
    hash_f.update( K )
    return hash_f.digest()
#Funcao que deve ser utilizada para encriptar com umm chave simetrica
def encriptar(chave, valor, pad):
    crypt = AES.new( chave, AES.MODE_ECB )
    if pad==1:
        _128_bit_padded_index = bytes("%16d" % (valor), 'utf8')
        return crypt.encrypt( _128_bit_padded_index )
    else:
        return crypt.encrypt( valor )
#Funcao para desencriptar
def desencriptar(chave, valor_encriptado):
    crypt = AES.new( chave, AES.MODE_ECB )
    data = crypt.decrypt( valor_encriptado )
    return data
