
from cgi import print_form
import itertools
from lib2to3.pytree import Node
import math
import sys
from zlib import DEF_BUF_SIZE
from pandas import array

import matplotlib.pyplot as plt
from croblink import *
import xml.etree.ElementTree as ET
import networkx as nx

#GRAPG
norte = 0
sul = 1
este = 2
oeste = 3
Graph = nx.MultiGraph()
checkid = 0
Graph.add_node(0,Position=(0,0),struct={norte:0,sul:0,este:0,oeste:0}) #adicionar root

Nodes = {0,(0,0)} #node list key and position initiated With root node
NodeID=1
LastvisitedNode = 0
start = 1
CELLROWS=7
CELLCOLS=14

Calcularground = 0

ground = 0
#NORTE SUL ESTE OESTE
savex,savey = 0,0

check = False
algoritmo = 0

direcao = -1
go_to_path_step = 0
direcao_atual = norte
direcao_retaguarda = norte

direita = este
esquerda = oeste
tras = sul
antigo_tras = sul
save = [0,0,0,0,0,0,0]
path = []
deadend = 0
go_to_path = 0

#rotating
rotate_left = 0
rotate_right = 0
driveslow = 0

LastvisitedNode = 0
LastvisitedNodeSave = 0
direcaosave = -1
arrayGPS_x = []
arrayGPS_y = []
checkpointsList = []
checkpointsList.append([0,0])


position = [0,0]
compass=0
previousOutX=0
previousOutY=0

finish = 0

go_front = 0
sanitezedPosition = [0,0]
driveslow_counter = 0
rotate_left_counter = 0
rotate_right_counter = 0
revert = 0
flag_rotate = 0
class MyRob(CRobLinkAngs):
    def __init__(self, rob_name, rob_id, angles, host):
        CRobLinkAngs.__init__(self, rob_name, rob_id, angles, host)
        self.labMap = [[" " for i in range(49)] for j in range(21)]
        self.x = 0
        self.y = 0
        self.arraynodes = []
    # In this map the center of cell (i,j), (i in 0..6, j in 0..13) is mapped to labMap[i*2][j*2]. 
    # to know if there is a wall on top of cell(i,j) (i in 0..5), check if the value of labMap[i*2+1][j*2] is space or not
    def getGPS(self): #GET ATUAL POSITION OF ROBOT
        #return x,y
        global sanitezedPosition
        return (sanitezedPosition[0] , sanitezedPosition[1])

    def wander(self): # STATE MACHINE : [ ROTATE LEFT , ROTATE RIGHT , GO FRONT , GO TO PATH , GO TO CHECKPOINT ] - SERÁ NECESSÁRIO IMPLEMENTAR A FUNÇÃO DE IR PARA O CHECKPOINT
        global LastvisitedNodeSave,savex,savey,revert,flag_rotate,driveslow_counter,driveslow,rotate_right_counter,rotate_left_counter,Calcularground,direcao_atual,direita,esquerda,rotate_right,rotate_left,direcao_retaguarda,save,tras,antigo_tras,NodeID,Graph,path,go_to_path_step,direcao,go_to_path,LastvisitedNode,go_front,flagback,ground,arrayGPS_x,arrayGPS_y,direcaosave,checkpointsList,checkid
        x,y = self.getGPS()

        values = [int(v) for v in self.measures.lineSensor]
        print(values)
        # STOP THE PROGRAM WITH KEY
        # if values == [0,0,0,0,0,0,0]:


        # if sys.stdin.read(1):
        ground = self.measures.ground
        self.AtualizarDirecaoAtual()
        # print("Checkpoints->" , checkpointsList)
        if ground > 0:
            Calcularground = 1
            checkid = ground
            direcaosave = direcao_atual
            arrayGPS_x.append(sanitezedPosition[0])
            arrayGPS_y.append(sanitezedPosition[1])
        elif(Calcularground == 1) and (ground == -1):
            Calcularground = 0
            if direcaosave == direcao_atual:
                #Calcular Centro do Checkpoint
                valuex = int(round(sum(arrayGPS_x)/len(arrayGPS_x)))
                valuey = int(round(sum(arrayGPS_y)/len(arrayGPS_y)))

                x = valuex
                y = valuey
                if x%2 != 0:
                    print("upsi x")
                    # check direction
                    if direcao_atual == este:
                        x+=1
                    elif direcao_atual == oeste:
                        x-=1
                    else:
                        x = Graph.nodes[LastvisitedNode]['Position'][0]
                if y%2 != 0:
                    print("upsi y")
                    # check direction
                    if direcao_atual == norte:
                        y+=1
                    elif direcao_atual == sul:
                        y-=1
                    else:
                        y = Graph.nodes[LastvisitedNode]['Position'][1]

                position[0],position[1] = x*2,y*2
                print(f"CHECKvalue ->{previousOutX},{previousOutY}")

                valuex = x
                valuey = y
                index = self.node_exists(valuex,valuey)
                if index == -1:
                    if direcao_atual == norte:
                        Graph.add_node(NodeID,Position=(valuex,valuey),struct={norte:2,sul:2,este:0,oeste:0})
                    else:
                        Graph.add_node(NodeID,Position=(valuex,valuey),struct={norte:0,sul:0,este:2,oeste:2})
                    NodeID+=1
                    if not Graph.has_edge(LastvisitedNode,NodeID-1) and LastvisitedNode != NodeID-1 and self.edgeIsOk(LastvisitedNode,NodeID-1):
                        Graph.add_edge(LastvisitedNode,NodeID-1,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[NodeID-1]['Position']))
                    LastvisitedNode = NodeID-1
                    if [checkid,LastvisitedNode] not in checkpointsList:
                        checkpointsList.append([checkid,LastvisitedNode])
            arrayGPS_x = []
            arrayGPS_y = []
                
        # state machine
        #Traduz direção absoluta para relativa
        (direita,esquerda,tras) = self.getDireita_Esquerda_Trás(direcao_atual)
        if rotate_right and revert == 0:
            print(flag_rotate)
            if ((values[0] and values[1] and values[2]) or (not values[0] and values[1] and values[2]) or (values[0] and values[1] and (not values[2]))):
                # occures at leat 3 times
                print("SIUSIU -> with values::",values)
                flag_rotate += 1
            if flag_rotate >= 4:
                if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] != 2:
                    Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = 1
                print("FRENTE")
            
            #ROTATE RIGHT
            print(f"->>>>>>>>>>>>>>>> ROTATE RIGHT <<<<<<<<<<<<<<<<<<<-  {self.getDireita_Esquerda_Trás(direcao_atual)[0]}")
            # CONDA = ( (values[2] == 1 and values[3] == 1 and values[4] == 1) or (values[2] == 0 and values[3] == 1 and values[4] == 1) or (values[2] == 1 and values[3] == 1 and values[4] == 0) or (values[2] == 1 and values[3] == 0 and values[4] == 1)) and direcao_atual == self.getDireita_Esquerda_Trás(direcao_retaguarda)[0]
            # if CONDA:
            if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0] or values == [0,0,1,0,1,0,0]) and direcao_atual == self.getDireita_Esquerda_Trás(direcao_retaguarda)[0]:
                rotate_right = 0
                driveslow = 1
                if (flag_rotate < 4 and flag_rotate > 0):
                    print("Possible missing left")
                flag_rotate = 0

                if ground > 0 and [ground,LastvisitedNode] not in checkpointsList:
                    checkpointsList.append([ground,LastvisitedNode])
                # if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] == 0:
                #     Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = -1
                print(f"{LastvisitedNode} - {Graph.nodes[LastvisitedNode]['struct']}")
                rotate_right_counter = 0
            else:
                self.driveAndUpdate(0.06,-0.018)
                rotate_right_counter += 1
                if rotate_right_counter > 26:
                    # nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
                    # plt.savefig("graph.png")
                    # plt.show()
                    # rotate left 
                    rotate_right_counter = 0
                    revert = 1
                    # remove last node

                    # direcao reatuarda -> norte e estivermos a virar para a direita estamos a virar para este
                    # se tivermos a ir para este e virarmos para a esquerda estamos a virar para o norte
                    #self.driveAndUpdate(0,0)
        elif rotate_left and revert == 0:
            
            if ((values[4] and values[5] and values[6]) or (not values[4] and values[5] and values[6]) or (values[4] and values[5] and (not values[6]))):
                # occures at leat 3 times
                flag_rotate += 1
                print("SIUSIU -> with values::",values)
            if flag_rotate >= 4:
                if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] != 2:
                    Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = 1
                print("FRENTE")
            #ROTATE LEFT
            print(f"->>>>>>>>>>>>>>>> ROTATE LEFT <<<<<<<<<<<<<<<<<<<-  {self.getDireita_Esquerda_Trás(direcao_atual)[1]}")
            # CONDA  = ( (values[2] == 1 and values[3] == 1 and values[4] == 1) or (values[2] == 0 and values[3] == 1 and values[4] == 1) or (values[2] == 1 and values[3] == 1 and values[4] == 0) or (values[2] == 1 and values[3] == 0 and values[4] == 1)) and direcao_atual == self.getDireita_Esquerda_Trás(direcao_retaguarda)[1]
            # if CONDA:
            if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0] or values == [0,0,1,0,1,0,0]) and direcao_atual == self.getDireita_Esquerda_Trás(direcao_retaguarda)[1]:
                rotate_left = 0
                driveslow = 1
                if (flag_rotate < 4  and flag_rotate > 0):
                    print(f"Possible missing left {direcao_atual} {esquerda} {direita} {direcao_retaguarda}")
                flag_rotate = 0
                if ground > 0 and [ground,LastvisitedNode]  not in checkpointsList:
                    checkpointsList.append([ground,LastvisitedNode] )
                # if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] == 0:
                #     Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = -1
                print(f"{LastvisitedNode} - {Graph.nodes[LastvisitedNode]['struct']}")
                rotate_left_counter = 0
            else:
                self.driveAndUpdate(-0.018,0.06)
                # if it call 100 times and still not found the right direction, it will stop
                rotate_left_counter += 1
                if rotate_left_counter > 26:
                    # nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
                    # plt.savefig("graph.png")f
                    # plt.show()
                    # rotate left
                    rotate_left_counter = 0
                    revert = 1
                    # self.driveAndUpdate(0,0)
        elif go_front:
            self.drive(values,x,y,0.08)
            # aqui
            print("NAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO\n\n\n\n\n\n")
            go_front = 0
        elif go_to_path == 1:
            print("CURRENT PATH:" , path)
            if go_to_path_step == 0:
                x1,y1 = Graph.nodes[path[0]]['Position']
                x2,y2 = Graph.nodes[path[1]]['Position']
                if x1 == x2:
                    if y1 > y2:
                        direcao = sul
                    else:
                        direcao = norte
                else:
                    if x1 > x2:
                        direcao = oeste
                    else:
                        direcao = este

                # print("direcao -> ",direcao)
                # print("esquerda -> ",esquerda)
                # print("direita -> ",direita)
                # print("tras -> ",tras)

                if direcao == direcao_atual:
                    go_to_path_step = 1 # go front
                elif direcao == esquerda:
                    direcao_retaguarda = direcao_atual
                    rotate_left = 1 # left
                    go_to_path_step = 1
                elif direcao == direita:
                    direcao_retaguarda = direcao_atual
                    rotate_right = 1 # right
                    go_to_path_step = 1
                elif direcao == tras:
                    go_to_path_step = 2 # go back
                    flagback = 1

            if go_to_path_step == 2: #GO BACK
                # print("back")
                # print("Direcao atual:{} onde tem de estar: {}".format(direcao_atual,direcao))
                # if (values[2] == 1 and values[3] == 1 and values[4] == 1) or (values[2] == 1 and values[3] == 1 and values[4] == 0) or (values[2] == 0 and values[3] == 1 and values[4] == 1):
                if flagback < 2 :
                    self.driveAndUpdate(-0.018,-0.018)
                    # print("super back")
                    flagback+=1
                else:
                    # self.AtualizarDirecaoAtual()
                    # print(f"values : {values} | {direcao}=={direcao_atual}")
                    if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0]) and direcao_atual == direcao:
                        go_to_path_step = 1
                    else:
                        self.driveAndUpdate(0.04,-0.04)

            if go_to_path_step == 1:
                print("CURRENT2 PATH:" , path)
                if len(checkpointsList) > 0 and len(path) > 2:
                    for i in path:
                        for j in checkpointsList:
                            if i == j[1] and path[len(path)-1] != j[1]:
                                # remove i from path
                                path.remove(i)

                if len(path) == 2:
                    go_to_path = 0
                    go_to_path_step = 0
                    path = []
                    direcao_retaguarda = direcao_atual
                    # print("DONE")
                    self.drive2(values)
                else:
                    final = Graph.nodes[path[1]]['Position']
                    # if this position is a checkpointList
                    self.driveInFront(values,final,x,y)                 
        elif driveslow:
            if driveslow_counter < 25:
                if driveslow_counter == 0:
                    velocidade = 0.03
                    print("init")
                else:
                    velocidade = (driveslow_counter/2)/100
                    #1/100 = 0.018 ... 8/100 = 0.08
                if velocidade > 0.08:
                    velocidade = 0.07
                self.drive(values,x,y,velocidade)
                driveslow_counter += 1
            else:
                print("out")
                driveslow = 0
                driveslow_counter = 0
                self.drive(values,x,y,0.08)
        elif revert:
            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nrevert")
            # conda =  ( (values[2] == 1 and values[3] == 1 and values[4] == 1) or (values[2] == 0 and values[3] == 1 and values[4] == 1) or (values[2] == 1 and values[3] == 1 and values[4] == 0) or (values[2] == 1 and values[3] == 0 and values[4] == 1))
            if rotate_left:
                # if conda:
                if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0] or values == [0,0,1,0,1,0,0]):
                    rotate_left = 0
                    revert = 0
                    position[0],position[1] = savex,savey
                    # remove LastvisitedNode from Graph
                    # if LastvisitedNode in Graph.nodes has just one edge, remove it
                    if len(Graph.nodes[LastvisitedNode]) == 1:
                        #atualizar o NodeID
                        # change the stuct of LastvisitedNode to {}
                        Graph.nodes[LastvisitedNode]['struct'][0] = 0
                        Graph.nodes[LastvisitedNode]['struct'][1] = 0
                        Graph.nodes[LastvisitedNode]['struct'][2] = 0
                        Graph.nodes[LastvisitedNode]['struct'][3] = 0
                        Graph.nodes[LastvisitedNode]['struct'][direcao_atual] = 0
                        Graph.nodes[LastvisitedNode]['struct'][self.getDireita_Esquerda_Trás(direcao_atual)[2]] = 2
                    else:
                        # if LastvisitedNode in Graph.nodes has more than one edge, remove the edge that connects to LastvisitedNodeSave
                        for i in Graph.nodes[LastvisitedNode]:
                            if i == LastvisitedNodeSave:
                                # Graph.remove_edge(LastvisitedNode,LastvisitedNodeSave)
                                break
                    LastvisitedNode = LastvisitedNodeSave
                    print(f"[depois], LastvisitedNode: {LastvisitedNode}, position: {position}")
                    
                else:
                    self.driveAndUpdate(0.018,-0.06)
            elif rotate_right:
                # if conda:
                if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0] or values == [0,0,1,0,1,0,0]):
                    rotate_right = 0
                    revert = 0
                    position[0],position[1] = savex,savey
                    # remove LastvisitedNode from Graph
                    # if LastvisitedNode in Graph.nodes has just one edge, remove it
                    if len(Graph.nodes[LastvisitedNode]) == 1:
                        # Graph.remove_node(LastvisitedNode)
                        #atualizar o NodeID
                        # NodeID = NodeID - 1
                        Graph.nodes[LastvisitedNode]['struct'][0] = 0
                        Graph.nodes[LastvisitedNode]['struct'][1] = 0
                        Graph.nodes[LastvisitedNode]['struct'][2] = 0
                        Graph.nodes[LastvisitedNode]['struct'][3] = 0
                        Graph.nodes[LastvisitedNode]['struct'][direcao_atual] = 0
                        Graph.nodes[LastvisitedNode]['struct'][self.getDireita_Esquerda_Trás(direcao_atual)[2]] = 2
                    else:
                        # if LastvisitedNode in Graph.nodes has more than one edge, remove the edge that connects to LastvisitedNodeSave
                        for i in Graph.nodes[LastvisitedNode]:
                            if i == LastvisitedNodeSave:
                                # Graph.remove_edge(LastvisitedNode,LastvisitedNodeSave)
                                break
                    LastvisitedNode = LastvisitedNodeSave
                    print(f"[depois], LastvisitedNode: {LastvisitedNode}, position: {position}")
                else:
                    self.driveAndUpdate(-0.06,0.018)

        else: 
            self.drive(values,x,y,0.08)

        save = values

    def drive2(self,values): # go JUST FRONT : CAREFUL USING THIS FUNCTION
        global go_to_path_step,go_to_path,path
        # sppedx > speedy

        if values[0] == 0 and values[1] == 1 and values[2]==1 and values[3]==1: # 01 111 00
            self.driveAndUpdate(0.09,0.05)
        elif values[3] == 1 and values[4] == 1 and values[5]==1 and values[6]==0: # 00 111 10
            self.driveAndUpdate(0.05,0.09)
        else:
            self.driveAndUpdate(0.07,0.07)

    def driveInFront(self,values,final,x,y): # PATH DRIVING : FRONT
        global go_to_path_step,go_to_path,path,LastvisitedNode,position
        # sppedx > speedy
        speedx = 0.09
        speedy = 0.05
        # print path and final and x,y
        LastvisitedNode = path[0]
        print(f"Path: {path} | Final:{final}=={x,y}")
        #aaaaaaa
        
        if (((values[6] == 1 and values[5] == 1 and values[4] == 1) or (values[6] == 1 and values[5]== 0 and values[4] == 1) or (values[6] == 1 and values[5]== 1 and values[4] == 0) or (values[6] == 0 and values[5]== 1 and values[4] == 1)) and ((save[6]==1 and save[5]==1 and save[4]==1) or (save[6]==1 and save[5]==0 and save[4]==1) or (save[6]==1 and save[5]==1 and save[4]==0) or (save[6]==0 and save[5]==1 and save[4]==1)) and ((values[6] and values[5] and values[4] and values[3]) or (save[6] and save[5] and save[4] and save[3])) ): #esquerda
            if x%2 != 0:
                print("upsi x")
                # check direction
                if direcao_atual == este:
                    x+=1
                elif direcao_atual == oeste:
                    x-=1
                else:
                    x = Graph.nodes[LastvisitedNode]['Position'][0]
            if y%2 != 0:
                print("upsi y")
                # check direction
                if direcao_atual == norte:
                    y+=1
                elif direcao_atual == sul:
                    y-=1
                else:
                    y = Graph.nodes[LastvisitedNode]['Position'][1]
            position[0],position[1] = x*2,y*2
            print(f"X:{x} | Y:{y} | Final:{final}")
            if final == (x,y):
                print("next")
                path = path[1:]
                go_to_path_step = 0   
                return
            else:
                self.driveAndUpdate(0.07,0.07)
        elif (((values[0] == 1 and values[1] == 1 and values[2] == 1) or (values[0] == 1 and values[1]== 0 and values[2] == 1) or (values[0] == 1 and values[1]== 1 and values[2] == 0) or (values[0] == 0 and values[1]== 1 and values[2] == 1)) and ((save[0]==1 and save[1]==1 and save[2]==1) or (save[0]==1 and save[1]==0 and save[2]==1) or (save[0]==1 and save[1]==1 and save[2]==0) or (save[0]==0 and save[1]==1 and save[2]==1)) and ((values[0] and values[1] and values[2]) or (save[0] and save[1] and save[2])) ): #esquerda
            if x%2 != 0:
                print("upsi x")
                # check direction
                if direcao_atual == este:
                    x+=1
                elif direcao_atual == oeste:
                    x-=1
                else:
                    x = Graph.nodes[LastvisitedNode]['Position'][0]
            print(f"X:{x} | Y:{y} | Final:{final}")
            if y%2 != 0:
                print("upsi y")
                # check direction
                if direcao_atual == norte:
                    y+=1
                elif direcao_atual == sul:
                    y-=1
                else:
                    y = Graph.nodes[LastvisitedNode]['Position'][1]
            position[0],position[1] = x*2,y*2
            if final == (x,y):
                print("next")
                path = path[1:]
                go_to_path_step = 0   
                return
            else:
                self.driveAndUpdate(0.07,0.07)
        elif values[1] == 1 and values[2]==1 and values[3]==1: # - ?1 11? ??
            self.driveAndUpdate(speedy,speedx)
        elif values[3] == 1 and values[4] == 1 and values[5]==1: # 00 ?11 1?
            self.driveAndUpdate(speedx,speedy)
        # elif values == [0,0,0,0,0,0,0]:
            # self.driveAndUpdate(-0.1,-0.1)
        else:
            self.driveAndUpdate(0.06,0.06) 

    def node_exists(self,x,y): # VERIFY IF NODE EXISTS IN GRAPH
        global Graph
        temp = Graph.nodes()
        # just add node in graph if x,y not in graph
        for i in temp:
            # print(Graph.nodes[i])
            if Graph.nodes[i]['Position'] == (x,y):
                return i
        return -1

    def getFinalPath(self): # get final path from checkpoints
        global checkpointsList,Graph 
        # print("------")
        newchecklist = []
        for valuecheck in checkpointsList:
            newchecklist.append(valuecheck[1])
        aa = newchecklist[1:]
        
        allpossibles = list(itertools.permutations(aa))
        # add a[0] in front of each element in b
        for i in range(len(allpossibles)):
            allpossibles[i] = [newchecklist[0]] + list(allpossibles[i]) + [newchecklist[0]]
        
        sum = {}
        value=0
        for possiblepath in allpossibles:
            sum[value] = 0
            while(len(possiblepath) != 1):
                node1 = possiblepath[0]
                node2 = possiblepath[1]
                sum[value] += nx.shortest_path_length(Graph,source=node1,target=node2,weight='distance')
                possiblepath = possiblepath[1:]
            value+=1
        
        index = min(sum, key=sum.get)
        final_path = allpossibles[index]
        path_return = []
        for indexx in range(len(final_path)-1):
            startnode = final_path[indexx]
            endnode = final_path[indexx+1]
            path_return += nx.astar_path(Graph, startnode, endnode, heuristic=None, weight='distance')          
        # print(path_return)
        # print("--")
        path_return = [path_return[i] for i in range(len(path_return)) if i == 0 or path_return[i] != path_return[i-1]]

        # print(path_return)
        
        superpath = []
        save_x,save_y = Graph.nodes[path_return[0]]['Position']
        for value in path_return:
            x,y=Graph.nodes[value]['Position']
            while(abs(save_x-x) > 2):
                if save_x > x:
                    superpath.append([save_x-2,y])
                    save_x-=2
                else:
                    superpath.append([save_x+2,y])
                    save_x+=2
            while(abs(save_y-y) > 2):
                if save_y > y:
                    superpath.append([x,save_y-2])
                    save_y-=2
                else:
                    superpath.append([x,save_y+2])
                    save_y+=2
            superpath.append([x,y])
            save_x,save_y=x,y

        with open("myrob.path", "w") as f:
            for value in superpath:
                f.write(f"{value[0]} {value[1]}")
                f.write('\n')

    def getdistanceInGraph(self,node1): # get the min distance from node1 and a node that is not visited at all points [NORTE SUL ESTE OESTE]
        global finish
        temp = {}
        try:
            for node2 in Graph.nodes():
                if node1 != node2:
                    # print(f"finding[{node2}] {Graph.nodes[node2]['struct']}")
                    if Graph.nodes[node2]['struct'][norte] == 1 or Graph.nodes[node2]['struct'][sul] == 1 or Graph.nodes[node2]['struct'][este] == 1 or Graph.nodes[node2]['struct'][oeste] == 1:
                        temp[node2] = nx.shortest_path_length(Graph,source=node1,target=node2,weight='distance')
        # return the node with the shortest distance
        except:
            nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
            plt.savefig("graph.png")
            plt.show()
            print("erro")
            return -1
        if temp == {}:
            # nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
            # plt.savefig("graph.png")
            self.getFinalPath()
            # get path from node to node 0
            if finish == 1 and node1 == 0:
                self.finish()
                nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
                plt.savefig("graph.png")
                self.getFinalPath()
                print("Finish")
                return 1 
            print("Finishing: go to node 0")
            finish = 1
            return  "finish"
        return min(temp, key=temp.get)

    def find_minimum_path(self,x,y,endnode): # Function to find the minimum path bewteen two nodes in the graph [ x,y ] -> [ endnode(index) ]
        global Graph
        # print("endnode",endnode)
        startnode = self.node_exists(x,y)
        if startnode == -1:
            print("Node not found")
            return -1
        else:
            #algortimo de caminho minimo A*
            # o custo de cada node é 0
            # custo de cada aresta é a distancia euclidiana entre o node de origem e o node de destino
            # custo total de um caminho é a soma dos custos de cada aresta
            # o caminho minimo é o caminho com o menor custo total
            try:
                return  nx.astar_path(Graph, startnode, endnode, heuristic=None, weight='distance')          
            except:
                nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
                plt.savefig("graph.png")
                plt.show()
                print("erro")
                return -1

    def getDistance(self,point1,point2): # distance between two points
        x1,y1 = point1
        x2,y2 = point2
        return math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

    def edgeIsOk(self,node1,node2): # VALIDATION FUNCTION : verify if edge is horizontal or vertical 
        x1,y1 = Graph.nodes[node1]['Position']
        x2,y2 = Graph.nodes[node2]['Position']
        if x1 == x2 or y1 == y2:
            return True
        else:
            return False

    def drive(self,values,x,y,velocidade=0.09): # drive the robot with the values of the sensors, check the nodes and save the graph 
        global savex,savey,rotate_right,direcao_retaguarda,rotate_left,tras,antigo_tras,deadend,direita,esquerda,NodeID,Graph,LastvisitedNode,start,position,LastvisitedNodeSave
        
        # sppedx > speedy
        speedx = 0.09
        speedy = 0.035
        LastvisitedNodeSave = LastvisitedNode
        if deadend == 1: #Resolve Beco-sem-saida
            if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0]) and direcao_atual == self.gettras(direcao_retaguarda):            
                deadend = 0
            else:
                self.driveAndUpdate(0.03,-0.03)

        else:
            if (not driveslow) and (((values[6] == 1 and values[5] == 1 and values[4] == 1) or (values[6] == 1 and values[5]== 0 and values[4] == 1) or (values[6] == 1 and values[5]== 1 and values[4] == 0) or (values[6] == 0 and values[5]== 1 and values[4] == 1)) and ((save[6]==1 and save[5]==1 and save[4]==1) or (save[6]==1 and save[5]==0 and save[4]==1) or (save[6]==1 and save[5]==1 and save[4]==0) or (save[6]==0 and save[5]==1 and save[4]==1) and ((values[6] and values[5] and values[4]) or (save[6] and save[5] and save[4])) ))and(((values[0] == 1 and values[1] == 1 and values[2] == 1) or (values[0] == 1 and values[1]== 0 and values[2] == 1) or (values[0] == 1 and values[1]== 1 and values[2] == 0) or (values[0] == 0 and values[1]== 1 and values[2] == 1)) and ((save[0]==1 and save[1]==1 and save[2]==1) or (save[0]==1 and save[1]==0 and save[2]==1) or (save[0]==1 and save[1]==1 and save[2]==0) or (save[0]==0 and save[1]==1 and save[2]==1) and ((values[0] and values[1] and values[2]) or (save[0] and save[1] and save[2])) )):
                
                print("esquerda direita")
                if x%2 != 0:
                    print("upsi x")
                    # check direction
                    if direcao_atual == este:
                        x+=1
                    elif direcao_atual == oeste:
                        x-=1
                    else:
                        x = Graph.nodes[LastvisitedNode]['Position'][0]
                if y%2 != 0:
                    print("upsi y")
                    # check direction
                    if direcao_atual == norte:
                        y+=1
                    elif direcao_atual == sul:
                        y-=1
                    else:
                        y = Graph.nodes[LastvisitedNode]['Position'][1]

                position[0],position[1] = x*2,y*2
                print(f"value ->{position[0]/2},{position[1]/2}")

                # print("esquerda direita")
                rotate_right = 1
                direcao_retaguarda = direcao_atual
                # verify if the x is impar or par                    
                index = self.node_exists(x,y) # verify is node x,y exists
                if start == 1:
                    start=0
                    Graph.nodes[0]['struct'][direcao_atual] = 2
                if index ==-1:
                    Graph.add_node(NodeID,Position=(x,y),struct={norte:0,sul:0,este:0,oeste:0})
                    NodeID+=1
                    if not Graph.has_edge(LastvisitedNode,NodeID-1) and LastvisitedNode != NodeID-1 and self.edgeIsOk(LastvisitedNode,NodeID-1):
                        Graph.add_edge(LastvisitedNode,NodeID-1,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[NodeID-1]['Position']))
                    LastvisitedNode = NodeID-1
                else:
                    if not Graph.has_edge(LastvisitedNode,index) and LastvisitedNode != index and self.edgeIsOk(LastvisitedNode,index):
                        Graph.add_edge(LastvisitedNode,index,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[index]['Position']))
                    LastvisitedNode = index
                
                if Graph.nodes[LastvisitedNode]['struct'][direita] != 2:
                    Graph.nodes[LastvisitedNode]['struct'][direita] = 1
                if Graph.nodes[LastvisitedNode]['struct'][esquerda] != 2:
                    Graph.nodes[LastvisitedNode]['struct'][esquerda] = 1
                Graph.nodes[LastvisitedNode]['struct'][tras] = 2
                antigo_tras = tras
                self.checkdirection(x,y)

            elif (not driveslow) and (((values[6] == 1 and values[5] == 1 and values[4] == 1) or (values[6] == 1 and values[5]== 0 and values[4] == 1) or (values[6] == 1 and values[5]== 1 and values[4] == 0) or (values[6] == 0 and values[5]== 1 and values[4] == 1)) and ((save[6]==1 and save[5]==1 and save[4]==1) or (save[6]==1 and save[5]==0 and save[4]==1) or (save[6]==1 and save[5]==1 and save[4]==0) or (save[6]==0 and save[5]==1 and save[4]==1)) and ((values[6] and values[5] and values[4]) or (save[6] and save[5] and save[4])) ): #esquerda
                print("direita")
                
                if x%2 != 0:
                    print("upsi x")
                    # check direction
                    if direcao_atual == este:
                        x+=1
                    elif direcao_atual == oeste:
                        x-=1
                    else:
                        x = Graph.nodes[LastvisitedNode]['Position'][0]
                if y%2 != 0:
                    print("upsi y")
                    # check direction
                    if direcao_atual == norte:
                        y+=1
                    elif direcao_atual == sul:
                        y-=1
                    else:
                        y = Graph.nodes[LastvisitedNode]['Position'][1]
                position[0],position[1] = x*2,y*2
                print(f"value ->{position[0]/2},{position[1]/2}")

                direcao_retaguarda = direcao_atual
                if start == 1:
                    start=0
                    Graph.nodes[0]['struct'][direcao_atual] = 2
                index = self.node_exists(x,y)
                if index ==-1:
                    Graph.add_node(NodeID,Position=(x,y),struct={norte:0,sul:0,este:0,oeste:0})
                    NodeID+=1
                    if not Graph.has_edge(LastvisitedNode,NodeID-1) and LastvisitedNode != NodeID-1 and self.edgeIsOk(LastvisitedNode,NodeID-1):
                        Graph.add_edge(LastvisitedNode,NodeID-1,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[NodeID-1]['Position']))
                    LastvisitedNode = NodeID-1
                else:
                    if not Graph.has_edge(LastvisitedNode,index) and LastvisitedNode != index and self.edgeIsOk(LastvisitedNode,index):
                        Graph.add_edge(LastvisitedNode,index,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[index]['Position']))
                    LastvisitedNode = index

                if Graph.nodes[LastvisitedNode]['struct'][direita] !=2:
                    Graph.nodes[LastvisitedNode]['struct'][direita] = 1
                # Graph.nodes[LastvisitedNode]['struct'][esquerda] = 0
                Graph.nodes[LastvisitedNode]['struct'][tras] = 2
                
                antigo_tras = tras
                self.checkdirection(x,y)
            elif (not driveslow) and (((values[0] == 1 and values[1] == 1 and values[2] == 1) or (values[0] == 1 and values[1]== 0 and values[2] == 1) or (values[0] == 1 and values[1]== 1 and values[2] == 0) or (values[0] == 0 and values[1]== 1 and values[2] == 1)) and ((save[0]==1 and save[1]==1 and save[2]==1) or (save[0]==1 and save[1]==0 and save[2]==1) or (save[0]==1 and save[1]==1 and save[2]==0) or (save[0]==0 and save[1]==1 and save[2]==1)) and ((values[0] and values[1] and values[2]) or (save[0] and save[1] and save[2])) ): #esquerda
                print("esquerda")
                
                if x%2 != 0:
                    print("upsi x")
                    # check direction
                    if direcao_atual == este:
                        x+=1
                    elif direcao_atual == oeste:
                        x-=1
                    else:
                        x = Graph.nodes[LastvisitedNode]['Position'][0]
                if y%2 != 0:
                    print("upsi y")
                    # check direction
                    if direcao_atual == norte:
                        y+=1
                    elif direcao_atual == sul:
                        y-=1
                    else:
                        y = Graph.nodes[LastvisitedNode]['Position'][1]
                position[0],position[1] = x*2,y*2
                print(f"value ->{position[0]/2},{position[1]/2}")

                index = self.node_exists(x,y)
                if start == 1:
                    start=0
                    Graph.nodes[0]['struct'][direcao_atual] = 2
                if index == -1:
                    Graph.add_node(NodeID,Position=(x,y),struct={norte:0,sul:0,este:0,oeste:0})
                    NodeID+=1
                    if not Graph.has_edge(LastvisitedNode,NodeID-1) and LastvisitedNode != NodeID-1 and self.edgeIsOk(LastvisitedNode,NodeID-1):
                        Graph.add_edge(LastvisitedNode,NodeID-1,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[NodeID-1]['Position']))
                    LastvisitedNode = NodeID-1
                else:
                    if not Graph.has_edge(LastvisitedNode,index)  and LastvisitedNode != index and self.edgeIsOk(LastvisitedNode,index):
                        Graph.add_edge(LastvisitedNode,index,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[index]['Position']))
                    LastvisitedNode = index

                rotate_left = 1
                direcao_retaguarda = direcao_atual
                
                if Graph.nodes[LastvisitedNode]['struct'][esquerda] !=2:
                    Graph.nodes[LastvisitedNode]['struct'][esquerda] = 1
                Graph.nodes[LastvisitedNode]['struct'][tras] = 2
                # Graph.nodes[LastvisitedNode]['struct'][direita] = 0

                antigo_tras = tras
                
                self.checkdirection(x,y)
            elif values[0] == 0 and values[1] == 1 and values[2]==1: # 01 111 00
                self.driveAndUpdate(speedy,speedx)
            elif values[4] == 1 and values[5]==1 and values[6]==0: # 00 111 10
                self.driveAndUpdate(speedx,speedy)
            elif values == [0,0,0,0,0,0,0] and save == [0,0,0,0,0,0,0]: # DEAD END
                print("DEADEND")
                if x%2 != 0:
                    print("upsi x")
                    # check direction
                    if direcao_atual == este:
                        x+=1
                    elif direcao_atual == oeste:
                        x-=1
                    else:
                        x = Graph.nodes[LastvisitedNode]['Position'][0]
                if y%2 != 0:
                    print("upsi y")
                    # check direction
                    if direcao_atual == norte:
                        y+=1
                    elif direcao_atual == sul:
                        y-=1
                    else:
                        y = Graph.nodes[LastvisitedNode]['Position'][1]
                position[0],position[1] = x*2,y*2
                print(f"value ->{position[0]/2},{position[1]/2}")


                self.driveAndUpdate(-0.06,-0.06)
                # if ground > 0 and [ground,LastvisitedNode] not in checkpointsList:
                if 1:
                    index = self.node_exists(x,y)
                    if index ==-1:
                        Graph.add_node(NodeID,Position=(x,y),struct={norte:0,sul:0,este:0,oeste:0})
                        NodeID+=1
                        if not Graph.has_edge(LastvisitedNode,NodeID-1) and LastvisitedNode != NodeID-1 and self.edgeIsOk(LastvisitedNode,NodeID-1):
                            Graph.add_edge(LastvisitedNode,NodeID-1,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[NodeID-1]['Position']))
                        LastvisitedNode = NodeID-1
                    else:
                        if not Graph.has_edge(LastvisitedNode,index) and LastvisitedNode != index and self.edgeIsOk(LastvisitedNode,index):
                            Graph.add_edge(LastvisitedNode,index,distance=self.getDistance(Graph.nodes[LastvisitedNode]['Position'],Graph.nodes[index]['Position']))
                        LastvisitedNode = index
                if ground > 0 and [ground,LastvisitedNode] not in checkpointsList:
                    checkpointsList.append([ground,LastvisitedNode])
                    print("checkpoint IN DEAD END")
                deadend = 1
                direcao_retaguarda = direcao_atual
            else:
                self.driveAndUpdate(velocidade,velocidade) 

    def gettras(self,direcao): # get trás direction of direcao atual 'direcao'
        if direcao == norte:
            return sul
        elif direcao == sul:
            return norte
        elif direcao == este:
            return oeste
        elif direcao == oeste:
            return este

    def getDireita_Esquerda_Trás(self,v): # GET direita,esquerda e trás de acordo com  a direcao atual 'v'
        if v == norte:
            direita = este
            esquerda = oeste
            tras = sul
        elif v == sul:
            direita = oeste
            esquerda = este
            tras = norte
        elif v == este:
            direita = sul
            esquerda = norte
            tras = oeste
        elif v == oeste:
            direita = norte
            esquerda = sul
            tras = este
        return (direita,esquerda,tras)

    def AtualizarDirecaoAtual(self): # ATUALIZA A DIREÇÃO ATUAL de acordo com o compasso
        global direcao_atual,este,sul,oeste,norte
        compass = self.measures.compass  
        # print(compass)
        if compass<45 and compass > -45:
            direcao_atual = este
        elif compass>45 and compass < 135:
            direcao_atual = norte
            # print("norte")
        elif compass>135 or compass < -135:
            direcao_atual = oeste
            # print("oeste")
        elif compass<-45 and compass > -135:
            direcao_atual = sul
    
    def checkdirection(self,x,y): # verify the direction that the robot need to go
        global driveslow,rotate_left,rotate_right,esquerda,direita,direcao_atual,go_front,go_to_path,Graph,path,go_to_path_step,path,savex,savey,LastvisitedNodeSave
        index = self.node_exists(x,y)
        print(f"[antes], LastvisitedNode: {LastvisitedNode}, LastSAVE: {LastvisitedNodeSave}, position: {position}")
        savex,savey = position[0],position[1]
        if index == -1:
            print("ERROR")
            return -1
        print(f" Checking : {index}-> {Graph.nodes[index]['struct']}")
        if Graph.nodes[index]['struct'][direita] == 1:
            rotate_right = 1
            rotate_left = 0
            driveslow = 0
            Graph.nodes[index]['struct'][direita] = 2
            
            print("rotate right")
        elif Graph.nodes[index]['struct'][esquerda] == 1:
            rotate_left = 1 
            rotate_right = 0
            driveslow = 0
            Graph.nodes[index]['struct'][esquerda] = 2
            print("rotate left")
        elif Graph.nodes[index]['struct'][direcao_atual] == 1:
            driveslow = 1
            rotate_left = 0
            rotate_right = 0
            Graph.nodes[index]['struct'][direcao_atual] = 2
            print("go front")
        else:
            print("NO POSSIBLE WAY")
            self.driveAndUpdate(0,0)
            endnode = self.getdistanceInGraph(LastvisitedNode)
            if endnode == "finish":
                path = self.find_minimum_path(x ,y , 0)
                print(f"FINAL PATH ->>>>>>>>>>>>>>> {path} ")
            else:
                path = self.find_minimum_path(x ,y , endnode)
            go_to_path = 1
            rotate_left = 0
            rotate_right = 0
            driveslow = 0
            go_to_path_step = 0
        print(f" nextChecking : {index}-> {Graph.nodes[index]['struct']}")

    def run(self): # principal loop with the robot states : exit , start , run
        
        if self.status != 0:
            print("Connection refused or error")
            quit()
            
        state = 'stop'
        stopped_state = 'run'
        # INICIAL FASE
        self.readSensors()

        # POSICAO ATUAL

        self.x = self.measures.x
        self.y = self.measures.y
        while True:
            self.readSensors()
            if len(checkpointsList) == int(self.nBeacons): #write always
                self.getFinalPath()
            if self.measures.endLed:
                print("exiting")
                quit()
            if state == 'stop' and self.measures.start:
                state = stopped_state
            if state != 'stop' and self.measures.stop:
                stopped_state = state
                state = 'stop'
            if state == 'run':
                if self.measures.ground==0:
                    self.setVisitingLed(True)
                self.wander()
            self.MyRobMap()
            self.SaveFileMap() # save in file "myrob.map" the array self.labMap
                
    #---- MAP RELEVENT FUNCTONS ----
    def setMap(self, labMap): #func to set the map - not really used
        self.labMap = labMap

    def printMap(self): #print the map on the terminal
        for l in reversed (self.labMap):
            print(''.join([str(l) for l in l]))
        print("---------------------------------------------------")
    def MyRobMap(self): #create map in array of the robot in the lab
        # check all nodes in the graph and set the map
        # for node in Graph.nodes:
        #     #aqui
        #     x,y =  Graph.nodes[node]['Position'][0],Graph.nodes[node]['Position'][1]
        #     print(x,y)
        #     self.labMap[y+10][x+24] = "."
        

        # check all edges in the graph
        for edge in Graph.edges:
            edge1 = edge[0]
            edge2 = edge[1]

            edge1_x,edge1_y = Graph.nodes[edge1]['Position'][0],Graph.nodes[edge1]['Position'][1]
            edge2_x,edge2_y = Graph.nodes[edge2]['Position'][0],Graph.nodes[edge2]['Position'][1]
            Xinterr = 0
            if edge1_x==edge2_x:
                Xinterr = 1
            elif edge1_y==edge2_y:
                Xinterr = 0
            else:
                print("ERROR")

            if Xinterr==1:
                # print("SIMMMMMMMMMMMMMMMMMMM")
                for values in range(min(edge1_y,edge2_y),max(edge1_y,edge2_y),1):
                    # print(values)
                    if (values+10) %2 != 0: #impar
                        self.labMap[values+10][edge1_x+24] = "|"
                # print("CLOSE\n\n")
            else:
                for values in range(min(edge1_x,edge2_x),max(edge1_x,edge2_x),1):
                    # print(values)
                    if (edge1_y+10) %2 == 0: #par
                        if (values+24-1)%2 == 0:
                            caracter = "-"
                        else:
                            caracter = " "
                    self.labMap[edge1_y+10][values+24] = caracter

            self.labMap[10][24] = "0"
            for values in checkpointsList:
                tempx,tempy = Graph.nodes[values[1]]['Position'] # get cordinates of node values[1] in graph
                self.labMap[tempy+10][tempx+24] = values[0]
        
    def SaveFileMap(self): # save in file "myrob.map" the array self.labMap
        with open("myrob.map", "w") as f:
            for l in reversed (self.labMap):
                f.write(''.join([str(l) for l in l]))
                f.write('\n')

    def driveAndUpdate(self,x,y): # send values to the motors and estimates future values using  magic formula
        global rotate_left,rotate_right,esquerda,direita,direcao_atual,go_front,go_to_path,Graph,path,go_to_path_step,path,position,compass,previousOutX,previousOutY,sanitezedPosition

        #print 'i entered driveAndUpdate'
        self.driveMotors(x,y)

        #gaussian blur mean 1 variance squared
        x= ((previousOutX + x)/2)
        y= ((previousOutY + y)/2)
        

        #weights for the weighted average
        w1 = 0.5
        w2 = 0.5

        compass= (self.measures.compass )
        #print(self.measures.compass)
        lin = (x + y)
        # print(f"position: {position}")
        position[0] = position[0] + lin * math.cos(math.radians(compass))
        position[1] = position[1] + lin * math.sin(math.radians(compass))


        #possible future imlementation of the compass
        #print math.degrees(compass)
        # valx = math.cos(math.radians(compass))
        # valy = math.sin(math.radians(compass))

        # #format 2 decimal places valx and valy
        # valx = round(valx,2)
        # valy = round(valy,2)


        #print("x: ",valx," y: ",valy," compass: ",compass)

        #print(position)
        
        sanitezedPosition =[round(position[0]/2),round(position[1]/2)]
        # print(f"->position: {position}")
        #if (sanitezedPosition[0] or sanitezedPosition[1]) is not even then add 1 to the value
        # if (sanitezedPosition[0] %2 != 0):
        #     sanitezedPosition[0] = sanitezedPosition[0] + 1"
        # if (sanitezedPosition[1] %2 != 0):
        #     sanitezedPosition[1] = sanitezedPosition[1] + 1
        previousOutX = x
        previousOutY = y


class Map(): #class map - fornecida pelo professor
    def __init__(self, filename):
        tree = ET.parse(filename)
        root = tree.getroot()
        
        self.labMap = [[' '] * (CELLCOLS*2-1) for i in range(CELLROWS*2-1) ]
        i=1
        for child in root.iter('Row'):
           line=child.attrib['Pattern']
           row =int(child.attrib['Pos'])
           if row % 2 == 0:  # this line defines vertical lines
               for c in range(len(line)):
                   if (c+1) % 3 == 0:
                       if line[c] == '|':
                           self.labMap[row][(c+1)//3*2-1]='|'
                       else:
                           None
           else:  # this line defines horizontal lines
               for c in range(len(line)):
                   if c % 3 == 0:
                       if line[c] == '-':
                           self.labMap[row][c//3*2]='-'
                       else:
                           None
               
           i=i+1
    def setMap(self, labMap):
        self.labMap = labMap


rob_name = "pClient1"
host = "localhost"
pos = 1
mapc = None

for i in range(1, len(sys.argv),2):
    if (sys.argv[i] == "--host" or sys.argv[i] == "-h") and i != len(sys.argv) - 1:
        host = sys.argv[i + 1]
    elif (sys.argv[i] == "--pos" or sys.argv[i] == "-p") and i != len(sys.argv) - 1:
        pos = int(sys.argv[i + 1])
    elif (sys.argv[i] == "--robname" or sys.argv[i] == "-r") and i != len(sys.argv) - 1:
        rob_name = sys.argv[i + 1]
    elif (sys.argv[i] == "--map" or sys.argv[i] == "-m") and i != len(sys.argv) - 1:
        mapc = Map(sys.argv[i + 1])
    else:
        print("Unkown argument", sys.argv[i])
        quit()

if __name__ == '__main__':
    rob=MyRob(rob_name,pos,[0.0,60.0,-60.0,180.0],host)
    if mapc != None:
        rob.setMap(mapc.labMap)
        rob.printMap()
    
    rob.run()