class knn_model:
    """
    K-Nearest Neighbours (KNN)

    KNN é um algoritmo de aprendizado supervisionado que estima a probabilidade 
    de um ponto de dados (instância) pertencer a uma classe ou a outra, 
    dependendo de qual classe suas 'k' instâncias mais próximas pertencem.
    
    Argumentos:
        k: distancias mais próximas
        no_class: lista de distâncias sem classificação atribuida
        data: lista de distâncias com classificação atribuida

    Exemplo: 
        knn = knn_model(5, no_class, data)
    """
    
    # Variáveis estáticas
    classes = list()
    
    # criando o método construtor
    def __init__(self, k, no_class, data):
        # cria variável (atributo) dentro do objeto
        self.k = k
        self.no_class = no_class
        self.data = data


    def Euclidean_dist(self, x, y):
        """
        Método que calcula a distância euclidiana entre dois pontos no espaço euclidiano 
        é o comprimento de um segmento de linha entre os dois pontos
        x = lista de pontos p1 -> no_class
        y = lista de pontos p2 -> data

        Argumentos:
            x: lista de distâncias com classificação atribuida
            y: lista de distâncias sem classificação atribuida

        Retorno:
            Um valor float com o calculo entre as distancias x e y.

        Exemplo: 
            x = (6000.0, 2200.0, 5000.0, 1500.0)
            y = (5900.0, 3000.0, 5100.0, 1800.0)
            distancia = 866.0254037844386
            
            knn_model.euclidean_dist(x, y)
        """
        ed = (sum([(a - b)**2 for a, b in zip(x, y)]))**(0.5)
        return ed


    def Perfil(self, index=1):
        """
        Método perfil define a lista de perfis encontrados na lista classificada

        Argumentos:
            index: número da coluna da lista data que identifica a classificação (perfis)

        Retorno:
            Uma lista com as classificações (perfis) encontrados

        Exemplo: 
            knn_model.Perfil()
        """
        
        # Criação de lista classes definidas a partir da lista de dados classificada (treinada)
        knn_model.classes = list(set([i[index] for i in self.data]))
        knn_model.classes.sort()
        return knn_model.classes


    def Classificar(self, debug=False):
        """
        Método para classificar os perfis da lista, com base no modelo Knn de comparação 
        entre distancias dentro dos perfis detectados

        As distancias da lista não classificada (no_class) serão comparadas 
        com a lista classificada (data) para determinar os vizinhos (k) mais próximos
        entre os distancias calculadas. 

        Argumentos:
            debug: auxilia no acompanhamento da execução das linhas comparadas (cpf x perfil)

        Retorno:
            Um dicionário com a classificação dos elementos da lista.

        Exemplo:
            knn_model.Classificar(debug=False)
        """
        
        resultado = dict() # Dicionário para armazenar os dados treinados

        # Percorre a lista de dados sem classificação (não treinada)
        for cpf_no, b_, carteira_no in self.no_class:
            if debug:
                print('Analisando o CPF {}...'.format(cpf_no))

            distanciasknn = list() # Lista para armazenar as distancias mais próximas encontradas (Knn)

            # Percorre a lista de dados com classificação (treinada)
            for cpf_, classe, carteira in self.data:
                distancias = list() # Lista para armazenar todas as distancias calculadas entre os dados treinados / não treinados
                distancia = self.Euclidean_dist(carteira, carteira_no) # Cálcula a distância entre as carteiras (ponto)
                distancias.append(distancia) # Adiciona na lista o cálculo entre os pontos
                distancias.append(classe) # Adiciona na lista a classe do carteira

                if debug:
                    print('Ponto no_class:{} x data:{} = distancia:{}'.format(carteira_no, carteira, distancia))

                distanciasknn.append(distancias) # Adiciona a lista auxiliar distancia na lista distanciaknn

            # Depois de calcular o CPF da carteira não treinada contra todos os CPFs da carteira treinada
            distanciasknn.sort() # Ordena as distâncias encontradas do menor para o maior
            distanciasknn = (distanciasknn[:self.k]) # Defini a quantidade de valores da lista, onde K = vizinhos próximos

            if debug:
                print('Vizinhos próximos:')
                print(distanciasknn)

            classesvizinhas = list() # Lista de classes próximas (distancias/pontos próximos)
            # Percorre as distancias encontradas identificando as classes
            for _, classe in distanciasknn:
                classesvizinhas.append(classe)
            
            classifica = dict() # dicionário para classificação da carteira
            classifica = {x:classesvizinhas.count(x) for x in classesvizinhas} # Dicionário agrupado por classes (Classe : quantidade)
            classificacao = sorted(classifica.items(), key=lambda x: x[1], reverse=True) # Ordena o dicionario do maior para o menor            
            if debug:
                print('Classificar:', classifica)
                print('Classificação:', classificacao[0][0])
                print('\n')

            # Adiciona no dicionário o cpf 
            resultado[cpf_no] = classificacao[0][0] # Identifica o primeiro item do dicionario (Maior valor) com a classificação

        return resultado
