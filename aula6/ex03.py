#Criar uma classe conta bancaria
#Ela devera conter os seguintes atruibutos
##Agencia
##Conta
##Titular
##Saldo

#Os comportamentos esperados de uma conta sao

##Saque <- Validar se tem dinheiro
##Deposito
##Ver saldo


class Conta():
    
    def __init__(self, banco = '', agencia = '', conta = '', titular = '', saldo = ''):
        
        self.banco = banco
        self.agencia = agencia
        self.conta = conta
        self.titular = titular
        self.saldo = saldo

    def sacar(self, saque):
        if self.saldo >= saque:
            self.saldo -= saque
            print('Saque realizado com sucesso ', self.saldo)
        else:
            print('Saldo insuficiente')

    def deposito(self, deposita):
        self.saldo += deposita 
        print('Deposito realizado com sucesso', self.saldo)            

    def ver_saldo(self):
        print('Seu saldo é: ', self.saldo)
        
    def transferencia(self, valor, conta):
        if valor > self.saldo:
            print('Saldo insufuciente')
        else:
            self.saldo += valor
            conta.saldo += valor #conta esta instanciando um novo objeto conta                            


#bradesco = Conta()
bradesco = Conta('Bradesco', '789', '987', 'Tu', 70)

#bradesco.sacar(10)

#bradesco.deposito(10)

#bradesco.sacar(11)

#bradesco.ver_saldo()

#print(bradesco.saldo)

caixa = Conta('caixa', '123', '321', 'Eu', 80)

 
bradesco.transferencia(70, caixa)

#bradesco.ver_saldo()

##caixa.ver_saldo()



    
