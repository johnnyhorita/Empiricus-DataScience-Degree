def euclidean_dist (x,y):
    """
    A distância euclidiana entre dois pontos no espaço euclidiano é o comprimento de um 
    segmento de linha entre os dois pontos
    lista_class = lista de pontos p1
    lista_nclass = lista de pontos p2

    Argumentos:
        lista_class: lista de distâncias com classificação atribuida
        lista_nclass: lista de distâncias sem classificação atribuida

    Retorno:
        Um dicionário com a classificação dos elementos da lista lista_nclass.

    Exemplo: 
    x = (6000.0, 2200.0, 5000.0, 1500.0) -> no_class
    y = (5900.0, 3000.0, 5100.0, 1800.0) -> data
    distancia = 866.0254037844386
    """
    return (sum([(a - b)**2 for a, b in zip(x, y)]))**(0.5)


# Função do algoritmo de KNN
# k = Números de vizinhos, quantidade de pontos mais próximos
# no_class = Lista de dados sem classificação do perfil (não treinada)
# data = Lista de dados com classificação do perfil (treinada)
# debug = True -> Exibe as saidas (prints) para auxiliar no acompanhamento da execução das linhas das listas
# debug = False -> Inibe as saidas para auxiliar no acompanhamento da execução das linhas das listas 
def knn(k, no_class, data, debug):
    """K-Nearest Neighbours (KNN)

     KNN é um algoritmo de aprendizado supervisionado que estima a probabilidade de um ponto de dados (instância) 
     pertencer a uma classe ou a outra, dependendo de qual classe suas 'k' instâncias mais próximas pertencem.

    Argumentos:
        k: instâncias mais próximas. 
        lista_class: lista de distâncias com classificação atribuida
        lista_nclass: lista de distâncias sem classificação atribuida

    Retorno:
        Um dicionário com a classificação dos elementos da lista lista_nclass.
        
        As distancias da lista não classificada (lista_nclass) foram comparadas 
        com a lista classificada (lista_class) para determinar os vizinhos (k) mais próximos
        entre os distancias calculadas. 
        
    Exemplo:
        knn_model(5, no_class, data, False)    

    """    
    # Criação de lista classes definidas a partir da lista de dados classificada (treinada)
    classes = list(set([i[1] for i in data]))
    classes.sort()

    resultado = dict() # Dicionário para armazenar os dados treinados
    
    # Percorre a lista de dados sem classificação (não treinada)
    for cpf_no, b_, carteira_no in no_class:
        if debug:
            print('Analisando o CPF {}...'.format(cpf_no))
        
        distanciasknn = list() # Lista para armazenar as distancias mais próximas encontradas (Knn)
        
        # Percorre a lista de dados com classificação (treinada)
        for cpf_, classe, carteira in data:
            distancias = list() # Lista para armazenar todas as distancias calculadas entre os dados treinados / não treinados
            distancia = euclidean_dist(carteira, carteira_no) # Cálcula a distância entre as carteiras (ponto)
            distancias.append(distancia) # Adiciona na lista o cálculo entre os pontos
            distancias.append(classe) # Adiciona na lista a classe do carteira
            
            if debug:
                print('Ponto no_class:{} x data:{} = distancia:{}'.format(carteira_no, carteira, distancia))
                
            distanciasknn.append(distancias) # Adiciona a lista auxiliar distancia na lista distanciaknn
        
        # Depois de calcular o CPF da carteira não treinada contra todos os CPFs da carteira treinada
        distanciasknn.sort() # Ordena as distâncias encontradas do menor para o maior
        distanciasknn = (distanciasknn[:k]) # Defini a quantidade de valores da lista, onde K = vizinhos próximos

        if debug:
            print('Vizinhos próximos:')
            print(distanciasknn)
            
        classesvizinhas = list() # Lista de classes próximas (distancias/pontos próximos)
        # Percorre as distancias encontradas identificando as classes
        for _, classe in distanciasknn:
            classesvizinhas.append(classe)
        
        classifica = list() # Lista de classificação da carteira
        
        # Percorre as classes existentes
        for classe in classes:
            qtd = classesvizinhas.count(classe)
            classifica.append(qtd) # Adiciona na lista agrupando por classes 
            if debug:
                print('{}: {}'.format(classe,qtd))
        
        classificacao = classes[classifica.index(max(classifica))] # Identifcação da classe por ordem da classe
        
        resultado[cpf_no] = classificacao # Adiciona no dicionário o cpf com a classificação
        
        if debug:
            print('Classificação:',classificacao)
            print('\n')
       
    return resultado
