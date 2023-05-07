import time
import random
import json
def writeJSON(data,var):
    with open(f'{var}.json','w') as fp:
        json.dump(data,fp)

def readJSON(var):
    with open(f'{var}.json') as f:
        return json.load(f)

while True:
    data = readJSON("cordenadas")
    len(data)
    # generate number between -3 and 3
    number = random.randint(-4,3)
    numero_pessoas = len(data)
    if number + numero_pessoas >= 0:
        numero_pessoas += number
    else:
        numero_pessoas -= 1

    print(f"Numero de pessoas -> {numero_pessoas}")
    data2 = {}
    for i in range(numero_pessoas) :
        indicie = i + 1
        if str(indicie) in data2:
            data2[str(indicie)] = {'x':random.randint(2,98),'y':random.randint(2,98)}
        else:
            copia = {'x':random.randint(2,98),'y':random.randint(2,98)}
            data2[str(indicie)] = copia
    writeJSON(data2,"cordenadas")
    time.sleep(5)