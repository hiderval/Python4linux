
#apis
#https://viacep.com.br/ws/06223040/json
#pip3 install requests

import requests
contador = 000

while (contador < 1000):
    
    consulta = 09910
    cep =  ("{}{}".format(09910, contador))

    #end point
    destino = 'https://viacep.com.br/ws/' + cep +'/json'

    resposta = requests.get(destino)

    if resposta.status_code == 200:
        json = resposta.json()

        print('CEP', json['cep'])
        print('LOGRADOURO', json['logradouro'])
        print('BAIRRO', json['bairro'])
        print('UF', json['uf'])
        print('IBGE', json['ibge'])
        print('GIA', json['gia'])
    else:
        print('Erro!')
        print(resposta)
        print(contador)
        print(destino)
        
        contador = contador + 100
