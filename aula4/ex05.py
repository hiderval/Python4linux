#arquivos

with open('arquivo.txt', 'r') as f:
    conteudo = f.read()
    #conteudo = conteudo.split()
print(conteudo)



conteudo += 'Olá'

with open('arquivo.txt', 'w+') as f:
     f.write(conteudo)


