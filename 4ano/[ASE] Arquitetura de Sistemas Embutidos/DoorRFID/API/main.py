# flask api 
import json
from flask import Flask, jsonify, request,render_template
from flask_cors import CORS
import datetime
import requests
import socket
import matplotlib.pyplot as plt
rfidip = ""


# VARIABLES
app = Flask(__name__)
JSONFILE = 'data.json'

@app.route('/', methods=['GET'])
def home():
    return "<h1>API</h1><p>This RFIDsite is a prototype API for the users and logs.</p>"

@app.route('/users', methods=['GET'])
def get_users():
    if 'rfid' in request.args:
        # verify if the rfid is in the users
        rfid = request.args['rfid']
        users = getUsers()
        results = []
        response = "false",300
        for user in users:
            if user['rfid'] == rfid:
                response = "true",200
        return response
    users = getUsers()
    response = ""
    for user in users:
        response += user['rfid'] + " "
    return response,200

@app.route('/users', methods=['POST'])
def post_users():
    # http://ip:5000/users?rfid=123456789
    users = getUsers()
    logs = getLogs()
    rfid = request.args.get('rfid')
    users.append({'rfid': rfid, 'day': datetime.datetime.now().strftime("%d-%m-%Y"), 'hour': datetime.datetime.now().strftime("%Hh%M")})
    with open(JSONFILE, 'w') as outfile:
        json.dump({'users': users, 'logs': logs}, outfile)
    return jsonify(users)

@app.route('/users', methods=['DELETE'])
def delete_users():
    # http://ip:5000/users?rfid=123456789
    users = getUsers()
    logs = getLogs()
    rfid = request.args.get('rfid')
    users = [user for user in users if user['rfid'] != rfid]
    with open(JSONFILE, 'w') as outfile:
        json.dump({'users': users, 'logs': logs}, outfile)
    return jsonify(users)

@app.route('/logs', methods=['GET'])
def get_logs():
    return jsonify(getLogs())

@app.route('/logs', methods=['POST'])
def post_logs():
    # http://ip:5000/users?data=12-05-2000&hora=18:29&status=Allow&rfid=123456789
    users = getUsers()
    logs = getLogs()
    data = request.args.get('data')
    hora = request.args.get('hora')
    status = request.args.get('status')
    rfid = request.args.get('rfid')
    logs.append({'data': data, 'hora': hora, 'status': status, 'rfid': rfid})
    with open(JSONFILE, 'w') as outfile:
        json.dump({'users': users, 'logs': logs}, outfile)
    return jsonify(logs)

@app.route('/app', methods=['GET'])
def get_app():
    extra = "<img src=\"https://res.cloudinary.com/kisi-kloud/image/upload/c_lfill,dpr_auto,f_auto,q_auto:good,w_2078/v1/products/access-methods/kisi-reader-pro-credentials-card\" width=\"300\" height=\"300\" class=\"image\">"
    extra += "\
        </div>\
      </body>\
    </html>"
    return render_template('template.html') + extra

@app.route('/app/logs', methods=['GET'])
def get_app_logs():
    logs = getLogs()
    users = getUsers()
    extra = "<div class=\"card-grid\"><div class=\"card\"><table><thead><tr><th>Day</th><th>Hour</th><th>Card</th><th>Status</th></tr></thead><tbody>"
    for log in reversed(logs):
        # verify if the rfid is in the users
        card = log['rfid']
        for user in users:
            if user['rfid'] == log['rfid']:
                if 'name' in user:
                    card = user['name']
                    break
        extra += "<tr><td>" + log['data'] + "</td><td>" + log['hora'] + "</td><td>" + card + "</td><td>"
        if log['status'] == 'Accepted':
            extra += "<font color=\"green\">" + log['status'] + "</font>"
        elif log['status'] == 'Declined':
            extra += "<font color=\"red\">" + log['status'] + "</font>"
        elif log['status'] == 'Removed':
            extra += "<font color=\"orange\">" + log['status'] + "</font>"
        elif log['status'] == 'Added' or log['status'] == 'Updated':
            extra += "<font color=\"blue\">" + log['status'] + "</font>"
        else:
            extra += log['status']
        extra += "</td></tr>"
    extra += "</tbody></table></div></div>"
    extra += "\
        </div>\
        </body>\
        </html>"
    return render_template('template.html') + extra

@app.route('/app/users', methods=['GET'])
def get_app_users():
    users = getUsers()
    logs = getLogs()
    extra = "<div class=\"card-grid\"><div class=\"card\"><table><thead><tr><th>Name</th><th>RFID</th><th>Sucess Entries</th></tr></thead><tbody>"
    for user in reversed(users):
        # how many times the user entered
        entries = 0
        for log in logs:
            if log['rfid'] == user['rfid'] and log['status'] == 'Accepted':
                entries += 1
        if 'name' in user:
            extra += "<tr><td>" + user['name'] + "</td><td>" + user['rfid'] + "</td><td>" + str(entries) + "</td></tr>"
        else:
            extra += "<tr><td>---- ---- ---- ---- ----</td><td>" + user['rfid'] + "</td><td>" + str(entries) + "</td></tr>"



    # Generate one graph with lines for each user
    names = []
    for user in users:
        if 'name' in user:
            names.append(user['name'])
        else:
            names.append(user['rfid'])
    # get all the dates
    dates = []
    for log in logs:
        if log['data'] not in dates:
            dates.append(log['data'])

    # get the entries for each user
    entries = []
    for user in users:
        # get the entries for each date
        user['name'] = []
        for date in dates:
            value = 0
            for log in logs:
                if log['data'] == date and log['rfid'] == user['rfid']: 
                    value += 1
            user['name'].append(value)
        entries.append(user['name'])
    # plot the graph
    plt.figure(figsize=(120,60))
    # lines 5px wide
    for user in users:
        plt.plot(dates, user['name'], linewidth=20)
    plt.legend(names, loc='upper left', fontsize=80)
    plt.xticks(fontsize=80)
    plt.yticks(fontsize=80)
    plt.savefig('static/graph.png')
    plt.close()

    extra += "</tbody></table>"
    # add an div to separate the graph with ""
    extra += "<div class=\"free\"><div class=\"card\"><h3></h3>"
    # show the graph in the page
    extra += "<div class=\"card-grid\"><div class=\"card\"><img src=\"/static/graph.png\" width=\"800\" height=\"500\" class=\"image\"></div></div>"
    extra += "</div></div>"
    extra += "\
        </div>\
        </body>\
        </html>"
    return render_template('template.html') + extra

@app.route('/app/config', methods=['GET'])
def get_app_config():
    global rfidip
    try:
        # print all request args
        print(request.args)
        
        rfid = request.args.get('remove')
        # remove the rfid from the users
        if rfid != None:
            users = getUsers()
            logs = getLogs()
            users = [user for user in users if user['rfid'] != rfid]
            logs.append({'data': datetime.datetime.now().strftime("%d-%m-%Y"), 'hora': datetime.datetime.now().strftime("%Hh%M"), 'status': 'Removed', 'rfid': rfid})
            with open(JSONFILE, 'w') as outfile:
                json.dump({'users': users, 'logs': logs}, outfile)

        if request.args.get('start') != None:
            requests.get("http://"+rfidip+"/config?start=1", timeout=1)

        # config?addname=763221640328
        if request.args.get('addname') and request.args.get('name'):
            users = getUsers()
            logs = getLogs()
            rfid = request.args.get('addname')
            name = request.args.get('name')
            # get the user
            for user in users:
                if user['rfid'] == rfid:
                    user['name'] = name
                    break
            logs.append({'data': datetime.datetime.now().strftime("%d-%m-%Y"), 'hora': datetime.datetime.now().strftime("%Hh%M"), 'status': 'Updated', 'rfid': rfid})
            with open(JSONFILE, 'w') as outfile:
                json.dump({'users': users, 'logs': logs}, outfile)

            # redirect to 
            print("IAM REDIREDCTING")
            pass

        if request.args.get('connect') != None and request.args.get('ip') != None:
            # get ip that is making the request
            myip = request.remote_addr
            rfidip = request.args.get('ip')
            print("MY IP IS: " + myip)
            # request with timeout
            requests.get("http://"+rfidip+"/config?connect=" + myip + ":5000", timeout=1)

        if request.args.get('disconnect') != None:
            try:
                requests.get("http://"+rfidip+"/config?disconnect=1", timeout=2)
            except Exception as e:
                pass
            rfidip = ""
    except Exception as e:
        # print the exception
        print(e)
        pass
    users = getUsers()
    extra = "<div class=\"card-grid2\"><div class=\"card2\"><i class=\"fas fa-lightbulb blue\" width=\"150\" height=\"150\"></i><h3>&nbsp;&nbsp;&nbsp;Config MODE</h3>"
    extra += "<a href=\"/app/config?start=1\"><button class=\"addname-button\">Write Card</button></a>"
    if rfidip == "":
        extra +=  "<form class=\"addname-form\" action=\"/app/config\" method=\"get\"><input type=\"hidden\" name=\"connect\" value=\"1\"><input class=\"addname-button\" type=\"submit\" value=\"Connect\"><input class=\"addname-input\" type=\"text\" name=\"ip\" placeholder=\"IP\"></form>"
    else:
        extra += "<h3>Connected to " + rfidip + "</h3>"
        extra += "<a href=\"/app/config?disconnect=1\"><button class=\"rmbutton\">Disconnect</button></a>"
    # show my ip
    extra += "</div></div>"


    extra += "<div class=\"card-grid\"><div class=\"card\"><table><thead><tr><th>Name</th><th>RFID</th><th>Time</th><th>Action</th></tr></thead><tbody>"
    for user in reversed(users):
        if 'name' in user:
            extra += "<tr><td>" + user['name'] + "</td><td>" + user['rfid'] + "</td><td>"+user['day']+" "+ user['hour'] +"</td><td><a href=\"/app/config?remove=" + user['rfid'] + "\"><button class=\"rmbutton\">Remove</button></a></td></tr>"
        else:
            extra += "<tr><td><form class=\"addname-form\" action=\"/app/config\" method=\"get\"><input type=\"hidden\" name=\"addname\" value=\"" + user['rfid'] + "\"><input class=\"addname-input\" type=\"text\" name=\"name\" placeholder=\"Name\"><input class=\"addname-button\" type=\"submit\" value=\"Add\"></form></td><td>" + user['rfid'] + "</td><td>"+user['day']+" "+ user['hour'] +"</td><td><a href=\"/app/config?remove=" + user['rfid'] + "\"><button class=\"rmbutton\">Remove</button></a>"


    extra += "</tbody></table></div></div>"
    extra += "</div></body></html>"
    return render_template('template.html') + extra

# auxiliar function
def getJson(file):
    with open(file) as json_file:
        data = json.load(json_file)
    return data

def getUsers():
    return getJson(JSONFILE)['users']

def getLogs():
    return getJson(JSONFILE)['logs']

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)