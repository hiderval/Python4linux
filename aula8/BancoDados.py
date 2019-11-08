
import pymysql.cursors

class ConexaoBanco:
    
    def __init__(self):
        self.host = 'localhost'
        self.usuario = 'root'
        self.password = '4linux'
        self.banco = '4linux'
        self.charset = 'utf8mb4'
        self.conexao = ''
        
    
    def inicia_conexao(self):
        try:
            self.conexao = pymysql.connect(
            host = self.host,
            user = self.usuario,
            password = self.password,
            db = self.banco,
            charset = self.charset,
            cursorclass = pymysql.cursors.DictCursor)
        
        except Exception as err:
            print(err)

    def executaSQL(self, string_sql):
        with self.conexao.cursor() as cursor:
            cursor.execute(string_sql)
            self.conexao.commit()
            return cursor
            
    def fechaConexao(self):
        self.conexao.close()
