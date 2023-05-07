from flask import Flask, render_template, url_for, redirect, request, session
import sqlite3 as sql
import re, flask
from hashlib import md5
import os
from werkzeug.utils import secure_filename
import time
from difflib import SequenceMatcher

def similar(a,b):
    return SequenceMatcher(None, a, b).ratio()

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['TEMPLATES_AUTO_RELOAD'] = True
app.secret_key = 'project1_25_unsafe'

PATH = os.path.dirname(os.path.abspath(__file__))

con = sql.connect('users.db', check_same_thread=False)

UPLOAD_FOLDER = './product_images/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}

msg = ""

@app.route('/')
def welcome():
    return render_template('welcome.html')

@app.route('/main')
def main():
            
    file = open("APP/templates/index.html", 'r', encoding="utf8").read()
    file_string = str(file)
    spot = "<!--INSERT HERE-->"
    stop = file_string.find(spot)
    cursor = con.cursor()
    cursor.execute("SELECT * FROM products")
    result = cursor.fetchall()
    info =""
    for i in result:
        info += '''<form action={{url_for('productpage')}} method="post"><div class=\"col-lg-3 col-sm-6 col-md-3\"><input type="hidden" name="image" value="'''+str(i[0])+'''"><div class=\"box-img\"><h4>'''+i[1]+'''</h4><input type="image" width="250px" height="200px" src=\"static/product_images/'''+i[6]+"\" alt=\"\" /></div></a></div></form>"
    final = file_string[:stop + len(spot)] + info + file_string[stop + len(spot):]
    file = open("APP/templates/main.html","w", encoding="utf-8")
    file.write(final)
    return redirect(url_for('home'))

@app.route('/home')
def home():
    if 'loggedin' in session:
        return render_template('main.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout", query="Search")
    else:
        return render_template('main.html', url="login", login="Login", msg="Welcome",user="Login", url2="login", query="Search")

@app.route('/create_product')
def create_product():
    if 'loggedin' in session:
        return render_template('createproduct.html', url2="logout", msg="Logout", user=session['username'])
    return redirect(url_for('login', msg="Login to list a product!"))

@app.route('/settings')
def settings():
    if 'loggedin' in session:
        return render_template('settings.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout")
    return redirect(url_for('login', msg="Login to access settings page!"))

@app.route('/about')
def about():
    if 'loggedin' in session:
        return render_template('about-us.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout")
    return render_template('about-us.html',url="login", login="login", msg="Welcome",user="Login", url2="login")

@app.route('/login', methods=['GET', 'POST'])
def login(msg=""):
    msg=request.args.get("msg")
    if not msg:
        msg = ""
    return render_template('login.html', error=msg)

@app.route('/check_login', methods=['GET', 'POST'])
def check_login():
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        ##protecao contra SQL injection
        #------------------------------
        # if not re.match(r'[A-Za-z0-9_.]+', username):
        #     return redirect(url_for('login', msg="Invalid username!"))
        #------------------------------
        password = request.form['password']

        cursor = con.cursor()

        query = f"SELECT * FROM users WHERE username = '{username}' "
        cursor.execute(query)
        account = cursor.fetchone()
        if not account:
            #CWE 200 -> informacao detalhada a mais no erro
            return redirect(url_for('login', msg="Username doesn't exist!"))
        
        query = f"SELECT * FROM users WHERE username = '{username}' and password = '{md5(password.encode()).hexdigest()}'"
        cursor.execute(query)
        account = cursor.fetchone()

        if account:
            session['loggedin'] = True
            session['id'] = account[0]
            session['username'] = account[1]
            session['bday'] = account[3]
            return redirect(url_for('main'))
        
    #CWE 200 -> informacao a mais no erro
    return redirect(url_for('login', msg="Wrong password!"))


@app.route('/productpage', methods=['GET', 'POST'])
def productpage():
    id = request.form['image']

    cursor = con.cursor()
    query = f"SELECT * FROM products WHERE id = '{id}'"
    cursor.execute(query) 
    product = cursor.fetchone()
    if 'loggedin' in session:
        return render_template('productpage.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout",id=id,name=product[1],contact=product[3],price=product[4],description=product[5],imagefile=product[6])
    else:
        return render_template('productpage.html', url="login", login="Login", msg="Welcome",user="Login", url2="login",id=id,name=product[1],contact=product[3],price=product[4],description=product[5],imagefile=product[6])

@app.route('/logout')
def logout():
    if 'loggedin' in session:
        session.pop('loggedin', None)
        session.pop('id', None)
        session.pop('username', None)
        session.pop('bday', None)
        # Redirect to login page
        return redirect(url_for('main'))

    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register(msg=""):
    msg=request.args.get("msg")
    if not msg:
        msg = ""
    return render_template('register.html',error=msg)

@app.route('/search')
def search():
    query = request.args.get('query').lower()
    #PROTECAO CONTRA XSS
    #----------------------------------
    # query = query.replace(">", "&#62;")
    # query = query.replace("<", "&#60;")
    # query = query.replace('"', "&#34;")
    #----------------------------------
    file = open("APP/templates/index.html", 'r', encoding="utf8").read()
    file_string = str(file)
    spot = "<!--INSERT HERE-->"
    stop = file_string.find(spot)
    cursor = con.cursor()
    cursor.execute("SELECT * FROM products")
    result = cursor.fetchall()
    info =""
    for i in result:
        if not query:
            return redirect(url_for('main'))
        if (similar(i[1].lower(), query)) > 0.7:
            info += '''<form action={{url_for('productpage')}} method="post"><div class=\"col-lg-3 col-sm-6 col-md-3\"><input type="hidden" name="image" value="'''+str(i[0])+'''"><div class=\"box-img\"><h4>'''+i[1]+'''</h4><input type="image" width="250px" height="200px" src=\"static/product_images/'''+i[6]+"\" alt=\"\" /></div></a></div></form>" 
    final = file_string[:stop + len(spot)] + info + file_string[stop + len(spot):]
    file = open("APP/templates/main.html","w", encoding="utf-8")
    file.write(final)
    return redirect(url_for('query', query=query))

@app.route('/query')
def query():
    query = request.args.get('query')
    if 'loggedin' in session:
        return render_template('main.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout", query=query)
    else:
        return render_template('main.html', url="login", login="Login", msg="Welcome",user="Login", url2="login", query=query)

@app.route('/check_register', methods=['GET', 'POST'])
def check_register():
    if request.method == 'POST' and 'username' in request.form:
        username = request.form['username']
        #protecao contra SQL injection
        #-------------------------------------------------------------------------
        # if not re.match(r'[A-Za-z0-9_.]+', username):
        #     return redirect(url_for('register', msg="Invalid special characters!"))
        #--------------------------------------------------------------------------
        password = request.form['password']
        password2 = request.form['password2']
        bday = request.form['birthday']

        if password != password2:
            return redirect(url_for('register', msg="Passwords do not match!"))

        cursor = con.cursor()
        query = f"SELECT * FROM users WHERE username = '{username}'"
        cursor.execute(query) 
        account = cursor.fetchone()

        if account:
            #Se user ja existir
            return redirect(url_for('register', msg="User already exists!"))
        elif not re.match(r'[A-Za-z0-9_.]+', username) or not re.match(r'[A-Za-z0-9_.]+', password):
            #Username ou password tem carateres proibidos
            return redirect(url_for('register', msg="Invalid special characters!"))
        else:
            query = f'INSERT INTO users VALUES (NULL,"{username}", "{md5(password.encode()).hexdigest()}", "{bday}")' 
            cursor.execute(query)
            con.commit() 
            return redirect(url_for('login', msg="Account created, now login!"))

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/new_product', methods=['GET', 'POST'])
def new_product():
    if request.method == 'POST':
        product = request.form['product']
        contact = request.form['contact']
        price = request.form['price']
        description = request.form['description']
        file = request.files['file']
        upload_path = PATH +'/static/product_images'
        name=""
        if file and allowed_file(file.filename):
            name = secure_filename(file.filename)
            upload_file = os.path.normpath(os.path.join(upload_path, name))
            filename = secure_filename(file.filename)
            file.save(upload_file)

        cursor = con.cursor()
        username = session['username']
        query = f'INSERT INTO products VALUES (NULL,"{product}", "{username}", "{contact}", "{price}", "{description}", "{name}")'    
        cursor.execute(query)
        con.commit()

    return redirect(url_for('main'))



@app.route('/user_profile')
def updatedProfile():
    if 'loggedin' in session:
        return render_template('updatedProfile.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout", date=session['bday'])
    return redirect(url_for('login', msg="Login to access profile page!"))

@app.route('/profile')
def profile():
            
    file = open("APP/templates/profile.html", 'r', encoding="utf8").read()
    file_string = str(file)
    spot = "<!--INSERT HERE-->"
    stop = file_string.find(spot)
    cursor = con.cursor()
    username = session['username']
    cursor.execute(f"SELECT * FROM products where username='{username}'")
    result = cursor.fetchall()
    info =""
    j = 1
    for i in result:
        price = i[4]
        price = price[1:]
        description = i[5]
        if(len(description)) > 20:
            description = description[0:20]
            description = description + "..."
        info += '<form action ="{{url_for("delete_product")}}" method="post"><tr class="active-row"><td>'+str(j)+'</td><td>'+i[1]+'</td><td>'+price+'</td><td>'+description+'</td><td><input type="Submit" style="color:red;background-color:transparent" value="Delete"><input name="name" type="hidden" value="' + i[6]+'"></td>></tr></form>'
        j=j+1
    final = file_string[:stop + len(spot)] + info + file_string[stop + len(spot):]
    file = open("APP/templates/updatedProfile.html","w", encoding="utf-8")
    file.write(final)
    return redirect(url_for('updatedProfile'))

@app.route('/delete_product', methods=['GET', 'POST'])
def delete_product():
    if 'loggedin' in session:
        image = request.form['name']
        print(image)
        query = f'DELETE FROM products WHERE image = "{image}"'
        cursor = con.cursor()
        cursor.execute(query)
        con.commit()
        img_path = PATH+"/static/product_images"
        del_file = os.path.normpath(os.path.join(img_path, image))
        os.remove(del_file)
        return redirect(url_for('profile'))
    return redirect(url_for('main'))

 
@app.route('/changepassword', methods=['GET', 'POST'])
def changepassword(error=""):
    if 'loggedin' in session:
        error = request.args.get("error")
        if error == None:
            error = ""

        return render_template('changepassword.html',url="profile", login="Profile", msg="Logout",user=session['username'], url2="logout", error=error)
    return redirect(url_for('login', msg="Login to access this page!"))

@app.route('/changing', methods=['GET', 'POST'])
def changing():
    if 'loggedin' in session:
        if request.method == 'POST':
            user = request.form['inputUser']
            oldPass = request.form['inputOld']
            newPass = request.form['inputNew']
            confirm_new_pass = request.form['inputConfirm']
            bday = session['bday']

            # CWE 522 -> User changing pass might not be the user loggedin
            # if user != session['username']:
            #     return redirect(url_for('changepassword', error="The username does not match the logged in username!"))
            
            cursor = con.cursor()
            query = f"SELECT * FROM users WHERE username = '{user}' and password = '{md5(oldPass.encode()).hexdigest()}'"
            cursor.execute(query)
            account = cursor.fetchone()

            # CWE 522 -> User changing pass might not be the user loggedin
            # if not account:
            #     return redirect(url_for('changepassword', error="The password does not match the logged in username!"))

            if not re.match(r'[A-Za-z0-9_.]+', newPass):
                return redirect(url_for('changepassword', error="Invalid special characters!"))
            
            if newPass != confirm_new_pass:
                return redirect(url_for('changepassword', error="The new passwords aren't matching!"))
            
            query = f'UPDATE users SET password="{md5(newPass.encode()).hexdigest()}" WHERE username="{user}"' 
            cursor.execute(query)
            con.commit()

            return redirect(url_for('settings'))

    return redirect(url_for('login', msg="Login to access your account!"))

@app.route('/deleteaccount', methods=['GET', 'POST'])
def deleteaccount(error=""):
    error = request.args.get("error")
    if error == None:
        error = ""
    
    return render_template('deleteaccount.html', error=error)

@app.route('/deleting', methods=['GET', 'POST'])
def deleting():
    if 'loggedin' in session:
        if request.method == 'POST':
            password = request.form['password']
            user = session['username']

            cursor = con.cursor()
            query = f"SELECT * FROM users WHERE username = '{user}' and password = '{md5(password.encode()).hexdigest()}'"
            cursor.execute(query)
            account = cursor.fetchone()
        
            if account:
                query = f'DELETE FROM users WHERE username="{user}"'
                cursor.execute(query)
                con.commit()

                cursor.execute(f"SELECT * FROM products where username='{user}'")
                result = cursor.fetchall()

                for i in range(len(result)):
                    image = (result[i])[6]
                    img_path = PATH+"/static/product_images"
                    del_file = os.path.normpath(os.path.join(img_path, image))
                    os.remove(del_file)

                query = f'DELETE FROM products WHERE username="{user}"'
                cursor.execute(query)
                con.commit()

                return redirect(url_for('logout'))
            
            return redirect(url_for('deleteaccount', error="The password is incorrect!"))

    return redirect(url_for('login', msg="Login to access your account!"))



if __name__ == '__main__':
   app.run()
