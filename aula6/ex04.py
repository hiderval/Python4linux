
#Aproveitando a classe ex03

from ex03 import *

#criar uma interface para:

##1-Criar contas
##2-Realizar operacoes bancarias:
    ##2.1: Consultar saldo
    ##2.2: Realizar saque
    ##2.3: Efetuar deposito
    ##2.4: Fazer transferencia

while True:

    opcao = input('Escolha a operacao: ')
    print('1 - Saque:')
    print('2 - Depósito: ')
    print('3 - Transferencia ')
    print('4 - Saldo')
    print('5 - Sair')

    if opcao == 1:
        caixa.sacar()
    elif opcao == 2:
        caixa.deposito()
    elif opcao == 3:
        caixa.transferencia()
    elif opcao == 4:
        caixa.ver_saldo()
    elif opcao == 5:
        break
    else:
        print('Indisponivel')
        
        
