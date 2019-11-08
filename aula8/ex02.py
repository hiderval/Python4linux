

from BancoDados import * # ConexaoBanco

bd = ConexaoBanco()
bd.inicia_conexao()

SQL = 'SELECT * FROM pessoa'

registros = bd.executaSQL(SQL)

for linha in registros:

            print('-----------------------')
            print('Id: ', linha['id_pessoa'])
            print('Nome: ', linha['nome_pessoa'])
            print('Nacionalidade: ', linha['nacionalidade_pessoa'])
            print('Idade: ', linha['idade_pessoa'])
            print('-----------------------')

bd.fechaConexao()


