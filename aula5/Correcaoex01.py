#criar cadastro de clientes

arq = 'cadastro.txt'

dic = {'cpf': '', 
       'nome': '',
       'email': '',
       'uf': ''
       }

#passo 1 Criar Menu

def main():
    #responsabilidade do fluxo do app

    while True:

        print('Sistema de cadasto')
        opcao = input('Escolha uma opcao:\n' '1 - Cadastro --- '
                                             '2 - Consulta - - - '
                                             '3 - Sair --- ')

        if opcao == '1':
            cadastro()

        elif opcao == '2':
            consulta()

        elif opcao == '3':
            break
        else:
            print('Inexistente')


def cadastro():
    dic['cpf'] = input('cpf: ')
    dic['nome'] = input('nome: ')
    dic['email'] = input('email: ')
    dic['uf'] = input('uf')

    registro = '\n' + dic['cpf'] + ';' + dic['nome']+ ';' + dic['email'] + ';' + dic['uf']

    with open(arq, 'w') as f:
            f.write(registro)


def consulta():
    dic['cpf'] = input('Informe o cpf')
    saida = None
    #abrir o arquivo para consulta
    
    with open(arq, 'r') as f:
        registro = f.readlines()
        
    for linha in registro:
        if dic['cpf'] in linha.split(';'):
            saida = linha.split(';')
            print('CPF', saida[0])
            print('nome', saida[1])
            print('email', saida[2])
            print('uf', saida[3])
            
     #  else: '''else dentro do for '''
     #      print('Nao Encontrei')       
    if saida == None:
        print('Nao encontrado')


if __name__ == "__main__":
    main()
