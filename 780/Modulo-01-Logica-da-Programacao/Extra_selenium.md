# Selenium 

Uma limitação da técnica estudada para fazer webscraping é a dificuldade em sites que exigem cliques do mouse ou envio de campos preenchidos. Todo tipo de "entrada" de dados precisava ir pelo ```requests.get``` e todas as informações precisavam voltar no HTML da resposta. Além disso, alguns sites possuem elementos gerados dinamicamente por *scripts* que são interpretados pelo seu navegador, e o Python é incapaz de interpretá-los.

Uma solução bastante utilizada para esses casos é o **Selenium**. O Selenium é uma ferramenta para automação de testes de sites: você monta um script falando para ele em qual site entrar, onde clicar, o que digitar etc e ele abre o seu navegador sozinho e segue o passo-a-passo. Ele também tem bibliotecas para fazer interface com diferentes linguagens de programação, o que vai ser bastante útil para nós.

## 1. Instalação
Precisamos instalar 3 componentes diferentes para extrair o máximo do Selenium: a biblioteca Python, um WebDriver e o Selenium IDE.
### 1.1. Biblioteca Python
A primeira parte da instalação é bem semelhante ao que fizemos para trabalhar com a requests e com a bs4: utilizar o pip para instalar a biblioteca. No console/terminal/cmd, digite:

```
pip3 install selenium
```

### 1.2. WebDriver
Ainda não estamos prontos: pelo pip instalamos o “lado do Python”. Agora temos que instalar o “lado do navegador”: um WebDriver, o programinha que permitirá que o Selenium controle o seu navegador. 

- Para o Chrome, utilizamos o ChromeDriver: https://chromedriver.chromium.org/downloads
- Para o Firefox, utilizamos o geckodriver: https://github.com/mozilla/geckodriver/releases

Baixe o driver correto para o seu navegador e coloque-o em uma pasta de fácil acesso. Anote essa pasta!

### 1.3. Selenium IDE
Agora já estamos prontos... Para montar nossos scripts manualmente. Porém, temos uma facilidade adicional: ao invés de procurar os elementos manualmente no HTML do site, podemos instalar uma extensão em nosso navegador para gravar nossos passos. Ela se chama Selenium IDE. Então podemos entrar no site, fazer as operações que queremos que o programa faça e a Selenium IDE irá gravá-los e gerar o código Python automaticament! Depois podemos modificar esse código para incluir o processamento que faremos em cima dos dados utilizando BeautifulSoup como sempre fizemos.

- Selenium IDE para Chrome: https://chrome.google.com/webstore/detail/selenium-ide/mooikfkahbdckldjjndioackbalphokd?hl=en
- Selenium IDE para Firefox: https://addons.mozilla.org/en-US/firefox/addon/selenium-ide/

## 2. Gravando passos
Vejamos um exemplo simples: um programinha que digita uma expressão no Google e mostra as descrições obtidas na 1ª página de resultados.

Comece abrindo o seu navegador e clicando no Selenium IDE. Você verá essa janela:

![](https://s3-sa-east-1.amazonaws.com/lcpi/a9d42560-00bc-4f9e-acb0-43f02eaac2e2.png)

Clique na primeira opção e dê um nome qualquer para o seu projeto. Em seguida, digite o endereço do site. Como exemplo, usaremos http://www.google.com. Em seguida, clique em “Start Recording”.

Uma janela se abrirá e o site escolhido será carregado. Faça nele todas as ações que você gostaria que o seu programa fizesse. Neste caso, clique na barra de busca do Google, digite uma expressão qualquer (por exemplo, “Python”) e pressione a tecla Enter. Em seguida, clique de volta na tela da IDE (aberta ao fundo) e clique no botão vermelho para parar de gravar:

![](https://s3-sa-east-1.amazonaws.com/lcpi/60c38bd2-edce-4c2c-9ef9-849a44c8baf4.png)

## 3. Código Python

### 3.1. Gerando o código

Clique com o botão direito no nome do seu teste e selecione “Export”. Na janela que se abrirá, selecione a opção “Python pytest” e dê um nome para seu arquivo.

![](https://s3-sa-east-1.amazonaws.com/lcpi/f3d2ba43-9293-46e0-877c-9eedf8d5f1f8.png)

### 3.2. Modificações sugeridas

Abra seu código agora e fazer algumas modificações. Algumas são necessárias, outras são sugestões para facilitar o uso em casos mais simples:
- remover a linha ```import pytest``` (para não ter que instalar a biblioteca pytest, que não utilizaremos aqui).
- trocar a linha ```def setup_method(self, method):``` para ```def __init__(self):``` (é mais fácil para nós ter um construtor).
- modificar a linha ```self.driver = webdriver.Chrome()``` para incluir entre os parênteses o caminho completo onde se encontra o seu WebDriver.

Veja o código do exemplo acima (busca no Google por "Python") com as modificações propostas:

````python
#import pytest '''remover essa linha'''
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

class TestMeuteste():
  #def setup_method(self, method):
  # substituir a linha acima pela linha abaixo:
  def __init__(self):
    self.driver = webdriver.Chrome('c:/chromedriver.exe') # colocar o caminho do seu driver!
    self.vars = {}
  
  def teardown_method(self, method):
    self.driver.quit()
  
  def test_meuteste(self):
    self.driver.get("https://www.google.com/")
    self.driver.set_window_size(697, 728)
    self.driver.find_element(By.NAME, "q").click()
    self.driver.find_element(By.NAME, "q").send_keys("python")
    self.driver.find_element(By.NAME, "q").send_keys(Keys.ENTER)
````

O Selenium IDE gerou uma classe com o nome do seu teste. Agora podemos criar um objeto dessa classe e chamar o último método (o que tem comandos para se conectar a um endereço, procurar elementos etc) a partir dele. 
Após executar esse método, nosso objeto terá em ```nomedoobjeto.driver.page_source``` o HTML do site.

### 3.3. Usando o código
Após ter o ```page_source```, podemos aplicar as técnicas que já conhecemos utilizando BeautifulSoup para buscar os campos de nosso interesse e formatá-los adequadamente.

Prosseguindo com nosso exemplo, finalmente podemos pesquisar as descrições do Google:

```python
import time
import json
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

class TestMeuteste():
  def __init__(self):
    self.driver = webdriver.Chrome('c:/chromedriver.exe')
    self.vars = {}
  
  def teardown_method(self, method):
    self.driver.quit()
  
  def test_meuteste(self):
    self.driver.get("https://www.google.com/")
    self.driver.set_window_size(697, 728)
    self.driver.find_element(By.NAME, "q").click()
    self.driver.find_element(By.NAME, "q").send_keys("python")
    self.driver.find_element(By.NAME, "q").send_keys(Keys.ENTER)
  
teste = TestMeuteste()
teste.test_meuteste()
site = BeautifulSoup(teste.driver.page_source, 'html.parser')
descricoes = site.find_all('span', class_='st')
for descricao in descricoes:
  print(descricao.text)

``` 

Ao rodar o seu programa, divirta-se assistindo à mágica acontecer: seu navegador irá se abrir sozinho, seu texto será digitado nas caixas que você havia clicado automaticamente e o resultado final aparecerá na saída do seu programa Python. 

> Observação: não é necessário utilizar o BeautifulSoup. Essa sugestão foi dada para utilizarmos a ferramenta que já estamos mais acostumados. Porém, é possível usar métodos do próprio Selenium para localizar elementos no site. Consulte a documentação caso tenha interesse em se aprofundar: https://www.selenium.dev/documentation/en/