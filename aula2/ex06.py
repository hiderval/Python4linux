#dicionario

dicionario = { 
    'nota1':5.5, 
    'nota2':6.5,
    'nota3':3.5
}

soma = 0
media = 0

for chave in dicionario.keys():
    soma += dicionario[chave]
    media = (soma / 3)
    
print(soma)
print(media)
