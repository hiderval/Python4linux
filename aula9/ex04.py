
from pymongo import MongoClient

client = MongoClient()

bd = client.pessoa

# Delete

bd.pessoa.delete_one({'nome':'Tonho'})
