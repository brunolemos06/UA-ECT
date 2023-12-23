from flask import Flask, jsonify, request
from flask_restful import Api, Resource, reqparse
import datetime
import sqlite3
from flask_swagger_ui import get_swaggerui_blueprint

app = Flask(__name__)

SWAGGER_URL = '/api/docs'  # URL for exposing Swagger UI (without trailing '/')
API_URL = '/static/swagger.yml'  # Our API url (can of course be a local resource)

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,  # Swagger UI static files will be mapped to '{SWAGGER_URL}/dist/'
    API_URL,
    config={  # Swagger UI config overrides
        'app_name': "Review API"

    },
)

app.register_blueprint(swaggerui_blueprint)


api = Api(app)

new_user_post_args = reqparse.RequestParser()

appendurl = '/api/v1'

@app.route('/')
def index():
    return "Review Service!",200

@app.route(appendurl+'/reviews/', methods=['GET', 'POST','PUT','DELETE'])
def reviews():
    if request.method == 'POST':
        # verify if requestfrom is valid
        try:
            if  (request.form['personid'] is None or request.form['title'] is None or request.form['description'] is None or request.form['rating'] is None):
                # all fields are required
                return jsonify({'error': 'personid, title, description, rating are required'}), 400
        except:
            return jsonify({'error': 'personid, title, description, rating are required'}), 400


        conn = sqlite3.connect('database.db')
        # insert the data into the database with x-www-form-urlencoded
        conn.execute('INSERT INTO reviews (personid, title, description, rating) VALUES (?, ?, ?, ?)', (request.form['personid'], request.form['title'], request.form['description'], request.form['rating']))
        conn.commit()
        conn.close()
        return jsonify({'reviews': [{'personid': request.form['personid'], 'title': request.form['title'], 'description': request.form['description'], 'rating': request.form['rating']}]}), 200
    if request.method == 'GET':
        # could be a query parameter
        # http://localhost/api/reviews?reviewid=1
        reviewid = request.args.get('reviewid')
        personid = request.args.get('personid')
        conn = sqlite3.connect('database.db')
        cur = conn.cursor()
        if reviewid is not None:
            cur.execute('SELECT * FROM reviews WHERE reviewid = ?', (reviewid,))
        elif personid is not None:
            cur.execute('SELECT * FROM reviews WHERE personid = ?', (personid,))
        else:
            cur.execute('SELECT * FROM reviews')
        # return the data with the named columns in json format
        # personid, title, description, rating, reviewid, data
        return jsonify({'reviews': [{'personid': personid, 'title': title, 'description': description, 'rating': rating, 'reviewid': reviewid, 'data': data} for personid, title, description, rating, reviewid, data in cur.fetchall()]}), 200
    if request.method == 'PUT':
        conn = sqlite3.connect('database.db')
        # update the data into the database with x-www-form-urlencoded
        conn.execute('UPDATE reviews SET personid = ?, title = ?, description = ?, rating = ? WHERE reviewid = ?', (request.form['personid'], request.form['title'], request.form['description'], request.form['rating'], request.form['reviewid']))
        conn.commit()
        conn.close()
        return jsonify({'reviews': [{'personid': request.form['personid'], 'title': request.form['title'], 'description': request.form['description'], 'rating': request.form['rating'], 'reviewid': request.form['reviewid']}]}), 200
    if request.method == 'DELETE':
        reviewid = request.args.get('reviewid')
        conn = sqlite3.connect('database.db')
        cur = conn.cursor()
        cur.execute('DELETE FROM reviews WHERE reviewid = ?', (reviewid,))
        conn.commit()
        conn.close()
        return jsonify({'deleted reviews': [{'reviewid': reviewid }]}), 200


        conn = sqlite3.connect('database.db')
        cur = conn.cursor()
        cur.execute('DELETE FROM reviews WHERE reviewid = ?', (reviewid,))
        conn.commit()
        conn.close()
        return jsonify({'deleted reviews': [{'reviewid': reviewid }]}), 200
        
@app.route(appendurl+'/reviews/rating/', methods=['GET'])
def rating_reviews():
    if request.method == 'GET':
    #   could be a query parameter
    #   http://localhost/api/reviews/rating?personid=1
    #   http://localhost/api/reviews/rating?reviewid=1
        personid = request.args.get('personid')
        # egt the average rating of all reviews for a personid
        conn = sqlite3.connect('database.db')
        cur = conn.cursor()
        if personid is not None:
            cur.execute('SELECT personid,AVG(rating) FROM reviews WHERE personid = ?', (personid,))
        else:
            # select for each personid the average rating
            cur.execute('SELECT personid,AVG(rating) FROM reviews GROUP BY personid')
        # return the data with the named columns in json format
        # personid, avg rating
        # if data is None: return 404
        data = []
        for personid, rating in cur.fetchall():
            if personid is None:
                return jsonify({'reviews': 'ID not found'}), 400
            else:
                data += [{'personid': personid, 'rating': rating}]
        return jsonify({'reviews': data}), 200


# http://localhost/api/new_user
if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True,port=5005)