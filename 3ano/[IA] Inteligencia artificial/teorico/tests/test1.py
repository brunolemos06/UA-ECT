from doctest import FAIL_FAST


def interpertacoes(lst):
    if lst == []:
        return [[]]
    y = interpertacoes(lst[1:])
    return [ [(lst[0],value)] + z for z in y for value in [True,False]]
#print(interpertacoes(["a","b"]))

def  interpertacoes2(lst):
    if lst == []:
        return [[]]
    ll =  interpertacoes2(lst[1:])
    return [ [(lst[0],value)]+sl for sl in ll for value in [1,2,3] ]

#print(interpertacoes2(["A","B"]))
def provar (f,p):
    if [p] in f:
        return True
    
    # r -> regra
    r = [x for x in f if len(x)>1]
    print(r)
    # p -> regra
    p = [x for x in r if x[0]==p]
    print(p)
    if p == []:
        return False
    return any([all([provar(f,y) for y in x[1:]]) for x in p])

def provar2(lst,p):
    if [p] in lst:
        return True
    # sao sempre true
    regras =  [ x for x in lst if len(x)>1]
    p = [ x for x in regras if x[0]==p ]
    if p == []:
        return False
    return [all([provar2(lst,y) for y in sl[1:]]) for sl in p][0]
    


f,p = [["a"], ["b"],["d"], ["c", "a", "b"],["r","a","d"]], "r"
print( provar2(f,p) )