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
