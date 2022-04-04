import os
import pandas as pd 
import numpy as np 
import flask
import pickle
from flask import Flask, render_template, request
from sklearn import svm, datasets

app = Flask(__name__)

@app.route('/')
def index():
    return flask.render_template('index.html')

def pickleModel(path):
    iris = datasets.load_iris()
    X= iris.data
    y= iris.target
    model = svm.SVC(kernel='poly', degree=3, C=1.0).fit(X,y)
    pickle.dump(model, open(path+"iris_model_780", "wb"))
    print("****salvando modelo****")

def ValuePredictor(to_predict_list):
    to_predict = np.array(to_predict_list).reshape(1,4)
    loaded_model = pickle.load(open("iris_model_780","rb"))
    result = loaded_model.predict(to_predict)
    return result

@app.route("/predict", methods=["POST"])
def result():
    if request.method=='POST':
        to_predict_list = request.form.to_dict()
        to_predict_list = list(to_predict_list.values())
        to_predict_list = list(map(float, to_predict_list))

        result = ValuePredictor(to_predict_list)      
        
        if result == 0:
            prediction = "versicolor"
        elif result == 1:
            prediction ="virginica"
        else:
            prediction = "setosa"
    
    return render_template("predict.html", prediction=prediction)

if __name__ == "__main__":
    pickleModel("")
    app.run(host="0.0.0.0", debug=True)