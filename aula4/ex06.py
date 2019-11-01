
cpf = input('Digite o cpf')

with open('arquivo.txt') as f:
        conteudo = f.readlines()
        
        
for registro in conteudo:
    
    if cpf in registro.split():
        
        saida = registro.split()
        
        print('cpf: ', saida [0])
        print('nome: ', saida [1])
        print('idade: ', saida [2])

exit()

nome = input('Informe seu nome: ')

idade = input('Informe sua idade: ')

cpf = input('Informe seu cpf: ')

#print('Nome: {}', 'idade: {}', 'CPF: {}'.format(nome, idade, cpf))

registro = 'Nome: ' + nome + ' Idade: ' + idade + ' cpf: ' + cpf + '\n'

with open('arquivo.txt', 'a') as f:
    f.write(registro)
    
    print(registro)

