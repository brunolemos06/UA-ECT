from flask import Flask, redirect, url_for, jsonify, request, make_response

from werkzeug.security import generate_password_hash, check_password_hash
from authlib.integrations.flask_client import OAuth
from datetime import datetime, timedelta
from functools import wraps
from flasgger import Swagger

import json, uuid, jwt
#from flask_cors import CORS, cross_origin

from user import create_user, get_user, get_user_by_id, create_social_user, get_social_user, get_social_user_by_id

app = Flask(__name__)

# Enable CORS
#CORS(app)

# Authlib setup
oauth = OAuth(app)

# Swagger setup
swagger = Swagger(app)

#CONFIGS
with open('client_secret_google.json') as f:
    google_credentials = json.load(f)['web']

app.config['SECRET_KEY'] = "OH NO ANYWAYS"

app.config['GOOGLE_CLIENT_ID'] = google_credentials['client_id']
app.config['GOOGLE_CLIENT_SECRET'] = google_credentials['client_secret']
app.config['GITHUB_CLIENT_ID'] = "61e17ec5a329b5e84b6e"
app.config['GITHUB_CLIENT_SECRET'] = "da7a7cf6beb5c94ba5378f588a2f2162d8eb8453"

google = oauth.register(
    name = 'google',
    client_id = app.config["GOOGLE_CLIENT_ID"],
    client_secret = app.config["GOOGLE_CLIENT_SECRET"],
    access_token_url = 'https://accounts.google.com/o/oauth2/token',
    access_token_params = None,
    authorize_url = 'https://accounts.google.com/o/oauth2/auth',
    authorize_params = None,
    api_base_url = 'https://www.googleapis.com/oauth2/v1/',
    userinfo_endpoint = 'https://openidconnect.googleapis.com/v1/userinfo', 
    client_kwargs = {'scope': 'email profile'},
    server_metadata_url=f'https://accounts.google.com/.well-known/openid-configuration'
)

github = oauth.register (
  name = 'github',
    client_id = app.config["GITHUB_CLIENT_ID"],
    client_secret = app.config["GITHUB_CLIENT_SECRET"],
    access_token_url = 'https://github.com/login/oauth/access_token',
    access_token_params = None,
    authorize_url = 'https://github.com/login/oauth/authorize',
    authorize_params = None,
    api_base_url = 'https://api.github.com/',
    client_kwargs = {'scope': 'user:email'},
)

#############################################################################################################################################

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        # return 401 if token is not passed
        if not token:
            return make_response(jsonify({'message' : 'Token is missing !!'}), 401)
  
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'])
            print(data)
            user_firstname = None
            user_lastname = None
            user_email = None
            user_avatar = None
            user_id = None
            if 'provider_id' in data:
                current_user = get_social_user_by_id(data['provider_id'])
                user_firstname = current_user[4]
                user_lastname = current_user[5]
                user_email = current_user[3]
                user_avatar = current_user[6]
                user_id = current_user[1]
            else:
                current_user = get_user_by_id(data['public_id'])
                user_firstname = current_user[2]
                user_lastname = current_user[3]
                user_email = current_user[4]
                user_id = current_user[1]
        except:
            return make_response(jsonify({ 'message' : 'Token is invalid !!' }), 401)
        #returns the current logged in users context to the routes
        return  f(user_firstname, user_lastname, user_email, user_avatar, user_id, *args, **kwargs)
  
    return decorated

#############################################################################################################################################

# Default route
@app.route('/')
def home():
  return "root"

@app.route('/google', methods=['GET'])
#@cross_origin()
def google():
    """This method redirects the user to the Google login page
    ---
    tags:
      - Social Accounts
    """
    return redirect('/login/google')

# Google login route
@app.route('/login/google')
#@cross_origin()
def google_login():
    google = oauth.create_client('google')
    redirect_uri = url_for('google_callback', _external=True)
    return google.authorize_redirect(redirect_uri)

# Google callback route
@app.route('/login/google/callback')
#@cross_origin()
def google_callback():
    """This method is called after the user has logged in to Google, DO NOT CALL THIS METHOD DIRECTLY
    ---
    tags:
      - Callbacks
    responses:
      202:
        description: User logged in successfully
        schema:
          properties:
            token:
              type: string
              description: JWT Token
      500:
        description: Something went wrong
        schema:
          properties:
            message:
              type: string
              description: Error message
                    """
    google = oauth.create_client('google')
    token = google.authorize_access_token()
    resp = google.get('userinfo').json()

    print(resp)

    user_data = get_social_user(resp['id'], 'google')

    print(user_data)

    if not user_data:
        if not create_social_user(resp['id'], 'google', resp['email'], resp['given_name'], resp['family_name'], resp['picture']):
            return make_response(jsonify({'message' : 'Something went wrong'}), 500)

    #get user 
    user_data = get_social_user(resp['id'], 'google')

    # generates the JWT Token
    token = jwt.encode({
        'provider_id': user_data[1],
        'exp' : datetime.utcnow() + timedelta(minutes = 30)
    }, app.config['SECRET_KEY'])

    return make_response(jsonify({'token' : token.decode('UTF-8')}), 202)

@app.route('/github', methods=['GET'])
#@cross_origin()
def github():
    """This method redirects the user to the Github login page
    ---
    tags:
      - Social Accounts
    """
    return redirect('/login/github')

# Github login route
@app.route('/login/github')
#@cross_origin()
def github_login():
    github = oauth.create_client('github')
    redirect_uri = url_for('github_callback', _external=True)
    return github.authorize_redirect(redirect_uri)


# Github callback route
@app.route('/login/github/callback')
#@cross_origin()
def github_callback():
    """This method is called after the user has logged in to Github, DO NOT CALL THIS METHOD DIRECTLY
    ---
    tags:
      - Callbacks
    responses:
      202:
        description: User logged in successfully
        schema:
          properties:
            token:
              type: string
              description: JWT Token
      500:
        description: Something went wrong
        schema:
          properties:
            message:
              type: string
              description: Error message
                    """
    github = oauth.create_client('github')
    token = github.authorize_access_token()
    resp = github.get('/user').json()
    
    email = github.get('/user/emails').json()
    resp['email'] = email[0]['email']
    
    print(f"\n{resp}\n")

    user_data = get_social_user(resp['id'], 'github')

    print(user_data)

    if not user_data:
        if not create_social_user(resp['id'], 'github', resp['email'], resp['name'].split(' ')[0], resp['name'].split(' ')[1], resp['avatar_url']):
            return make_response(jsonify({'message' : 'Something went wrong'}), 500)
        
    #get user 
    user_data = get_social_user(resp['id'], 'github')

    # generates the JWT Token
    token = jwt.encode({
        'provider_id': user_data[1],
        'exp' : datetime.utcnow() + timedelta(minutes = 30)
    }, app.config['SECRET_KEY'])

    return make_response(jsonify({'token' : token.decode('UTF-8')}), 202)

@app.route('/register', methods=['POST'])
#@cross_origin()
def register():
    """This method is called for user registration
    ---
    tags:
      - Normal Account
    parameters:
      - in: body
        name: body
        schema:
          required:
            - firstName
            - lastName
            - email
            - password
          properties:
            firstName:
              type: string
              description: First name of the user
            lastName:
              type: string
              description: Last name of the user
            email:
              type: string
              description: Email of the user
            password:
              type: string
              description: Password of the user
    responses:
      201:
        description: User registered successfully
        schema:
          properties:
            message:
              type: string
              description: Success message
      202:
        description: User already exists
        schema:
          properties:
            message:
              type: string
              description: Error message
      500:
        description: Something went wrong
        schema:
          properties:
            message:
              type: string
              description: Error message
                    """
    data = request.get_json()

    hashed_password = generate_password_hash(data['password'], method='sha256')

    user = get_user(data['email'])

    public_id = str(uuid.uuid4())
    if len(public_id) > 50:
        public_id = public_id[:50]

    if not user:
        if not create_user(public_id, data['firstName'], data['lastName'], data['email'], hashed_password):
            return jsonify({'message' : 'Something went wrong'}, 500)
        return make_response(jsonify({'message' : 'Successfully registered'}), 201)
    else:
        return make_response(jsonify({'message' : 'User already exists'}), 202)
    
@app.route('/login', methods=['POST'])
#@cross_origin()
def login():
    """This method is called for our user login (normal login, not social login)
    ---
    tags:
      - Normal Account
    parameters:
      - in: body
        name: body
        schema:
          required:
            - email
            - password
          properties:
            email:
              type: string
              description: Email of the user
            password:
              type: string
              description: Password of the user
    responses:
        202:
          description: User logged in successfully
          schema:
            properties:
              token:
                type: string
                description: JWT Token
        401:
          description: Couldn't verify
          schema:
            properties:
              message:
                type: string
                description: Error message
    """
    data = request.get_json()

    user_data = get_user(data['email'])
    if not user_data:
        return make_response(jsonify({'message' : 'Couldn\'t verify'}), 401)
    
    print(user_data)
    
    if check_password_hash(user_data[5], data['password']):
        token = jwt.encode({
            'public_id': user_data[1],
            'exp' : datetime.utcnow() + timedelta(minutes = 30)
        }, app.config['SECRET_KEY'])

        return make_response(jsonify({'token' : token.decode('UTF-8')}), 202)
    else:
        return make_response(jsonify({'message' : 'Couldn\'t verify'}), 401)

@app.route('/auth', methods=['POST'])
#@cross_origin()
@token_required
def auth(user_firstname, user_lastname, user_email, user_avatar, user_id):
   """This method is called to check if the user is authenticated
    ---
    parameters:
      - in: header
        name: x-access-token
        schema:
          required:
            - x-access-token
          properties:
            x-access-token:
              type: string
              description: JWT Token
    responses:
      200:
        description: User is authenticated
        schema:
          properties:
            message:
              type: string
              description: Success message
      401:
        description: Missing Authorization Token or Token Is Invalid
        schema:
          properties:
            message:
              type: string
              description: Error message
          """
   return make_response(jsonify({'message' : 'Is authenticated'}), 200)

@app.route('/info', methods=['POST'])
#@cross_origin()
@token_required
def info(user_firstname, user_lastname, user_email, user_avatar, user_id):
    """This method is called to get the user info
    ---
    parameters:
      - in: header
        name: x-access-token
        schema:
          required:
            - x-access-token
          properties:
            x-access-token:
              type: string
              description: JWT Token
    responses:
      200:
        description: User info
        schema:
          properties:
            fname:
              type: string
              description: First name of the user
            lname:
              type: string
              description: Last name of the user
            email:
              type: string
              description: Email of the user
            avatar:
              type: string
              description: URL of the user avatar
            id:
              type: string
              description: ID of the user
      401:
        description: Missing Authorization Token or Token Is Invalid
        schema:
          properties:
            message:
              type: string
              description: Error message
    """
    return make_response(jsonify({'fname' : user_firstname, 'lname' : user_lastname, 'email' : user_email, 'avatar' : user_avatar, 'id' : user_id}), 200)

if __name__ == '__main__':
  app.run(host='0.0.0.0',port=5100,debug=True)
