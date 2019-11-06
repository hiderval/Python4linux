class Conta:


    def __init__(self, nome="", numero="", saldo=0):
        self.nome = nome
        self.numero = numero
        self.saldo = saldo

    def alterarNomeConta(self):
         self.nome = input('Digite o novo nome do titular:\n')
         self.menu()

    def deposito(self):
        novaQuantia = float(input('Informe o valor do depósito:\n'))
        self.saldo = self.saldo + novaQuantia
        self.menu()

    def saque(self):
        novoSaque = float(input('Informe o valor do saque:\n'))
        self.saldo = self.saldo - novoSaque
        self.menu()

    def consulta(self):
        print('Nome do titular: ' + self.nome)
        print('Número da conta: ' + self.numero)
        print('Saldo atual: ' + str(self.saldo))
        print('\n')
        voltaMenu = input("Digite 'r' para retornar ao menu principal:\n")
        if(voltaMenu == 'r'):
            self.menu()
        else:
            print('Opção inválida, digite novamente.')
            self.consulta()

    def menu(self):
        print('Escolha uma das opções para começar:\n')
        print('1 - Alterar nome da conta\n')
        print('2 - Realizar saque\n')
        print('3 - Realizar depósito\n')
        print('4 - Extrato\n')
        print('5 - Consultar detalhes da conta\n')
        print('6- Voltar ao menu inicial\n')
        resposta = input('Opção:\n')
        if(resposta == '1'):
          self.alterarNomeConta()
        elif(resposta == '2'):
          self.saque()
        elif(resposta == '3'):
          self.deposito()
        elif(resposta == '4'):
          print('Seu saldo é de: ' + str(self.saldo))
          self.menu()
        elif(resposta == '5'):
          self.consulta()
        elif(resposta == '6'):
          banco.menuBanco()


class Banco:
    listaDeContas = []


    def iniciaConta(self):
        nome = input('Digite o nome do titular:\n')
        numero = input('Digite o número da conta:\n')
        novaConta = Conta(nome, numero)
        self.listaDeContas.append(novaConta)
        self.menuBanco()

    def acessarConta(self):
        numero = input('Por favor, entre com o número da conta:\n')
        for conta in self.listaDeContas:
            if(numero == conta.numero):
                conta.menu()

    def excluirConta(self):
        numero = input('Por favor, entre com o número da conta:\n')
        for conta in self.listaDeContas:
            if(numero == conta.numero):
                print(conta.nome)
                print(conta.numero)
                resposta = input('Tem certeza da exclusão? [s/n]\n')
                if(resposta == 's'):
                    self.listaDeContas.remove(conta)
                elif(resposta == 'n'):
                    self.menuBanco()
                else:
                    print('Opção inválida!')
                    self.excluirConta()


    def menuBanco(self):
        print('######################################################')
        print('############ Bradesco ################')
        print('######################################################\n')

        print('Escolha uma das opções para começar:\n')
        print('1 - Criar uma conta\n')
        print('2 - Acessar uma conta \n')
        print('3 - Excluir uma conta \n')
        resposta = input('Opção:\n')
        if(resposta == '1'):
            self.iniciaConta()
        elif(resposta == '2'):
            self.acessarConta()
        elif(resposta == '3'):
            self.excluirConta()

banco = Banco()
banco.menuBanco()