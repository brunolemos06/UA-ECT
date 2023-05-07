#!/usr/bin/python3
import sys
import socket
import select
import json
import base64
from Crypto.Hash import SHA256
from Crypto.Cipher import AES
import csv
from common_comm import send_dict, recv_dict, sendrecv_dict, bytes_to_string, string_to_bytes, desencriptar, encriptar
procs = {}
#
# Handler do pedido de criação de um processo de ordenação
#
def new_process( process_id, sock ):
    if process_id in procs.keys():
        return { 'error':'Sorting process already exists' }
    else:
        procs[process_id] = { 'endpoint': sock, 'ids': {}, 'params': {} } # adicionado o campo param para guardar as 
                                                                          # chaves e parametros utilizados para ordenacao
        return { 'error':'' }
#
# Handler do pedido de inclusão de um novo candidato no processo de ordenação
#
def new_client( process_id, client_id, sock ):
    if process_id in procs:
        proc = procs[process_id]  # Selected sorting process
        if client_id in proc['ids']: # Client already belongs to it?
            return { 'error':'Client already registered in sorting process' }
        else:                        # New client
            proc['ids'][client_id] = { 'endpoint': sock }                                                                        
            return { 'error':'' }
    else:
        return { 'error':'Sorting process no found' }
#
# Handler do pedido de listagem de clientes inscritos num processo de ordenação
#
def list_clients( process_id, sock ):
    if process_id in procs:
        proc = procs[process_id]  # Selected sorting process
        ids = []
        for i in proc['ids']:
            ids.append( i )
        return { 'ids':ids, 'error':'' }
    else:
        return { 'error':'Sorting process no found' }
#
# Handler do pedido de inicio da ordenação
#
def start_sorting( process_id, sock ):
    
    if process_id not in procs.keys():
        return { 'error':'Sorting process not found' }
    else:
        proc = procs[process_id]     # Selected sorting process
        if sock != proc['endpoint']: # Registered address is not the requester
            return { 'error':'Not authorized, you are not the process manager' }
        else:
            return run_sorting( proc )
def clean_proc( process_id ):
    clients = procs[process_id]['ids']
    for c in clients.values():
        c['endpoint'].close()
    del(procs[process_id])
def dump_proc( process_id ):    
    # To be defined 
    return { 'params': procs[process_id]['params'] } #devolve os parametros de cada cliente (inclui ordem e chaves)
def clean_client ( sock ):
    for k,v in procs.items():
        if v['endpoint'] == sock:
            clean_proc ( k )
            return
#
# Processo de ordenação
#
def run_sorting( proc ):    
    # To be defined
    N = len ( proc['ids']) # numero de clientes inscritos
    seq_num = [] # criação de um array para armazenar a sequencia de numeros de ordem
    basedados_encript = proc['params']                                      
    #1. Servidor gera uma sequencia de numeros de ordem (de 1 a N)
    #---------------------------------------------------------------------------------
    for i in range(N):
        seq_num.append( i+1 )
    #3. Envia a sequencia para os participantes um a um e espera pelas sequencias encriptadas    
    format='bytes' #para o primeiro participante indicamos que vai numa lista de inteiros-a lista ainda nao foi encriptada
    for client in proc['ids']:    
        resp = sendrecv_dict( proc['ids'][client]['endpoint'], { 'cmd': 'ENCRIPTAR_SEQ', 'seq_num': seq_num, 'format': format, 'error':'' } )
        if resp['error']!='':
            return { 'error':'Sorting process error: invalid client answer' }
    
        format='string' # indica ao proximo cliente que a sequencia vai no formato string
        seq_num = []
        for i in resp['seq_num_encript']:   
            seq_num.append( i )                 
    
    # 4. O servidor vai enviar para os clientes os números de ordem encriptados N vezes.
    # Para o primeiro cliente manda todos os numeros (N) e ira devolver todos menos o que escolheu
    # Para o seguinte faz a mesma coisa...e por ai adiante
    # O servidor limita-se a encaminhar para o cliente seguinte, a lista alterada pelo anterior depois de retirado o numero por este
    for client in proc['ids']:
        resp = sendrecv_dict( proc['ids'][client]['endpoint'], { 'cmd': 'ESCOLHE_SEQ_NUM', 'seq_num_encript': seq_num, 'error':'' } )
        
        if resp['error']!='':
            return { 'error':'Sorting process error: invalid client answer' }
        #constroi nova lista com os elementos restantes
        seq_num=[]
        for i in resp['seq_num_encript']:   
            seq_num.append( i )                 
    #-------------------------------------------------------------------------------------------
    #5. O servidor vai pedir a cada participante o par C,B em que B e a sintese de C com a Chave guardada
    #   Entretanto vai ser criada a estrutruta com os dados que serão necessários por cliente
    #-------------------------------------------------------------------------------------------    
    for client in proc['ids']:
        resp = sendrecv_dict( proc['ids'][client]['endpoint'], { 'cmd': 'GET_CB', 'error':'' } )
        if resp['error']!='':
            return { 'error':'Sorting process error: invalid C,B processing' }
        #Guarda Be C na estrutura
        basedados_encript[client] = { 'Posicao':'', 'C': resp['C'], 'B':resp['B'], 'K':'' }
    #-------------------------------------------------------------------------------------------
    #6. O servidor vai enviar os pares C e B para os clientes respetivos, para serem validados
    #-------------------------------------------------------------------------------------------
    for client in basedados_encript:
        C=basedados_encript[client]['C']
        B=basedados_encript[client]['B']
        resp = sendrecv_dict( proc['ids'][client]['endpoint'], { 'cmd': 'CHECK_CB', 'C': C, 'B': B, 'error':'' } )
        if resp['error']!='':
            return { 'error':'Sorting process error: C,B match error' }
        
        #print("CB Match for user %s" %(client))
    #-------------------------------------------------------------------------------------------
    #7. O servidor pede as chaves K a todos os participantes
    #-------------------------------------------------------------------------------------------
    for client in basedados_encript:
        resp = sendrecv_dict( proc['ids'][client]['endpoint'], { 'cmd': 'GET_K', 'error':'' } )
        if resp['error']!='':
            return { 'error':'Sorting process error: invalid K processing' }
        basedados_encript[client]['K'] = resp['K'] #guarda o K na estrutura            
    #-------------------------------------------------------------------------------------------
    #8. O servidor vais enviar para todos os participantes os trios (C,B,K)
    #-------------------------------------------------------------------------------------------
    for client in basedados_encript:
        resp = sendrecv_dict( proc['ids'][client]['endpoint'], { 'cmd': 'CHECK_CBK', 'lista': basedados_encript, 'error':'' } )
        if resp['error']!='':
            return { 'error':'Sorting process error: list processing' }
    #-------------------------------------------------------------------------------------------
    #calcula as posicoes de todos os participantes, desencriptando o C
    #-------------------------------------------------------------------------------------------
    aux=[] #Auxiliar para inverter a ordem de sequencia das chaves para desencriptar
    for client in basedados_encript:
        aux.insert(0,string_to_bytes(basedados_encript[client]['K'])) #Guarda os K por ordem invertida para desencriptar
    L=len(aux);
    posicao=[]
    for client in basedados_encript:
        data=string_to_bytes(basedados_encript[client]['C']);
        for i in range(L):
            data=desencriptar(aux[i], data)
        basedados_encript[client]['Posicao']=int(str(data, 'utf8'))
        #print("Cliente %s: Ordem %d" %(client,basedados_encript[client]['Posicao']));
    #-------------------------------------------------------------------------------------------
    # Envia a tabela final para os participantes ordenada por posicao
    #-------------------------------------------------------------------------------------------
    lista_ordenada=[]
    for client in basedados_encript:
        lista_ordenada.append({'client': client, 'Posicao': basedados_encript[client]['Posicao'] })
    lista_ordenada=sorted(lista_ordenada, key=lambda k: k['Posicao']);
        
    for client in basedados_encript:
        send_dict( proc['ids'][client]['endpoint'], { 'cmd': 'SHOW_FINAL_LIST', 'lista': lista_ordenada, 'error':'' } )        
    #imprime a lista final
    print("----Lista final ordenada----")
    L=len(lista_ordenada)
    for i in range(L):
        print("%3d: %s" %(lista_ordenada[i]['Posicao'], lista_ordenada[i]['client']))
    #-------------------------------------------------------------------------------------------
    #termina as sessoes dos clientes
    #-------------------------------------------------------------------------------------------
    for client in basedados_encript:
        send_dict( proc['ids'][client]['endpoint'], { 'cmd': 'STOP_ORDERING', 'error':'' } )
    return basedados_encript 
#
# Message structure:
# { op: NEW, proc: proc_id }
# { op: ADD, proc = proc_id, id: client_id }
# { op: LIST, proc: proc_id }
# { op: START, proc: proc_id }
#
def new_msg( client ):
    request = recv_dict( client )
    if request['op'] == 'NEW':     # Create a new sorting process
        resp = new_process( request['proc'], client )
    elif request['op'] == 'ADD':   # Add a client to a sorting process
        resp = new_client( request['proc'], request['id'], client )
    elif request['op'] == 'LIST':   # List clients in a sorting process
        resp = list_clients( request['proc'], client )
    elif request['op'] == 'START': # Start the sorting process
        start_sorting( request['proc'], client )
        resp = dump_proc( request['proc'] )
        clean_proc( request['proc'] )
    else:
        resp = { 'error':'Wrong request "' + request['op'] + '"' }
    send_dict( client, resp )
def main(args):
    # Validate the program parameters
    # Set the server's TCP address from the command args
   
    if len (args) < 2 : #temos que contar com o nome do programa (1+1)
        print("Parametros invalidos:")
        print("server.py porto [máquina]")
        sys.exit( 1 )
    try:
        porto = int (args[1])
    except ValueError:
        print("Porto invalido")
        sys.exit( 2 )    
    if porto > 65535 or porto < 1024 : # porto é sempre inferior a 65535 e > 1023
        print("Porto fora da gama :[1024-65535]")
        sys.exit( 3 )
    if len (args) == 2 : # se o parametro maquina nao existir, maquina = localhost
        maquina = '127.0.0.1' #localhost
    else:
        maquina = args[2]
    address = ( maquina , porto )
    s = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
    s.bind( address )
    s.listen()
    clients = []
    while True:
        try:
            available = select.select( [ s ] + clients, [], [] )[0]
        except ValueError:
            # Sockets may have been closed, check for that
            for c in clients:
                if c.fileno() == -1: # closed
                    clients.remove( c )
            continue # Reiterate select
        for c in available:
             # New client?
             if c is s:
                new, addr = s.accept()
                clients.append( new )
             # Or a client
             else:
                # See if client sent a message
                if len(c.recv( 1, socket.MSG_PEEK )) != 0:
                    new_msg( c )
                else: # or just disconnected
                    clients.remove( c )
                    clean_client( c )
                    c.close()
                    break # Reiterate select
if __name__ == "__main__":
    main(sys.argv)
