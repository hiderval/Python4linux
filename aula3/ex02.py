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
        cesta.append(f'Banana')
    if escolha == 2:
        cesta.append('Morango')
    if escolha == 3:
        cesta.append('Melancia')
    if escolha == 4:
        break
    else:
        print('indisponivel')

for valor in cesta:

     total = total + frutas[valor]

print('R$ ', total)
