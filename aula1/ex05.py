#Exercicio 05

ano = int(input('Informe seu ano de nascimento: '))


if (ano < 1965):
    print('Voce eh da geracao Babyboomer')
elif (ano > 1964 and ano < 1982):
    print('Voce eh da geracao X')
elif (ano > 1980 and ano < 1997):
    print('Voce eh da geracao Y')
elif (ano > 1995):
    print('Voce eh da geracao Z')
else:
    print('Periodo invalido')


