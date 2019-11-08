#Exemplo de conexao com banco de dados

import pymysql.cursors
#from env import *


#criar um arquivo ".env" (que ficará oculto) com os dados de conexao ao banco
#USERNAME = 'root'
#PASSWORD = '4linux'

#def main():

try:
    conexao = pymysql.connect(
        host = 'localhost',
        user = 'root', #USERNAME
        password = '4linux', #PASSWORD
        db = '4linux',
        charset = 'utf8mb4',
        cursorclass = pymysql.cursors.DictCursor
    )

except Exception as err:
    print('Nao conectado ao banco\n')
    print(err)

else:
    
    nome = input('Digite o nome: ')
    nacionalidade = input('Digite a nacionalidade: ')
    idade = input('Digite a idade: ')

    with conexao.cursor() as cursor:
        SQL = "SELECT * FROM pessoa"
        #SQL = 'INSERT INTO pessoa (nome_pessoa, nacionalidade_pessoa, idade_pessoa) '
        #SQL += 'VALUES( "{}", "{}", "{}")'.format(nome, nacionalidade, idade)

        cursor.execute(SQL)

        #conexao.commit() #Deve ser incluido em todas as tarefas no banco, exceto select

        for linha in cursor:

            print('-----------------------')
            print('Id: ', linha['id_pessoa'])
            print('Nome: ', linha['nome_pessoa'])
            print('Nacionalidade: ', linha['nacionalidade_pessoa'])
            print('Idade: ', linha['idade_pessoa'])
            print('-----------------------')
finally:

    conexao.close()

#if __name__ == "__main__":
#    main()
