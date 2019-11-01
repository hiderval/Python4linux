
#Criar um executavel

"""#!usr/bin/python3 """

#parametros em funcoes

    
def subtrai(*numeros):
    resultado = 0
    for num in numeros:
        resultado -= num
    return resultado

def soma(lista):
    resultado = 0
    for num in lista:
        resultado += num
    return resultado


def main():

    #conceito *args
    print(subtrai(10, 20, 30, 40, 50))

    numeros = [1, 2, 3, 4, 5]
    print(soma(numeros))

if __name__ == "__main__":
    main()
