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


    def Classificar(self):
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
        
        ativos_col = [e for e in df.columns.tolist() if "Ativo" in e]
        k = 5

        df_knn = pd.DataFrame(columns=["id", "dfPerfil", "knnPerfil"])

        #for i in range(len(df_nota1NaN)):
        for i in range(10):
            at_NotaNaN = df_agressivo.loc[i, ativos_col].values.flatten().tolist()
            id_NotaNaN = df_agressivo.loc[i, "id"]
            perfil_NotaNaN = df_agressivo.loc[i, "Perfil"]

            distanciasknn = list() # Lista para armazenar as distancias mais próximas encontradas (Knn)

            for i in range(len(df_nota)):
                distancias = list()      
                at_Nota = df_nota.loc[i, ativos_col].values.flatten().tolist()

                distancia = Euclidean_dist(at_Nota, at_NotaNaN) # Cálcula a distância entre as carteiras (ponto)
                distancias.append(distancia) # Adiciona na lista o cálculo entre os pontos
                distancias.append(df_nota.loc[i, "Perfil"]) # Adiciona na lista a classe do carteira
                distancias.append(df_nota.loc[i, "Nota1"]) # Adiciona na lista a classe do carteira        

                distanciasknn.append(distancias) # Adiciona a lista auxiliar distancia na lista distanciaknn

            distanciasknn.sort() # Ordena as distâncias encontradas do menor para o maior
            distanciasknn = (distanciasknn[:k]) # Defini a quantidade de valores da lista, onde K = vizinhos próximos
            #print(distanciasknn)

            classesvizinhas = list() # Lista de classes próximas (distancias/pontos próximos)

            # Percorre as distancias encontradas identificando as classes
            for _, classe, notaX in distanciasknn:
                classesvizinhas.append(classe)

            classifica = dict() # dicionário para classificação da carteira
            classifica = {x:classesvizinhas.count(x) for x in classesvizinhas} # Dicionário agrupado por classes (Classe : quantidade)
            classificacao = sorted(classifica.items(), key=lambda x: x[1], reverse=True) # Ordena o dicionario do maior para o menor            

            #Adiciona linha no dataframe
            new_row = {'id':id_NotaNaN, 'dfPerfil':perfil_NotaNaN, 'knnPerfil':classificacao[0][0]}
            df_knn = df_knn.append(new_row, ignore_index=True)

        return resultado
