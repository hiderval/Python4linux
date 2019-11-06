from Funcoes import *

def main():

    carteira = {}

    while True:

        ops = {
            '1':criarConta,
            '2':consultarSaldo,
            '3':realizarSaque,
            '4':efetuarDeposito,
            '5':efetuarTransferencia,
            '6':exit
        }

        opcao = input('Escolha a opcao: \n1 - Criar Conta \n' +
                        '2 - Consultar Saldo\n3 - Saque \n'   +
                        '4 - Deposito \n5 - Transferencia \n' +
                        '6 - Sair')

        ops[opcao](carteira)

if __name__ == '__main__':
    main()
