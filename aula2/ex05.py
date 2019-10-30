#criar lista com 15 numeros e apresentar a soma

#lista.apepnd(num)

# for , while
lista = []
soma = 0
num = 1

while (num <= 15):
    #input('digite o valor do índice : {} , '.format(num))
    lista.append(num)
    num += 1
print(lista)
    
    
for i in lista:
    
    soma = soma + i
    
print(soma)

    
    
