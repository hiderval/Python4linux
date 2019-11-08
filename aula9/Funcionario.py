from BancoDeDados import BancoDeDados
from getpass import getpass


class Funcionario:
    def __init__(self):
        self.cpf = ''
        self.nome = ''
        self.endereco = ''
        self.idade = ''
        #login
        self.username = ''
        self.password = ''
        self.tentativas = ''
        self.qtde_acesso = ''
        
    
    def cadastraFunc(self):
        print("Insira os dados :")
        self.cpf = input("CPF: ")
        self.nome = input("Nome: ")
        self.endereco = input("Endereço: ")
        self.idade = input("Idade :")
        self.username = input("Login: ")
        self.password = getpass("Digite a Senha:") 
        self.validaSenha(self.password)
        self.tentativas = 3
        self.quantidade_acesso = 0

        bd = BancoDeDados()
        bd.iniciaConexao()
        SQL = "INSERT INTO funcionario VALUES('{}','{}','{}', {})".format(self.cpf,self.nome,self.endereco,self.idade)
        result = bd.executaSQL(SQL)
        
        SQL = "INSERT INTO login VALUES ('{}', '{}', '{}', {}, {})".format(self.cpf, self.username, self.password,self.tentativas, self.quantidade_acesso) 
        result = bd.executaSQL(SQL)
        bd.conexao.commit()
        bd.terminaConexao()
    
    
    def consultaNome(self): 
        self.nome = input(("Digite o nome para busca :"))
        
        bd = BancoDeDados()
        bd.iniciaConexao()
        SQL = "SELECT * FROM funcionario WHERE nome like '%{}%'".format(self.nome)
        result = bd.executaSQL(SQL)
        
        for linha in result:
            print("--------------------------------------------")
            print("CPF:", linha["cpf"])
            print("Nome:", linha["nome"])
            print("Endereço:", linha["endereco"])
            print("Idade:", linha["idade"])
        
        bd.terminaConexao()
        
    def atualizaUsuario(self):
        self.cpf = input(("Digite o CPF para busca :"))
        
        bd = BancoDeDados()
        bd.iniciaConexao()
        SQL = "SELECT * FROM funcionario WHERE cpf = '{}'".format(self.cpf)
        result = bd.executaSQL(SQL)
        
        for linha in result:
            print("--------------------------------------------")
            print("CPF:", linha["cpf"])
            print("Nome:", linha["nome"])
            print("Endereço:", linha["endereco"])
            print("Idade:", linha["idade"])
        
        print("Autalize os dados :")
        self.nome = input("Nome: ")
        self.endereco = input("Endereço: ")
        self.idade = input("Idade :")
        
        SQL = "UPDATE funcionario set nome = '{}', endereco = '{}', idade = {} WHERE cpf = '{}'".format(self.nome, self.endereco,self.idade, self.cpf)
        result = bd.executaSQL(SQL)
        bd.conexao.commit()
        bd.terminaConexao()
        
        
    def removeUsuario(self):
        self.cpf = input(("Digite o CPF para busca :"))
        
        bd = BancoDeDados()
        bd.iniciaConexao()
        SQL = "SELECT * FROM funcionario WHERE cpf = '{}'".format(self.cpf)
        result = bd.executaSQL(SQL)
        
        for linha in result:
            if self.cpf in linha.values():
                print("--------------------------------------------")
                print("CPF:", linha["cpf"])
                print("Nome:", linha["nome"])
                print("Endereço:", linha["endereco"])
                print("Idade:", linha["idade"])
            
                if input("Confirma Exclusão? (1-Sim / 2-Não)") == '1':
                    SQL = "DELETE FROM funcionario where cpf = {}".format(self.cpf)
                    result = bd.executaSQL(SQL)
                    bd.conexao.commit()
                else:
                    print("Cancelado pelo usuário") 
            else:
                print("Registro não encontrado")
        
    def validaSenha(self, senha):
        while True:
            if getpass("Insira a senha novamente: ") != self.password:
                print("As senhas não conferem. Digite novamente")
            else:
                break
    
    def resetaTentativas(self):
        self.cpf = input(("Digite o CPF para busca :"))
        
        bd = BancoDeDados()
        bd.iniciaConexao()
        SQL = "SELECT * FROM funcionario WHERE cpf = '{}'".format(self.cpf)
        result = bd.executaSQL(SQL)
        
        for linha in result:
            if self.cpf in linha.values():
                print("--------------------------------------------")
                print("CPF:", linha["cpf"])
                print("Nome:", linha["nome"])
                print("Endereço:", linha["endereco"])
                print("Idade:", linha["idade"])
            
                if input("\nDeseja resetar o número de tentativas? (1-Sim / 2-Não)") == '1':
                        SQL = "UPDATE login SET tentativas = 3 WHERE cpf_login = '{}'".format(self.cpf)
                        result = bd.executaSQL(SQL)
                        bd.conexao.commit()
                else:
                    print("Cancelado pelo usuario")
            else:
                print("Registro não encontrado")
        
        

    def simulaLogin(self):
        while True:
            self.username = input("Login : ")
            self.password = getpass("Senha: ")
            senha = ''
            
            bd = BancoDeDados()
            bd.iniciaConexao()
            SQL = "SELECT login, senha, qtde_acesso, tentativas FROM login WHERE login = '{}'".format(self.username)
            
            result = bd.executaSQL(SQL)
            
            for linha in result:
                if self.username in linha.values():
                    senha = linha["senha"]
                    self.qtde_acesso = linha["qtde_acesso"]
                    self.tentativas = linha["tentativas"] 
                else:
                    print("Usuário não encontrado.")
                    retur
                    
            if self.tentativas == 0:
                print("Conta bloqueada. Entrar em contato com o Administrador.")    
                return
                
            if self.qtde_acesso == 0:
                print("Primeiro acesso:")
                self.password = getpass("Informe nova senha:") 
                self.validaSenha(self.password) 
                self.qtde_acesso += 1
                SQL = "UPDATE login SET senha = '{}', qtde_acesso = {} WHERE login = '{}'".format(self.password, self.qtde_acesso,self.username)
                bd.executaSQL(SQL)
                bd.terminaConexao()
                return
            
            if senha != self.password:
                
                print("Senha Invalida. Tente novamente") 
                if self.tentativas != 0:
                    self.tentativas -= 1
                SQL = "UPDATE login SET tentativas = '{}' WHERE login = '{}'".format(self.tentativas,self.username)
                bd.executaSQL(SQL)
                bd.terminaConexao()
            else:
                print("Login efetuado com sucesso")
                return
                
    
        
