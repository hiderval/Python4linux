from pymongo import MongoClient

client = MongoClient()

bd = client.pessoa

# Busca

for registro in bd.pessoa.find():
    print(registro)

print(bd.pessoa.find({'nome':'arlindo'}))

for registro in bd.pessoa.find({'idade':45}):
    print(registro['nacionalidade'])
