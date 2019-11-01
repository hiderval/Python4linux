#from funcoes import soma, sub, cestas
from cesta import *

def main():

    dic = {'Banana': 1.50, 'Morango': 3.99, 'Melancia': 4.00}

    while True:

        escolha = int(input('Escolha a fruta:'))

        if escolha == 1:
            adiciona_item(dic['Banana'])
        if escolha == 2:
             adiciona_item(dic['Morango'])
        if escolha == 3:
             adiciona_item(dic['Melancia'])
        if escolha == 4:
            break
        else:
            print('indisponivel')

print(total_carrinho(carrinho))

if __name__ == "__main__":
    main()

