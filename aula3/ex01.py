frutas = { 
    'Banana':1.50, 
    'Morango':3.99,
    'Melancia':5.0
}

cesta = []
total = 0

while True:
    print('Escolha uma fruta:')
    
    print('Banana - 1 ')
    print('Morango - 2 ')
    print('Melancia - 3')
    print('Sair - 4')
    
    escolha = int(input('Escolha a fruta:'))
    
    if escolha == 1:
        cesta.append(frutas['Banana'])
    if escolha == 2:
        cesta.append(frutas['Morango'])
    if escolha == 3:
        cesta.append(frutas['Melancia'])
    if escolha == 4:
        break
    else:
        print('indisponivel')

for valor in cesta:

     total += valor

print(total)


exit()

frutas = ['banana','morango','melancia'] #,'laranja','pera','maca']
cesta = list()

while True:
    print('Escolha uma fruta:')
    print('Banana - 1 ')
    print('Morango - 2 ')
    print('Melancia - 3')
    print('Sair - 4')
    
    escolha = int(input('Escolha a fruta:'))
    
    if escolha == 1:
        cesta.append(frutas[0])
    if escolha == 2:
        cesta.append(frutas[1])
    if escolha == 3:
        cesta.append(frutas[2])
    if escolha == 4:
        break
    else:
        print('indisponivel')

print(cesta)

exit()
#lista

frutas = ['banana','morango','melancia'] #,'laranja','pera','maca']
cesta = []

while True:
    print('Escolha uma fruta:')
    
    print('Banana - 1 ')
    print('Morango - 2 ')
    print('Melancia - 3')
    print('Sair - 4')
    
    escolha = int(input('Escolha a fruta:'))
    
    if escolha == 4:
        break
    elif escolha < 4:
        cesta.append(frutas[escolha - 1])
    else:
        print('indisponivel')

print(cesta)

    #for elemento in frutas:



exit()
dicionario = {'nota1':5.5, 'nota2':7.5, 'nota3':4.5}

soma = 0
media = 0

for elemento in dicionario.values():
    soma = soma + elemento

media = soma / len(dicionario)

print(soma)
print('media: {}'.format(media))
