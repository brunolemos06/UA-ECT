def findMin(lista,func):
    if not lista:
        return None

    if len(lista) == 2:
        return (lista[0],lista[1],[])

    ( min1,min2,rest ) = findMin(lista[1:],func)

    if func(lista[0],min1):
        if func(min1,min2):
            return (min1,lista[0],[min2] + rest)
        return (lista[0],min2,[min1] + rest)
        
    if func(lista[0],min2):
        if func(min1,min2):
            return (min1,lista[0],[min2] + rest)
        return (min1,lista[0],[min2] + rest)

    return (min1, min2, [lista[0]] + rest)

lst = [5, -2, 5, 2, 1, 19, 14, 2, 5]
func = lambda x, y: x < y
print(findMin(lst, func))