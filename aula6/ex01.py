#Heranca

class Pai():

    def __init__(self):
        self.nome = ''
        self.idade = 0
        self.nacionalidade = 'brasileira'

    def falar_portugues(self):
        print('Olá, como vai?')

class Mae():
    
    def __init__(self):
        self.nome = ''
        self.idade = ''
    
    def falar_frances(self):
        print('Bonjour!!')

class Filha(Pai, Mae):

    def __init__(self):
        Pai.__init__(self)
        self.profissao = ''
        
    def falar_portugues(self):
        print('Hello!')

f1 = Filha()

f1.falar_portugues()

f1.nome = 'Gabriela'


print(f1.nome)

