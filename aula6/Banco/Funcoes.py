
from ContaBancaria import Conta


def criaConta(carteira):
    
    print('Informe os dados:')
    
    agencia = input('Agencia: ')
    conta = input('conta: ')
    titular = input('titular: ')
    saldo = 0
    
    carteira[titular] = Conta(agecia, conta, titular, saldo)
    
    
def consultarSaldo(carteira):
    conta = input('Informe a conta: ')
    
    for elemnto in carteira.values():
        if elemento.getConta() == conta:
            print(elemento.verSaldo())
            break
            
    else:
        print('Conta nao cadastrada!!')


def realizarSaque(carteira):
    conta = input('Informe a conta: ')
    valor = float(input('Informe o valor do saque: '))
    
    for elemnto in carteira.values():
        if elemento.getConta() == conta:
            print(elemento.saque(valor))
            break
            
    else:
        print('Conta nao cadastrada!!')
        
        
def efetuarDeposito(carteira):
    conta = input('Informe a conta: ')
    valor = float(input('Informe o valor do deposito: '))
    
    for elemnto in carteira.values():
        if elemento.getConta() == conta:
            print(elemento.deposito(valor))
            break
            
    else:
        print('Conta nao cadastrada!!')
    

def efetuarTransferencia(carteira):
    if len(carteira) < 2:
        print('Numero de contas insuficientes!!')
    else:
        conta = input('Informe a conta de origem: ')
        valor = float(input('Informe o valor da transferencia: '))
        destno = input('Informe a conta de destino: ')

    for contaOrigem in carteira.values():
        if contaOrigem.getConta() == conta:
            for contaDestino in carteira.values():
                if contaDestino.getConta() == destino:
                    contaOrigem.transferencia(valor, contaDestino)
                    print('Transferencia realizada com sucesso!!')
                    break
    else:
        print('Conta nao encontrada para transferencia')

