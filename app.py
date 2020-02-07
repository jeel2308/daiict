from flask import Flask, render_template, request, redirect, url_for, session

#import mongo

app = Flask(__name__, static_url_path='/static')

app.debug = True
app.secret_key = "Nothing"

@app.route("/")
def index():
    return render_template('index.html')
    
@app.route("/login")
def Login():
    return render_template('Login.html')

@app.errorhandler(404)
def error404(error):
    return render_template('404.html'), 404



# Login and Sign Up Methods 

@app.route('/login_action', methods=['POST'])
def login_action():

    email = request.form['email']
    password = request.form['password']
    print(email,password)
    if  mongo.Login(email,password):
        return "Sucess"
    return "Error"

@app.route('/sign_action', methods=['POST'])
def sign_action():

    name = request.form['name']
    email = request.form['email']
    password = request.form['password']
    category = request.form['category']

    print(name,email,password,category)
    if mongo.Register(email,name,password,category):
        return "Success"
    
    return "Error"
if __name__ == "__main__":
    app.run()
