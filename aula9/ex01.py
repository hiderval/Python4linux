#mongo db

from pymongo import MongoClient

#exemplo de conexao com parametros
#client = MongoClient(username = 'user', password = 'password', 20019, 'site.exemplo.com')

client = MongoClient()

bd = client.pessoa

# Insert
#bd.pessoa.insert_many()  varios dados
'''
bd.pessoa.insert_one( # um dado
    {
        'nome': 'Tonho',
        'nacionalidade': 'Brasil',
        'idade': 45
    }
)
'''
bd.pessoa.insert_many(
    [
        {
            'nome': 'Tonho',
            'nacionalidade': 'Brasil',
            'idade': 45
        },
        {
            'nome': 'Joao',
            'nacionalidade': 'Portugal',
            'idade': 54
        },
        {
            'nome': 'Arlindo',
            'nacionalidade': 'Argentina',
            'idade': 63
        },
        {
            'nome': 'Antonieta',
            'nacionalidade': 'Bolivia',
            'idade': 33
        }
    ]
)
