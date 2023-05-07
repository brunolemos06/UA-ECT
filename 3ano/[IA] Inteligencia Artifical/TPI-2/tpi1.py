# Code by Bruno Lemos : 98221
# Code discussed with->
# Andre Clerigo : 98485
# Pedro Rocha   : 98256
# João Amaral   : 98373
# Joao Viegas   : 98372

from tree_search import *
from cidades import *
import random

class MyNode(SearchNode):
    def __init__(self,state,parent,depth,cost,heuristic):
        super().__init__(state,parent)
        self.depth = depth
        self.cost = cost
        self.heuristic = heuristic
        self.eval = self.cost + self.heuristic
        self.children = []
        
class MyTree(SearchTree):

    def __init__(self,problem, strategy='breadth',seed=0): 
        super().__init__(problem,strategy,seed)
        root = MyNode(problem.initial,None,0,0,problem.domain.heuristic(problem.initial,problem.goal))
        self.all_nodes = [root]
        self.terminals=0 
        self.solution_tree = None
        self.used_shortcuts = []

    def astar_add_to_open(self,lnewnodes):
        self.open_nodes.extend(lnewnodes)
        self.open_nodes.sort(key = lambda id : self.all_nodes[id].cost + self.all_nodes[id].heuristic)

    def propagate_eval_upwards(self,node):
            best = min(node.children, key = lambda node: node.eval)
            node.eval = best.eval
            
            while node.parent != None:
                node = self.all_nodes[node.parent]
                best = min(node.children, key = lambda node: node.eval)
                node.eval = round(best.eval)

    def search2(self,atmostonce=False):
        # procurar a solucao
        while self.open_nodes != []:
            nodeID = self.open_nodes.pop(0)
            node = self.all_nodes[nodeID]
            if self.problem.goal_test(node.state):
                self.solution = node
                self.terminals = len(self.open_nodes)+1
                return self.get_path(node)
            lnewnodes = []
            self.non_terminals +=1
            for a in self.problem.domain.actions(node.state):
                newstate = self.problem.domain.result(node.state,a)
                if newstate not in self.get_path(node):
                    ## code ##
                    new_node = MyNode(newstate,nodeID, node.depth+1, node.cost + self.problem.domain.cost(node.state, a), self.problem.domain.heuristic(newstate, self.problem.goal))
                    node.children.append(new_node)
                    self.propagate_eval_upwards(node)

                    if atmostonce:
                        flag = False
                        for point_node in self.all_nodes:

                            if point_node.state == newstate:
                                flag = True
                                if point_node.cost > new_node.cost:
                                    point_node.cost = new_node.cost
                                    point_node.parent = new_node.parent
                        if not flag:
                            self.all_nodes.append(new_node)
                            lnewnodes.append(len(self.all_nodes)-1)
                            flag=False
                    else:
                        self.all_nodes.append(new_node)
                        lnewnodes.append(len(self.all_nodes)-1)
            self.add_to_open(lnewnodes)
        return None

    def repeated_random_depth(self,numattempts=3,atmostonce=False):
        save_tree = self
        save_search = save_tree.search2(atmostonce)

        for i in range(numattempts):
            tree = MyTree(self.problem, 'rand_depth', i) # criar tree
            search = tree.search2(atmostonce) #pesquisa
            if tree.solution.cost < save_tree.solution.cost: # escolher o melhor
                save_tree = tree
                save_search = search
            #numattempts-=1
        self.solution_tree = save_tree # save
        return save_search

    def make_shortcuts(self):
        solution_path = self.get_path(self.solution)
        size = len(solution_path)
        for element in range(len(solution_path)):
            if solution_path[element] != '0':
                for value in self.problem.domain.actions(solution_path[element]):
                    newsize = size-1
                    for index in range(newsize,0,-1):
                        if  index-element > 1 and solution_path[index] != '0' and self.problem.domain.result(solution_path[element],value) == solution_path[index] :
                            self.used_shortcuts += [(solution_path[element],solution_path[index])]
                            solution_path[element+1:index] = '0'
        return [value for value in solution_path if value != '0']
class MyCities(Cidades):

   def maximum_tree_size(self,depth):   # assuming there is no loop prevention
        somatorio = 0
        for coord in self.coordinates:
            somatorio += len(self.actions(coord))
        avg = somatorio/len(self.coordinates)
        return sum([avg**k for k in range(depth+1)])