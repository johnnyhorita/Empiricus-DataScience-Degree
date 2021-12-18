import yfinance as yf
import datetime as dt
from plotly import graph_objs as go
from plotly.subplots import make_subplots
import streamlit as st  # versão 0.87
import matplotlib.pyplot as plt
from fbprophet import Prophet
from fbprophet.plot import plot_plotly

@st.cache
def extract_data(ticker, start, end):
    import time
    data = yf.download(ticker, start, end)
    data = data.reset_index()
#     time.sleep(3)
    return data

def plot_raw_data(data):
    fig = go.Figure()
    fig.add_trace(go.Scatter(
        x=data['Date'], y=data['Open'], name='stock_open'))

    fig.add_trace(go.Scatter(
        x=data['Date'], y=data['Close'], name='stock_close'))

    fig.layout.update(title_text='Abertatura e Fechamento',
                     xaxis_rangeslider_visible=True)

    fig.layout.update(
        xaxis=dict(
                showline=True,
                showticklabels=True,
                linecolor='rgb(0, 0, 0)',
                linewidth=2,
                ticks='outside',
                tickfont=dict(
                    family='Roboto',
                    size=12,
                    color='rgb(82,82,82)'),
            ),
        yaxis=dict(
                showline=True,
                showgrid=False,
                zeroline=True,
                showticklabels=True,
                ticks='outside',
                linecolor='rgb(0, 0, 0)',
                linewidth=2
            ),
        plot_bgcolor='rgb(255,255,255)',
        
    )
    st.plotly_chart(fig)

@st.cache
def make_forecast(data, period):
    df_train = data[['Date', 'Close']]
    df_train = df_train.rename(columns={'Date': 'ds', 'Close': 'y'})
    m = Prophet()
    m.fit(df_train)
    future = m.make_future_dataframe(periods=period)
    forecast = m.predict(future)
    
    return m, forecast

##############
### Inicio ###
##############
start = st.date_input(
    'Data de inicio')


today = dt.date.today().strftime('%Y-%m-%d')

stocks = ['GOOG', 'AAPL', 'MSFT', 'GME']

st.title('Previsão de preço da ação')

selected_stock = st.selectbox('Selecione a ação para predição', stocks)

n_years = st.slider('Anos para predição', 1, 4, 1)

period = n_years * 365

data_load_state = st.text('Baixando os dados...')
data = extract_data(selected_stock, start, today)
data_load_state.text('Finalizado! Dados baixados!')

####
actual_month = (data.iloc[-30:]['Close'].mean())
before_month = (data.iloc[-60:-30]['Close'].mean())
avg_mm = round((actual_month / before_month) *100)

col1, col2, col3, col4, col5 = st.columns(5)
col3.metric('Variação MoM', f'{avg_mm}%', f'{avg_mm - 100}%')
# col4.metric('Umidade', '80%', '+70%')
# st.subheader('Dados brutos')

# st.write(data)

plot_raw_data(data)

m, forecast = make_forecast(data, period)

# st.subheader('Dados de Forecast')
# st.write(forecast.tail())

st.subheader(f'Forecast para a ação {selected_stock} para {period} dias')

fig_forecast = plot_plotly(m, forecast)

st.plotly_chart(fig_forecast)

st.subheader(f'Explicando as caracteristicas do modelo de forecast')

fig_components = m.plot_components(forecast)

st.write(fig_components)

