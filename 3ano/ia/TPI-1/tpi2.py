#encoding: utf8
# Code by Bruno Lemos  : 98221
# Code discussed with  ->
# Andre Clerigo        : 98485
# Pedro Rocha          : 98256
# João Amaral          : 98373
# Joao Viegas          : 98372
from gc import collect
from semantic_network import *
from bayes_net import *
from collections import Counter
from itertools import product
import time

class MySemNet(SemanticNetwork):
    def source_confidence(self,user):
        (correct,wrong) = (0,0)
        lista_decl = [decl for decl in self.declarations if ( isinstance(decl.relation, AssocOne) and decl.user == user) ]
        for decl in lista_decl:
            ldecl_total = [d for d in self.declarations if isinstance(d.relation, AssocOne)]
            lcommon = Counter([d.relation.__repr__() for d in ldecl_total if d.relation.entity1 == decl.relation.entity1 and d.relation.name == decl.relation.name]).most_common(2) 
            if len(lcommon) == 1:
                correct+=1
            else:
                if lcommon[1][1] == lcommon[0][1]: correct+=1
                else:
                    if decl.relation.__repr__() == lcommon[0][0]: correct += 1
                    else: wrong +=1
        return (0.75**wrong)*(1 - 0.75**correct)

    def query_with_confidence(self,entity,assoc):
        (dictionary_conf,dict_2) = ({},{})
        ldeclartions = self.query_local(e1=entity)
        listastr_relation = [decl.relation.__repr__() for decl in ldeclartions if isinstance(decl.relation, AssocOne) and decl.relation.name == assoc]
        listarelation = [decl.relation for decl in ldeclartions if isinstance(decl.relation, AssocOne) and decl.relation.name == assoc]
        sizeof_listastr_relation = len(listastr_relation)
        lrel_counter = Counter(listastr_relation)
        for elem_relation in listarelation:
            number = lrel_counter[elem_relation.__repr__()]
            dictionary_conf[elem_relation.entity2] = (number / (2*sizeof_listastr_relation)) + (1 - (number / (2*sizeof_listastr_relation))) * (1 - (0.95**number))*(0.95**(sizeof_listastr_relation-number)) 
        lparents = list(set([d.relation.entity2 for d in ldeclartions if not isinstance(d.relation, AssocOne) and not isinstance(d.relation, AssocSome)]))
        for values in lparents:
            query_res = self.query_with_confidence(values, assoc)
            for item in query_res.items():
                (item1,item2) = item[0],item[1]
                if item1 in dict_2:
                    dict_2[item1] += item2
                else:
                    dict_2[item1] = item2

        for item in dict_2.items():
            dict_2[item[0]] = item[1]/ len(lparents)

        if not dict_2: return dictionary_conf

        if not dictionary_conf :
            for item in dict_2.items():
                dict_2[item[0]] = item[1]*0.9
            return dict_2

        for item in dict_2.items():
            dict_2[item[0]] = item[1]*0.1

        for item in dictionary_conf.items():
            dictionary_conf[item[0]] = item[1]*0.9

        for item in dict_2.items():
            if item[0] in dictionary_conf:
                dictionary_conf[item[0]] += item[1]
            else:
                dictionary_conf[item[0]] = item[1]
        return dictionary_conf
class MyBN(BayesNet):
    def individual_probabilities(self):
        dictionary={}
        for k in self.dependencies.keys():
            dictionary[k] = self.individualProb(k, 1)
        return dictionary
    def individualProb(self,var,val):
        prob = 0
        lista = list(set(self.ligacao_anterior(var)))
        ligacao_anterior = list(map(lambda c : list(zip(lista, c)),product([1,0], repeat=len(lista))))
        for conj in ligacao_anterior:
            prob += self.jointProb(conj + [(var, val)])
        return prob
    def ligacao_anterior(self, var):
        lista = list(self.dependencies[var].keys())[0]
        listavariveis = [item[0] for item in lista]
        res = listavariveis
        for values in listavariveis:
            res+= self.ligacao_anterior(values)
        return res