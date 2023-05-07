import networkx as nx
import matplotlib.pyplot as plt

from c2_goodVersion import Graph
def node_exists(Graph,x,y):
    temp = Graph.nodes()
    # just add node in graph if x,y not in graph
    for i in temp:
        # print(Graph.nodes[i])
        if Graph.nodes[i]['pos'] == (x,y):
            return i
    return -1

norte = 0
sul = 1
este = 2
oeste = 3

G = nx.Graph()
Nodes = {0,(0,0)} #node list key and position initiated With root node
# G.add_node(1, pos=(0, 0),struct={norte:1,sul:0,este:2,oeste:2})
G.add_node(0, pos=(2, 0),struct={norte:0,sul:0,este:2,oeste:2})
G.add_node(1, pos=(-4, 0),struct={norte:0,sul:0,este:2,oeste:0})
G.add_node(2, pos=(4, 0),struct={norte:2,sul:1,este:2,oeste:2})
G.add_node(3, pos=(6, 2),struct={norte:2,sul:2,este:0,oeste:2})
G.add_node(4, pos=(6, 4),struct={norte:0,sul:2,este:0,oeste:0})
G.add_node(5, pos=(6, 0),struct={norte:2,sul:0,este:0,oeste:2})
G.add_node(6, pos=(4, 2),struct={norte:0,sul:2,este:2,oeste:1})


G.add_edge(1, 0)
G.add_edge(0, 2)
G.add_edge(2, 6)
G.add_edge(6, 3)
G.add_edge(3, 4)
G.add_edge(3, 5)
G.add_edge(2, 5)

save_x,save_y=0,0
super = nx.Graph()
for value in G.nodes:
    for value2 in G.nodes:
        if G.has_edge(value,value2):
            x,y=G.nodes[value]['pos']
            save_x,save_y = G.nodes[value2]['pos']
            while(abs(save_x-x) > 2):
                if save_x > x:
                    super.add_node(9, pos=(save_x-2, y),struct={norte:0,sul:0,este:2,oeste:2})
                    save_x-=2
                else:
                    super.add_node(10, pos=(save_x+2, y),struct={norte:0,sul:0,este:2,oeste:2})
                    save_x+=2
            while(abs(save_y-y) > 2):
                if save_y > y:
                    super.add_node(11, pos=(x, save_y-2),struct={norte:2,sul:2,este:0,oeste:0})
                    save_y-=2
                else:
                    super.add_node(12, pos=(x, save_y+2),struct={norte:2,sul:2,este:0,oeste:0})
                    save_y+=2
            super.add_node(value, pos=(x, y),struct=G.nodes[value]['struct'])

# copy super to G
# supesuper = nx.Graph()
# for value in super.nodes:
    # for value2 in super.nodes:
        # if value != value2:
            #se a posicao de value2 e value for igual
            # if super.nodes[value]['pos'] != super.nodes[value2]['pos']:
                # supesuper.add_node(value, pos=super.nodes[value]['pos'],struct=super.nodes[value]['struct'])


pos = nx.get_node_attributes(G, 'pos')
mainstrct = nx.get_node_attributes(G, 'struct')
# first element in mainstrct
# print(mainstrct[1][norte])
nx.draw(G, pos, with_labels=True)
plt.show()


pos = nx.get_node_attributes(super, 'pos')
mainstrct = nx.get_node_attributes(super, 'struct')
# first element in mainstrct
# print(mainstrct[1][norte])
nx.draw(super, pos, with_labels=True)
plt.show()

remove =[]
new = nx.Graph()
index = 0
for x in range(-12,12,2):
    for y in range(-12,12,2):
        indexx = node_exists(new,x,y)
        if indexx != -1:
            continue
        indey = node_exists(super,x,y)
        print(x)
        print(y)
        print(indey)
        if indey == -1:
            new.add_node(index, pos=(x, y),Navigate=1)
            index+=1
        else:
            struct = mainstrct[indey]
            if struct[norte] == 0:
                remove.append([x,y+2])
            if struct[sul] == 0:
                remove.append([x,y-2])
            if struct[este] == 0:
                remove.append([x+2,y])
            if struct[oeste] == 0:
                remove.append([x-2,y])
            new.add_node(index, pos=(x, y),Navigate=1)
            index+=1
            


# remove all nodes with x,y in remove list
for x in remove:
    indexx = node_exists(new,x[0],x[1])
    if indexx != -1:
        new.remove_node(indexx)
        
# add edges if distance is 2
for node in new.nodes:
    for other in new.nodes:
        if node != other:
            if abs(new.nodes[node]['pos'][0] - new.nodes[other]['pos'][0]) == 2 and new.nodes[node]['pos'][1] == new.nodes[other]['pos'][1]:
                new.add_edge(node, other)
            elif abs(new.nodes[node]['pos'][1] - new.nodes[other]['pos'][1]) == 2 and new.nodes[node]['pos'][0] == new.nodes[other]['pos'][0]:
                new.add_edge(node, other)

pos = nx.get_node_attributes(new, 'pos')
nx.draw(new,pos ,with_labels=True)
plt.show()