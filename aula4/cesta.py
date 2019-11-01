
#funcoes e variaveis do modelo

#passo 1

carrinho = []

def adiciona_item(valor):
    carrinho.append(valor)
    
def total_carrinho(lista_compras):
    soma = 0
    for item in lista_compras:
        soma += item 
    return soma
