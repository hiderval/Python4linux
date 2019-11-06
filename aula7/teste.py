
import unittest
from funcoes import *
from ex01 import *

class testeFuncoes(unittest.TestCase):
    
    def test_construtor(self):
        c1 = Carro()
        self.assertEqual(0, c1.velocidade)
        self.assertEqual(0, c1.ano)
        self.assertEqual('', c1.cor)
        self.assertEqual('', c1.modelo)
        
        c2 = Carro('Fusca', 'Amarelo', 10, 1980)
        self.assertEqual(10, c2.velocidade)
        self.assertEqual(1980, c2.ano)
        self.assertEqual('Amarelo', c2.cor)
        self.assertEqual('Fusca', c2.modelo)
        
        c3 = Carro()
        c3.acelerar()
        self.assertEqual(10, c3.velocidade)
        
        
        '''
    
    def test_funcSoma(self):
        self.assertEqual(4, soma(2,2))
    
    def test_funcSub(self):
        self.assertEqual(2, sub(4, 2))
    
def test_funcAcelerar(self):
    self.assertEqual(10, acelerar())
    
def test_funcFrear(self):
    self.assertEqual(10, frear())
    '''
if __name__ == '__main__':
    unittest.main()
    
