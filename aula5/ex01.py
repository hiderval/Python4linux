#criar cadastro de clientes

#def grava[]:
#    registro = ' cpf: ' + cpf + 'Nome: ' + nome + ' Email: ' + email +  '\n'


with open('cadastro.txt') as f:
        conteudo = f.readlines()

cpf = input('Informe seu cpf: ')

nome = input('Informe sua nome: ')

email = input('Informe seu email: ')


registro = 'cpf: ' + cpf + ' Nome: ' + nome + ' Email: ' + email +  '\n'

with open('cadastro.txt', 'a') as f:
    f.write(registro)


for registro in conteudo:

    if cpf in registro.split():

        saida = registro.split()

        print('cpf: ', saida [0])
        print('nome: ', saida [1])
        print('email: ', saida [2])


    print(registro)
