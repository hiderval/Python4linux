

from pymongo import MongoClient

client = MongoClient()

bd = client.pessoa

# Update

bd.pessoa.update_one({'nome':'Tonho'}, {"$set":{'nome':'Josefa'}}) #sem {"$set"} sobrescreve todos os campos
