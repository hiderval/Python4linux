from functools import reduce

#map(funcao, colecao) - from functools import redece
#reduce(funcao, colecao) reduz o resultado para o mais simples possivel
#filter(funcao, colecao)

def quadrado(lista):
    for elemento in lista:
        nova_lista.append(elemento*elemento)

lista = [2, 3, 4, 5, 6, 7]
nova_lista = [x*x for x in lista if x %2 ==0]

print(nova_lista)

#Funcoes anonimas

#def quadrado(n1):
#    return n1 * n1
#linha de baixo, equivalente a linha de baixo - var == quadrado

var = lambda x : x*x
print(var(2))

par = lambda x : x %2 == 0

nova_lista = list(filter(par, lista))
print(nova_lista)

desconto = lambda x : (x * 0.09) + x

nova_lista = list(map(desconto, lista))
print(nova_lista)

lista2 = [x*1.09 for x in lista]
print('lista 2 {}', lista2)

nova_lista = reduce(lambda x,y : x+y, lista)
print(nova_lista)
