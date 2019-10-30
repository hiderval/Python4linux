# loop com for
# a primeira casa é o inicial, a segunda casa é o fim e 
# a terceira casa é o passo/incremental

frase = '4 linux open software specialists'
vogais = 'aeiou'

conta_vogal = 0

for letra in frase:
    if letra in vogais:
        conta_vogal += 1
        
print('A frase tem', conta_vogal, 'vogais')
    


exit()

for numero in range(0, 11):
    if numero % 2 == 0:
        print(numero, ' é par ')
    else:
        print(numero, ' é impar ')



exit()
for numero in range(0, 10, 2):
    print(numero)
