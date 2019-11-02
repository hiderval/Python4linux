#Criar classe onibus
#Capacidade
#Velocidade
#origem
#destino


#Comportamentos



class Onibus():
    def __init_ (self):
        self.capacidade = 0
        self.origem = 'Sao Paulo'
        self.destino = 'Guarulhos'
        self.velocidade = 0
        
        
    def acelerar(self):
        self.velocidade += 10
        
    def frear(self):
        if self.velocidade == 0:
            print('Veículo parado!')
        else:
            self.velocidade -= 10
    
    def embarque(self, num_pessoas):
        if self.capacidade == 45 - num_pessoas:
            print('Cheio!!!')
        else:
            self.capacidade += num_pessoas
            
    def desembarque(self, num_pessoas):
        if  self.capacidade == 0:
            print('Vazio')
        else:
            self.lotacao -= 1

onibus = Onibus()
#circular = Onibus('2', 'Sao Paulo', 'Guarulhos', '10')
onibus.capacidade(1)
print(onibus.capacidade)
