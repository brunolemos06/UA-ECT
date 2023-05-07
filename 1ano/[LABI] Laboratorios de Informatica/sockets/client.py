#!/usr/bin/python3
import random
import os
import sys
import socket
import json
import base64
import csv
from Crypto.Hash import SHA256
from Crypto.Cipher import AES
from common_comm import send_dict, recv_dict, sendrecv_dict, bytes_to_string, string_to_bytes, digest, desencriptar, encriptar
basedados_encript = {} # Estrutura que vai guardar as chaves e sequencias encriptadas
#
# JSON message structures already defined:
#
# 1 - Create an ordering process
#     request: { op: NEW, proc: <proc_id string> }
#     response: { error: <string> } (empty string if no error)
#
# 2 - List clients associated to an ordering process
#     request: { op: LIST, proc: <proc_id string> }
#     response: { ids: <list>, error: <string> } (empty string if no error)
#
# 3 - Start an ordering process
#     request: { op: START, proc: <proc_id string> }
#     response: { <to be defined> }
#
# 4 - Add a client to an ordering process
#     request: { op: ADD, proc: <proc_id string>, id: <client_id string> }
#     response: { error: <string> } (empty string if no error)
def manager( server, proc ):
    msg = { 'op': 'NEW', 'proc': proc }
    resp = sendrecv_dict( server, msg )
    if resp['error'] != '':
        print( 'Server error: %s' % (resp['error']) )
        sys.exit( 2 )
    while True:
        print( 'Commands for ordering on process "' + proc + '"' )
        print( '\tL or l - list the clients' )
        print( '\tS or s - start ordering' )
        print( '\tQ or q - quit' )
        while True:
            cmd = input( 'prompt: ' )
            if cmd in ['l',  'L']:
                msg = { 'op':'LIST', 'proc': proc }
                resp = sendrecv_dict( server, msg )
                if resp['error'] == '':
                    if len(resp[ 'ids' ]) == 0:
                        print( 'No clients yet!' )
                    else:
                        print( '%d clients:' % (len(resp['ids'])) )
                        for name in resp['ids']:
                            print( '\t%s' % (name) )
                else:
                    print( 'Error: ' + resp['error'] )
                    sys.exit( 2 )
            elif cmd in ['s', 'S']:
                msg = { 'op':'START', 'proc': proc }
                resp = sendrecv_dict( server, msg )
                return resp
            elif cmd in ['q', 'Q']:
                sys.exit( 0 )
            else:
                print( "???" )
#-------------------------------------------------------------------------
# Funcao que recebe uma sequencia de numeros e encripta, baralha e 
# envia de novo para o servidor
#-------------------------------------------------------------------------
def client_encript_seq(request, basedados_encript):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    if request['format']=='bytes':
        format_string=0
    else:
        format_string=1
    #2. encripta a sequencia de numeros recebida    
    #------------------------------------------------------------------
    basedados_encript['myK'] = os.urandom(16) #Chave simetrica gerada - 128 bits (16x8)    
    seq_num_encriptado = [] #onde se vai guardar a sequencia encriptada
    for i in request['seq_num']:
        if format_string==1:                    
            valor_encriptado=encriptar(basedados_encript['myK'],string_to_bytes(i),0) #recebeu no formato string. tem que converter para bytes para encriptar
        else:
            valor_encriptado=encriptar(basedados_encript['myK'],i,1)
        seq_num_encriptado.append(bytes_to_string(valor_encriptado)) #para enviar, tem que converter a sequencia para string       
        
    #2. Baralha a sequencia encriptada
    #------------------------------------------------------------------
    random.shuffle(seq_num_encriptado)
    #2. Retorna a sequencia encriptada e baralhada ao servidor e espera pela operacao seguinte
    #------------------------------------------------------------------            
    return { 'error': '', 'seq_num_encript': seq_num_encriptado }
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#   Recebe uma lista encriptada N vezes e vai escolher aleatóriamente um dos valores e remove da lista,
#   de seguida retorna a lista para o servidor com menos um elemento
#-------------------------------------------------------------------------
def client_escolhe_seq_num(request, basedados_encript):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    Numero_valores_recebidos = len(request['seq_num_encript'])
    
    if Numero_valores_recebidos<=0:
        print( 'Server error: Lista de numeros vazia' )
        sys.exit( 5 )
    #escolhe um numero aleatorio de entre os numeros recebidos. Guarda na estrutura no modo bytes
    basedados_encript['myC']=string_to_bytes(random.choice(request['seq_num_encript']))
    seq_num_encriptado=[] #nova lista que sera enviada para o servidor, sem o elemento escolhido
    for i in request['seq_num_encript']:
        if string_to_bytes(i) != basedados_encript['myC']:
            seq_num_encriptado.append(i) #i esta no formato string oara ser enviado
    #2. Envia a sequencia depois de removido o elemento escolhido 
    #------------------------------------------------------------------            
    return { 'error': '', 'seq_num_encript': seq_num_encriptado }
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#   calcula a sintese de (C,K) e aramzena em B
#   Envia (C,B) para o servidor
#-------------------------------------------------------------------------
def client_get_CB(request, basedados_encript):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    #5. Aplica um hash a C (que ja esta no formato string) e a K (que precisa de ser convertido para string) = B
    basedados_encript['myB']=digest(basedados_encript['myC'],basedados_encript['myK'])
    #Retorna o par C,B para o servidor (converte para string para poder enviar)
    return { 'error': '', 'C': bytes_to_string(basedados_encript['myC']), 'B': bytes_to_string(basedados_encript['myB']) }
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#   Confirma que C,B enviado pelo servidor bate certo com o que foi sintetizado 
#   por este cliente
#-------------------------------------------------------------------------
def client_check_CB(request, basedados_encript):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    if (request['C']!=bytes_to_string(basedados_encript['myC'])):        
        send_dict( server, { 'error': 'C nao corresponde ao cliente'} )    
        sys.exit ( 5 )
    if (request['B']!=bytes_to_string(basedados_encript['myB'])):
        send_dict( server, { 'error': 'B nao corresponde ao cliente'} )    
        sys.exit ( 6 )
    return { 'error':'' }
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#   Devolve para o servidor o valor da chave K
#-------------------------------------------------------------------------
def client_get_K(request, basedados_encript):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    #7.Envia a chave K para o servidor
    return { 'error': '', 'K': bytes_to_string(basedados_encript['myK']) }
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#   Verifica se a sua chave K, B e C estao correctos
#   De seguida confirma todos os B de todos os clientes estao correctos
#   Confirma a ordem de todos os participantes e imprime para a consola
#-------------------------------------------------------------------------
def client_check_all_CBK(request, basedados_encript, myclient):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    
    #Servidor envia todos os C,B,K de todos os clientes
    #verifica se a sua chave esta certa:
    if request['lista'][myclient]['K']!=bytes_to_string(basedados_encript['myK']):
        print('Validacao do proprio K: NOK')
        send_dict( server, { 'error': 'Protesto: K nao corresponde ao cliente'} )    
        sys.exit ( 7 )
    #print('Validacao do proprio K: OK')
    #verifica se o seu C esta certo:
    if request['lista'][myclient]['C']!=bytes_to_string(basedados_encript['myC']):
        print('Validacao do proprio C: NOK')
        send_dict( server, { 'error': 'Protesto: C nao corresponde ao cliente'} )    
        sys.exit ( 8 )
    #print('Validacao do proprio C: OK')
    #verifica se o seu B esta certo:
    if request['lista'][myclient]['B']!=bytes_to_string(basedados_encript['myB']):
        print('Validacao do proprio B: NOK')
        send_dict( server, { 'error': 'Protesto: B nao corresponde ao cliente'} )    
        sys.exit ( 9 )
    #print('Validacao do proprio B: OK')
    aux=[] #Auxiliar para inverter a ordem de sequencia das chaves para desencriptar
    #verifica todos os B de todos os cliente
    for client in request['lista']:
        auxB=digest(string_to_bytes(request['lista'][client]['C']), string_to_bytes(request['lista'][client]['K']))
        
        if auxB!=string_to_bytes(request['lista'][client]['B']):
            print('Validacao do B do cliente %s: NOK' %(client))
            send_dict( server, { 'error': 'Protesto: B nao esta correcto para algum participante'} )    
            sys.exit(10)
        else:            
            aux.insert(0,string_to_bytes(request['lista'][client]['K'])) #Guarda os K por ordem invertida para desencriptar
    
    #print('Validacao de todos os B: OK')
    #verifica a ordem de cada participante
    #Para cada cliente vai ser desencriptado o CD
    #Guarda na estrutura basedados_encript
    L=len(aux);
    aux_bd=request['lista']
    posicao=[]
    for client in aux_bd:
        data=string_to_bytes(aux_bd[client]['C']);
        for i in range(L):
            data=desencriptar(aux[i], data)
        posicao.append(int(str(data, 'utf8')))
        #print("Cliente %s: Ordem %d" %(client,int(str(data, 'utf8'))));
        basedados_encript[client] = { 'Posicao':'', 'C':'', 'B':'', 'K':'' }
        
        #atualiza basedados_encript
        C=string_to_bytes(aux_bd[client]['C'])
        B=string_to_bytes(aux_bd[client]['B'])
        K=string_to_bytes(aux_bd[client]['K'])
        pos=int(str(data, 'utf8'))
        basedados_encript[client] = { 'Posicao':pos, 'C':C, 'B':B, 'K':K }
        
    return { 'error': ''}
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
# Mostra a lista final enviada pelo servidor
#-------------------------------------------------------------------------
def client_show_final_list(request):
    if request['error']!='':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 3 )
    print("----Lista final ordenada----")
    L=len(request['lista'])
    for i in range(L):
        print("%3d: %s" %(request['lista'][i]['Posicao'], request['lista'][i]['client']))
    return { 'error': ''}
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
# Aplicacao de cliente que:
# 1) se regista num process_id
# 2) vai esperar pelos comando do servidor para implementar o algoritmo de 
#    ordenacao
#-------------------------------------------------------------------------
def client( server, proc, client ):
    request = {'op':'ADD', 'proc': proc, 'id': client }
    resp = sendrecv_dict( server, request )    
    if resp['error'] != '':
        print( 'Server error: ' + resp['error'] )
        sys.exit( 2 )
    #Init da base de dados de encriptacao /suporta todos os parametros que serao arnmazenados ao longo do programa
    #myK: minha chave de encriptacao
    #myC: meu numero de sequencia escolhido
    #myB: my bit commitment
    #ids: estrutura com os dados de todos os outros clientes    
    basedados_encript = {'myK':'', 'myC':'', 'myB':'', 'ids': { } } 
    #print(basedados_encript)
    print("Espera pela lista de ordem....")
    #Espera pelo comandos de ordenacao do servidor    
    while True:
        request = recv_dict( server ) #Espera pelo comando do servidor
        #print(request)
        if request['error'] != '':
            print( 'Server error: ' + resp['error'] )
            sys.exit( 2 )
        cmd=request['cmd']            
        if cmd == 'ENCRIPTAR_SEQ':             # Pedido para encriptar sequencia com chave gerada pelo cliente
            resp = client_encript_seq( request, basedados_encript )
        elif cmd == 'ESCOLHE_SEQ_NUM':         # Add a client to a sorting process
            resp = client_escolhe_seq_num( request, basedados_encript )
        elif cmd == 'GET_CB':                  # Devolve o para C e B (sintese de C com K) para o servidor
            resp = client_get_CB( request, basedados_encript )
        elif cmd == 'CHECK_CB':                # Confirma o par (C,B) enviado pelo o servidor e associado ao seu nome
            resp = client_check_CB( request, basedados_encript )
        elif cmd == 'GET_K':                   # Devolve K para o servidor
            resp = client_get_K( request, basedados_encript )
        elif cmd == 'CHECK_CBK':               # Testa o trio C,B,K de todos os participantes (enviados pelo servidor)
            resp = client_check_all_CBK( request, basedados_encript, client )# Imprime a lista de participantes e sua ordem. Se existirem ordem iguais
        elif cmd == 'SHOW_FINAL_LIST':               # Testa o trio C,B,K de todos os participantes (enviados pelo servidor)
            resp = client_show_final_list( request) # Imprime a lista de participantes e sua ordem enviada pelo servidor. 
        elif cmd == 'STOP_ORDERING':           # Termina o processo
            print('Processo terminado')
            sys.exit( 0 )            
        else:                                             
            resp = { 'error':'Wrong request "' + request['op'] + '"' }
        
        send_dict( server, resp )
        
#-------------------------------------------------------------------------------------------------
# FIM DO PROCESSAMENTO DO CLIENTE
#-------------------------------------------------------------------------------------------------
def dump_csv( proc ):
    # Dump a CSV to a file from data received from the server    
    # print(proc)
    # cria a csv file (report_<client_id>.csv)
    lista_ordenada=[] # utilizada para imprimeir no ecra a lista final
    print('write data to report.csv')
    with open('report.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["Numero ordem", "identificador pessoal", "Num ordem cifrado (C)", "chave(K)", "bit commitment(B)"])
        for client in proc['params']:
            C_aux   = string_to_bytes(proc['params'][client]['C'])
            K_aux   = string_to_bytes(proc['params'][client]['K'])
            B_aux   = string_to_bytes(proc['params'][client]['B'])
            posicao = proc['params'][client]['Posicao']
            writer.writerow([posicao, client, C_aux, K_aux, B_aux])                    
            #print("Ordem: %d, id=%s, C=%s, K=%s, B=%s" %(posicao, client, str(C_aux),str(K_aux),str(B_aux)))
            lista_ordenada.append({'client': client, 'Posicao': posicao })
    #imprime a lista final
    lista_ordenada=sorted(lista_ordenada, key=lambda k: k['Posicao']);
    print("----Lista final ordenada----")
    L=len(lista_ordenada)
    for i in range(L):
        print("%3d: %s" %(lista_ordenada[i]['Posicao'], lista_ordenada[i]['client']))
    return
def main(args):
    # Validate the program parameters
    #client.py id_processo_ordenação id_pessoal porto [máquina]
    # Set the server's TCP address from the command args
    
    if len (args) < 4 : #temos que contar com o nome do programa (3+1)
        print("Parametros invalidos:")
        print("client.py id_processo_ordenação id_pessoal porto [máquina]")
        sys.exit( 1 )
    id_processo_ordenação = args[1]
    id_pessoal = args[2]
    try:
        porto = int (args[3])
    except ValueError:
        print("Porto invalido")
        sys.exit( 2 )
        
    if porto > 65535 or porto < 1024 : # porto é sempre inferior a 65535 e > 0
        print("Porto fora da gama :[1024-65535]")
        sys.exit( 3 )
    if len (args) == 4 : # se o parametro maquina nao existir, maquina = localhost
        maquina = '127.0.0.1' #localhost
    else:
        maquina = args[4]
    address = ( maquina , porto )
    try:
        s = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
        s.connect( address )
    except ConnectionError:
        print(" Servidor fora de servico")
        sys.exit( 4 )
    # Set the process_id and the client_id from the command args
    process_id = id_processo_ordenação
    client_id = id_pessoal
    if client_id == 'admin':
        dump_csv ( manager( s, process_id ) )
    else:
        client( s, process_id, client_id )
if __name__ == "__main__":
    main(sys.argv)
