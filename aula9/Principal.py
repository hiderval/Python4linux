from Funcionario import Funcionario


funcionario = Funcionario()


funcDic = { 1:funcionario.cadastraFunc, 
            2:funcionario.consultaNome,
            3:funcionario.resetaTentativas,
            4:funcionario.atualizaUsuario,
            5:funcionario.removeUsuario,
            6:funcionario.simulaLogin,
            7:exit
}

def main():
    
    while True:
        print("-----------------------------------------")
        print("Sistema de Cadastro de Usuários: ")
        print("1 - Cadastrar Novo Usuário")
        print("2 - Consultar Usuário por Nome")
        print("3 - Resetar tentativas ")
        print("4 - Atualizar Usuário")
        print("5 - Remover Usuário")
        print("6 - Simular login")
        print("7 - Sair")
        print("-----------------------------------------")
        opcao = int(input("Escolha a opção desejada:")) 
        
        if opcao in range(8):
            funcDic[opcao]()
        else:
            print("Opção Inválida.")

if __name__ == "__main__":
    main()
