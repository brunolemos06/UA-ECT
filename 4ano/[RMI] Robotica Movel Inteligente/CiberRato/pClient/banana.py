
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
go_front = 0

LastvisitedNode = 0
direcaosave = -1
arrayGPS_x = []
arrayGPS_y = []
checkpointsList = []
checkpointsList.append([0,0])

position = [0,0]
compass=0
previousOutX=0
previousOutY=0

sanitezedPosition = [0,0]

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
        global Calcularground,direcao_atual,direita,esquerda,rotate_right,rotate_left,direcao_retaguarda,save,tras,antigo_tras,NodeID,Graph,path,go_to_path_step,direcao,go_to_path,LastvisitedNode,go_front,flagback,ground,arrayGPS_x,arrayGPS_y,direcaosave,checkpointsList,checkid,sanitezedPosition
        x,y = self.getGPS()

        values = [int(v) for v in self.measures.lineSensor]
        # STOP THE PROGRAM WITH KEY
        # if values == [0,0,0,0,0,0,0]:
        #     nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
        #     plt.savefig("graph.png")

        # realx,realy = int(round(self.measures.x-self.xx)) , int(round(self.measures.y-self.yy))
        realx,realy =   self.measures.x-self.xx , self.measures.y-self.yy
        #print(f"Pos={sanitezedPosition} == Real=[{realx},{realy}]")

        # if sys.stdin.read(1):
        ground = self.measures.ground
        self.AtualizarDirecaoAtual()
        # #print("Checkpoints->" , checkpointsList)
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
                

        #Traduz direção absoluta para relativa
        (direita,esquerda,tras) = self.getDireita_Esquerda_Trás(direcao_atual)
        if rotate_right:
            if values == [0,1,1,0,0,0,0] or values == [1,1,1,0,0,0,0] or  values ==[1,1,0,0,0,0,0]: #detecao frente
                if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] != 2:
                    Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = 1
            
            #ROTATE RIGHT
            if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0]) and direcao_atual == self.getDireita_Esquerda_Trás(direcao_retaguarda)[0]:
                rotate_right = 0
                if ground > 0 and [ground,LastvisitedNode] not in checkpointsList:
                    checkpointsList.append([ground,LastvisitedNode])
                # if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] == 0:
                #     Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = -1
                #print(f"{LastvisitedNode} - {Graph.nodes[LastvisitedNode]['struct']}")
            else:
                self.driveAndUpdate(0.06,-0.02)
        elif rotate_left:
            
            if values==[0,0,0,0,1,1,1] or values==[0,0,0,0,0,1,1] or values==[0,0,0,0,1,1,0]: #detecao frente
                if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] != 2:
                    Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = 1
            #ROTATE LEFT
            if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0]) and direcao_atual == self.getDireita_Esquerda_Trás(direcao_retaguarda)[1]:
                rotate_left = 0
                if ground > 0 and [ground,LastvisitedNode]  not in checkpointsList:
                    checkpointsList.append([ground,LastvisitedNode] )
                # if Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] == 0:
                #     Graph.nodes[LastvisitedNode]['struct'][direcao_retaguarda] = -1
                #print(f"{LastvisitedNode} - {Graph.nodes[LastvisitedNode]['struct']}")
            else:
                self.driveAndUpdate(-0.02,0.06)
                
        elif go_front:
            self.drive2(values)
            go_front = 0

        elif go_to_path == 1:
            # #print("PATH:" , path)
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

                # #print("direcao -> ",direcao)
                # #print("esquerda -> ",esquerda)
                # #print("direita -> ",direita)
                # #print("tras -> ",tras)

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
                # #print("back")
                # #print("Direcao atual:{} onde tem de estar: {}".format(direcao_atual,direcao))
                # if (values[2] == 1 and values[3] == 1 and values[4] == 1) or (values[2] == 1 and values[3] == 1 and values[4] == 0) or (values[2] == 0 and values[3] == 1 and values[4] == 1):
                if flagback < 2 :
                    self.driveAndUpdate(-0.01,-0.01)
                    # #print("super back")
                    flagback+=1
                else:
                    # self.AtualizarDirecaoAtual()
                    # #print(f"values : {values} | {direcao}=={direcao_atual}")
                    if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0]) and direcao_atual == direcao:
                        go_to_path_step = 1
                    else:
                        self.driveAndUpdate(0.05,-0.05)

            if go_to_path_step == 1:
                if len(path) == 2:
                    go_to_path = 0
                    go_to_path_step = 0
                    path = []
                    direcao_retaguarda = direcao_atual
                    # #print("DONE")
                    self.drive2(values)
                else:
                    final = Graph.nodes[path[1]]['Position']
                    # if this position is a checkpointList
                    self.driveInFront(values,final,x,y)                 
        else: 
            self.drive(values,x,y)

        save = values

    def drive2(self,values): # go JUST FRONT : CAREFUL USING THIS FUNCTION
        global go_to_path_step,go_to_path,path
        # sppedx > speedy
        # #print("aqui2")

        if values[0] == 0 and values[1] == 1 and values[2]==1 and values[3]==1: # 01 111 00
            self.driveAndUpdate(0.08,0.05)
        elif values[3] == 1 and values[4] == 1 and values[5]==1 and values[6]==0: # 00 111 10
            self.driveAndUpdate(0.044,0.08)
        else:
            self.driveAndUpdate(0.08,0.08)

    def driveInFront(self,values,final,x,y): # PATH DRIVING : FRONT
        global go_to_path_step,go_to_path,path,LastvisitedNode
        # sppedx > speedy
        # #print("aqui")
        speedx = 0.08
        speedy = 0.044
        if final == (x,y):
            go_to_path_step = 0
            path = path[1:]
            return
        if values[6] == 1 and save[6] == 1 and final == (x,y): # FULL DIREITA
            path = path[1:]
            go_to_path_step = 0   
            return 
        if values[0] == 1 and  save[0] == 1 and final == (x,y): # FULL ESQUERDA
            path = path[1:] 
            go_to_path_step = 0   
            return 
        elif values[0] == 0 and values[1] == 1 and values[2]==1 and values[3]==1: # 01 111 00
            self.driveAndUpdate(speedy,speedx)
        elif values[3] == 1 and values[4] == 1 and values[5]==1 and values[6]==0: # 00 111 10
            self.driveMotors(speedx,speedy)
        else:
            self.driveAndUpdate(0.07,0.07) 

    def node_exists(self,x,y): # VERIFY IF NODE EXISTS IN GRAPH
        global Graph
        temp = Graph.nodes()
        # just add node in graph if x,y not in graph
        for i in temp:
            # #print(Graph.nodes[i])
            if Graph.nodes[i]['Position'] == (x,y):
                return i
        return -1

    def getABC(self):
        global checkpointsList,Graph 
        #print("------")
        # save in array all element sin checkpointsList[2]
        newcheckpointsList = []
        for i in checkpointsList[1:]:
            newcheckpointsList.append(i[1])

        allpossibles = list(itertools.permutations(newcheckpointsList))
        # add a[0] in front of each element in b
        for i in range(len(allpossibles)):
            allpossibles[i] = [checkpointsList[0][1]] + list(allpossibles[i]) + [checkpointsList[0][1]]
        
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
        # #print(path_return)
        # #print("--")
        path_return = [path_return[i] for i in range(len(path_return)) if i == 0 or path_return[i] != path_return[i-1]]

        #print(path_return)
        
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
        temp = {}
        for node2 in Graph.nodes():
            if node1 != node2:
                # #print(f"finding[{node2}] {Graph.nodes[node2]['struct']}")
                if Graph.nodes[node2]['struct'][norte] == 1 or Graph.nodes[node2]['struct'][sul] == 1 or Graph.nodes[node2]['struct'][este] == 1 or Graph.nodes[node2]['struct'][oeste] == 1:
                    temp[node2] = nx.shortest_path_length(Graph,source=node1,target=node2,weight='distance')
        # return the node with the shortest distance
        if temp == {}:
            nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
            plt.savefig("graph.png")
            self.getABC()
            self.finish()
            return 1
        return min(temp, key=temp.get)

    def find_minimum_path(self,x,y,endnode): # Function to find the minimum path bewteen two nodes in the graph [ x,y ] -> [ endnode(index) ]
        global Graph
        # #print("endnode",endnode)
        startnode = self.node_exists(x,y)
        if startnode == -1:
            #print("Node not found")
            return -1
        else:
            #algortimo de caminho minimo A*
            # o custo de cada node é 0
            # custo de cada aresta é a distancia euclidiana entre o node de origem e o node de destino
            # custo total de um caminho é a soma dos custos de cada aresta
            # o caminho minimo é o caminho com o menor custo total
            return  nx.astar_path(Graph, startnode, endnode, heuristic=None, weight='distance')          

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

    def drive(self,values,x,y): # drive the robot with the values of the sensors, check the nodes and save the graph 
        global rotate_right,direcao_retaguarda,rotate_left,tras,antigo_tras,deadend,direita,esquerda,NodeID,Graph,LastvisitedNode,start
        
        # sppedx > speedy
        speedx = 0.08
        speedy = 0.044

        
        if deadend == 1: #Resolve Beco-sem-saida
            if (values == [0,0,1,1,1,0,0] or values == [0,0,0,1,1,0,0] or values == [0,0,1,1,0,0,0]) and direcao_atual == self.gettras(direcao_retaguarda):
                deadend = 0
            else:
                self.driveAndUpdate(0.05,-0.05)

        else:
            if values[0] == 1 and values[1] == 1 and values[2] == 1 and save[0] == 1 and save[1] == 1 and save[2] == 1 and values[6] == 1 and values[5] == 1 and values[4] == 1:
                # #print("esquerda direita")
                rotate_right = 1
                direcao_retaguarda = direcao_atual
                # verify is node x,y exists
                index = self.node_exists(x,y)
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

            elif values[6] == 1 and values[5] == 1 and values[4] == 1 and save[6] == 1 and save[5] == 1 and save[4] == 1: # FULL DIREITA
                # #print("direita")
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
                # Graph.nodes[LastvisitedNode]['struct'][esquerda] = -1
                Graph.nodes[LastvisitedNode]['struct'][tras] = 2
                
                antigo_tras = tras
                self.checkdirection(x,y)
            elif values[0] == 1 and values[1] == 1 and values[2] == 1 and save[0] == 1 and save[1] == 1 and save[2] == 1: 
                # #print("esquerda") 
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
                # Graph.nodes[LastvisitedNode]['struct'][direita] = -1
                antigo_tras = tras
                
                self.checkdirection(x,y)
            elif values[0] == 0 and values[1] == 1 and values[2]==1 and values[3]==1: # 01 111 00
                self.driveAndUpdate(speedy,speedx)
            elif values[3] == 1 and values[4] == 1 and values[5]==1 and values[6]==0: # 00 111 10
                self.driveAndUpdate(speedx,speedy)
            elif values == [0,0,0,0,0,0,0] and save == [0,0,0,0,0,0,0]: # DEAD END
                self.driveAndUpdate(-0.6,-0.6)
                if ground > 0 and [ground,LastvisitedNode] not in checkpointsList:
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
                        
                    nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
                    plt.savefig("graph.png")
                    checkpointsList.append([ground,LastvisitedNode])
                    #print("checkpoint IN DEAD END")
                deadend = 1
                direcao_retaguarda = direcao_atual
            else:
                self.driveAndUpdate(0.08,0.08) 
        
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
        # #print(compass)
        if compass<45 and compass > -45:
            direcao_atual = este
        elif compass>45 and compass < 135:
            direcao_atual = norte
            # #print("norte")
        elif compass>135 or compass < -135:
            direcao_atual = oeste
            # #print("oeste")
        elif compass<-45 and compass > -135:
            direcao_atual = sul
    
    def checkdirection(self,x,y): # verify the direction that the robot need to go
        global rotate_left,rotate_right,esquerda,direita,direcao_atual,go_front,go_to_path,Graph,path,go_to_path_step,path
        index = self.node_exists(x,y)
        if index == -1:
            #print("ERROR")
            return -1
        # #print(f" Checking : {index}-> {Graph.nodes[index]['struct']}")
        if Graph.nodes[index]['struct'][direita] == 1:
            rotate_right = 1
            rotate_left = 0
            go_front = 0
            Graph.nodes[index]['struct'][direita] = 2
            
            # #print("rotate right")
        elif Graph.nodes[index]['struct'][esquerda] == 1:
            rotate_left = 1 
            rotate_right = 0
            go_front = 0
            Graph.nodes[index]['struct'][esquerda] = 2
            # #print("rotate left")
        elif Graph.nodes[index]['struct'][direcao_atual] == 1:
            go_front = 1
            rotate_left = 0
            rotate_right = 0
            Graph.nodes[index]['struct'][direcao_atual] = 2
            # #print("go front")
        else:
            #print("NO POSSIBLE WAY")
            self.driveAndUpdate(0,0)
            endnode = self.getdistanceInGraph(LastvisitedNode)
            path = self.find_minimum_path(x ,y , endnode)
            go_to_path = 1
            rotate_left = 0
            rotate_right = 0
            go_front = 0
            go_to_path_step = 0

    def run(self): # principal loop with the robot states : exit , start , run
        global sanitezedPosition
        if self.status != 0:
            #print("Connection refused or error")
            quit()
            
        state = 'stop'
        stopped_state = 'run'
        # INICIAL FASE
        self.readSensors()

        # POSICAO ATUAL
        self.xx = self.measures.x
        self.yy = self.measures.y

        self.x = sanitezedPosition[0]
        self.y = sanitezedPosition[1]
        while True:
            self.readSensors()
            self.MyRobMap()
            self.SaveFileMap() # save in f
            # self.printMap()
            if len(checkpointsList) == int(self.nBeacons): #write always
                self.getABC()
            if self.measures.endLed:
                #print("exiting")
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
                
    #---- MAP RELEVENT FUNCTONS ----
    def setMap(self, labMap): #func to set the map - not really used
        self.labMap = labMap

    def printMap(self): ##print the map on the terminal
        for l in reversed (self.labMap):
            print(''.join([str(l) for l in l]))
        print("---------------------------------------------------")

    def MyRobMap(self): #create map in array of the robot in the lab 
        global sanitezedPosition
        valuex = int(sanitezedPosition[0])
        valuey = int(sanitezedPosition[1])
        print(f"X: {valuex} Y: {valuey}")
        self.labMap[10][24] = "0"
        if (valuey+10) %2 == 0: #par
                if (valuex+24-1)%2 == 0:
                    caracter = "-"
                else:
                    caracter = " "
        else :
            caracter = "|"
        try:
            nodeID = self.node_exists(valuex,valuey) # get node id in graph
            # for values in checkpointsList:
            #     if values[1] == nodeID: #if node is in checkpointsList
            #         caracter = nodeID
            self.labMap[valuey+10][valuex+24] = caracter
        except:
            nx.draw(Graph,pos=nx.get_node_attributes(Graph,'Position'),with_labels=True)
            plt.savefig("graph.png")
            #print("ERROR")
            return 1
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

        ##print 'i entered driveAndUpdate'
        self.driveMotors(x,y)

        #gaussian blur mean 1 variance squared
        x= ((previousOutX + x)/2)
        y= ((previousOutY + y)/2)
        

        #weights for the weighted average
        w1 = 0.5
        w2 = 0.5

        compass= (self.measures.compass )
        ##print(self.measures.compass)
        lin = (x + y)
        position[0] = position[0] + lin * math.cos(math.radians(compass))
        position[1] = position[1] + lin * math.sin(math.radians(compass))


        #possible future imlementation of the compass
        ##print math.degrees(compass)
        # valx = math.cos(math.radians(compass))
        # valy = math.sin(math.radians(compass))

        # #format 2 decimal places valx and valy
        # valx = round(valx,2)
        # valy = round(valy,2)


        ##print("x: ",valx," y: ",valy," compass: ",compass)

        ##print(position)
        
        sanitezedPosition =[round(position[0]/2),round(position[1]/2)]
        # sanitezedPosition =[position[0]/2,position[1]/2]

        # if (sanitezedPosition[0] or sanitezedPosition[1]) is not even then add 1 to the value
        if (sanitezedPosition[0] %2 != 0):
            sanitezedPosition[0] = sanitezedPosition[0] + 1
            # #print("\n0\n")
        if (sanitezedPosition[1] %2 != 0):
            sanitezedPosition[1] = sanitezedPosition[1] + 1
            # #print("\n1\n")

        

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
        #print("Unkown argument", sys.argv[i])
        quit()

if __name__ == '__main__':
    rob=MyRob(rob_name,pos,[0.0,60.0,-60.0,180.0],host)
    if mapc != None:
        rob.setMap(mapc.labMap)
        rob.printMap()
    
    rob.run()