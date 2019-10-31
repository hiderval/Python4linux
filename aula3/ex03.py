
#sintaxe basica

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

def main():

    num1 = float(input('informe um valor: '))
    num2 = float(input('informe outro valor: '))
    operacao = input('informe a operacao: ')


    if operacao == '-':
        print(sub(num1, num2))
    elif operacao == ('+'):
        print(soma(num1, num2))
    elif operacao == '*':
        print(multi(num1, num2))
    elif operacao == '/':
        print(divi(num1, num2))
    else:
        print('operacao invalida')

if __name__ == "__main__":
    main()

    #resultado = (operacao)


def main():
    x = 10
    y = 15

    resultado = soma(x, y)

    print(soma(10,5))

    print(resultado)

    print(sub(x, y))


if __name__ == "__main__":
    main()
