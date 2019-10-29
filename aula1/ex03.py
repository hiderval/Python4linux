#Habilitacao

#Verificar idade

#Possui Habilitacao?

idade = int(input('Digite a sua idade: '))
hab = input('Possui habilitacao? ')

# Verificar se maior de 18

if (idade >= 18 and hab == 'sim'):
    print('Pode dirigir')
else:
    print('Nao atende requisitos minimos')


exit()

if (idade >= 18):
    if(hab == 'sim'):
        print('Pode dirigir')
    else:
        print('Nao possui habilitacao')
else:
    print('Nao possui idade minima')
    
    

