import yfinance as yf
import datetime as dt
import pandas as pd
import numpy as np
import streamlit as st  # versão 0.87
import matplotlib.pyplot as plt

# Inserindo texto
st.text('Aqui é um texto')

# Inserindo markdown
st.markdown('Aqui é um texto **negrito** $y=ax+b$')

st.markdown('Texto Latex $y=ax+b$')

# Escrevendo objetos

st.write('1 + 1 = ', 2)

df = pd.DataFrame({'a': [1,2], 'b': [3,4]})

st.write('Acima dataframe', df, 'Abaixo DF')

df = pd.DataFrame(np.random.randn(10, 20))

# Destacando valor máximo de cada coluna
st.dataframe(df.style.highlight_max(axis=0))

# Metricas  -> Ou tile ou card
col1, col2, col3, col4, col5 = st.columns(5)
col2.metric('Temperatura', '34°C', '-20°C')
col3.metric('Dia da semana', 'Segunda')
col4.metric('Umidade', '80%', '+70%')

# checkbox
if_filter = st.checkbox('Filtrar valores positivo?')
st.write(if_filter)

st.text('Filtrou?')
if if_filter:
    df_filtered = df[df>0].copy()
else:
    df_filtered = df.copy()
st.write(df_filtered.fillna(-999))

# Radio button

filme = st.radio(
    'Qual seu filme favorito',
    ('Comedia', 'Terror', 'Romance')  # Opções
)

st.write(filme, type(filme))

if filme == 'Comedia':
    st.write('Você é uma pessoa feliz')
    
else:
    st.write('Você é uma pessoa triste')
    
# Select box

filme_box = st.selectbox(
    'Qual seu filme favorito',
    ('Comedia', 'Terror', 'Romance')  # Opções
)
if filme_box == 'Comedia':
    st.write('Você é uma pessoa feliz')
    
else:
    st.write('Você é uma pessoa triste')

# Sliders
idade = st.slider('Qual sua idade', 0, 100, 37)

st.write(idade)

# Input
nome = st.text_input('Qual seu nome?', 'Escreva seu nome aqui')

st.write(nome, type(nome))

# Date input, date picker

d = st.date_input(
    'Qual sua a data de nascimento')

st.write(d)



# Emoji
# https://raw.githubusercontent.com/MarcSkovMadsen/awesome-streamlit/master/gallery/emojis/emojis.py
st.markdown(':poop:')


# Multiselect
options = st.multiselect('Escolha a ação',
                        ['AMZN', 'GOOG', 'APPL'])

st.write(options, type(options))

# Color picker
color = st.color_picker('Escolha uma cor')


st.write(color)
fig, ax = plt.subplots()
df[0].plot(ax = ax, color = color)
st.pyplot(fig)