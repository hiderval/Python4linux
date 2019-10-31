def soma(num1, num2):
    resultado = num1 + num2
    return resultado

def sub(num1, num2):
    return num1 - num2

def multi(num1, num2):
    resultado = num1 * num2
    return resultado
def divi(num1, num2):
    if num2 == 0:
        print('Náo se divide por 0')
    else:
        resultado = num1 / num2
        return resultado
        
def main()
    dic = {'+':soma, '-':sub, '*':multi, '/':divi}
    
    num1 = int(input('Numero 1: '))
    num2 = int(input('Numero 2: '))
    
    opcao = input('Escolha a operacao')
    
if __name__ == "__main__":
main()
