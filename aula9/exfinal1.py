class Pessoa():
    
    from pymongo import MongoClient

    client = MongoClient()

    bd = client.pessoa
    
    def __init__(self, nome = '', nacionalidade = '', idade = ''):
        
        self.nome = nome
        self.nacionalidade = nacionalidade
        self.idade = idade

    def consultar(self, pesquisa):
           
        



def main():

    while True:

        opcao = input('Escolha a operacao: \n' +
                '1 - Cadastrar usuario: \n' +
                '2 - Buscar: \n' +
                '3 - Alterar: \n' +
                '4 - Escluir: \n' +
                '5 - Sair \n')

        if opcao == 1:
            pessoa.consultar()
        elif opcao == 2:
            pessoa.cadastrar()
        elif opcao == 3:
            pessoa.editar()
        elif opcao == 4:
            pessoa.excluir()
        elif opcao == 5:
            break
        else:
            print('Indisponivel')


if __name__ == '__main__':
    main()
        
        
