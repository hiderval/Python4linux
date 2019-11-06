#Criar um arquivo de classe baseado no
#arquivo carro

#criar um arquivo de testes e testar:

#construtor
#metodos acelerar, frear


class Carro():
    
    #construtor
    '''
    
    def __init__(self):
        self.modelo = ''
        self.cor = ''
        self.velocidade = '0'
        self.ano = '0'
    '''
    # segunda forma de costrutor
    #def __init__(self, modelo, cor, velocidade, ano): ou
    def __init__(self, modelo = '', cor = '', velocidade = 0, ano = 0):
     
        self.modelo = modelo
        self.cor = cor
        self.velocidade = velocidade
        self.ano = ano
        
    def acelerar(self):
        self.velocidade += 10
        
    def frear(self):
        if self.velocidade == 0:
            print('Parado')
        else:
            self.velocidade -= 10
    
