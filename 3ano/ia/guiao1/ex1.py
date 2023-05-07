import math
lista1 = ['1','2','3','4','5']
lista2 = ['3','5','6','7','8']
tuplo  = [(1,2),(3,4),(5,6),(7,8)]

def func1_8(lista1,x,y):
    if not lista1:
        return []

    if lista1[0] == x:
        return [y] + func1_8(lista1[1:],x,y)
    else:    
        return [lista1[0]] + func1_8(lista1[1:],x,y)

def func1_9(list1,list2):
    if not list1:
        return list2
    if not list2:
        return list1
    if list1[0] <= list2[0]:
        return [list1[0]] + func1_9(list1[1:],list2)
    else:
        return  [list2[0]] + func1_9(list1,list2[1:])

def func2_1(lista):
    if not lista:
        return [],[]
        
    elemento1,elemento2 = lista[0]
    return [elemento1]+func2_1(lista[1:])[0],[elemento2]+func2_1(lista[1:])[1]
     
def func3_3(lista1,lista2):
    if len(lista1) != len(lista2):
        return None
    if not lista1:
        return []
    return func3_3(lista1[1:],lista2[1:]) + [(lista1[0] ,lista2[0])]


func4_1 = lambda x : False if x%2==0 else True
func4_2 = lambda x : False if x<=0 else True
func4_3 = lambda x,y : True if abs(x)<abs(y) else false
func4_4 = lambda x,y : ( math.sqrt(x*x+y*y), math.atan(y/x))

print(f"ex1.8 -> " + str( func1_8(lista1,'5','6') ))
print(f"ex1.9 -> " + str( func1_9(lista1,lista2) ))
print(f"ex2.1 -> " + str (func2_1(tuplo)))
print(f"ex3_3 -> " + str (func3_3(lista1,lista2)))
print(f"ex4_1 -> Numero impar : " + str (func4_1(1)))
print(f"ex4_2 -> NUmero Positivo : " + str(func4_2(-1)))
print(f"ex4_3 -> |x| < |y| : " + str (func4_3(1,2)))
print(f"ex4_4 -> polares:" + str(func4_4(10,5)))