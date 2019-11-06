
class TestError(Exception):
    def __init__(self):
        print('Mensagem de erro')


while True:
    try:
        #bloco tentativa
        
        opcao = int(input('Escolha a opcao: '))
    #except Exception as err:
    except ValueError as err:
        
        print(err)
        print('Informe numeros', err)

    finally:
        print('Sempre executarei este bloco')
        
        
    try:
        with open('arquivoNaoExiste.txt') as f:
            conteudo = f.read()
    except FileNotFoundError as err:
        print('Arquivo nao encontrado', err)
        
    
    try:
        n1 = 5
        n2 = 0
        print(n1/n2)
    except Exception as err:
            print(err)
    if 5 > 3:
        raise TestError()
        raise ZeroDivisionError('Mensagem')
    else:
        pass
        
        
