import time
import flask 
from flask_restful import  Api
from flask import Flask,redirect,render_template
import os
import string
from twilio.rest import Client
from flask_swagger_ui import get_swaggerui_blueprint
from flask import jsonify
from flask_swagger import swagger


# account_sid="ACf8b3ce0eb04f21fe7ab30a6e0c58c7d9"
# auth_token= "4cb96b0112a701609a3b621bc403af76"
# service_sid="ISec5512aaa2db4d6abaf1bd31a60fa474"

account_sid = os.getenv("TWILIO_ACCOUNT_SID")
auth_token = os.getenv("TWILIO_AUTH_TOKEN")
service_sid = os.getenv("TWILIO_SERVICE_SID")
client = Client(account_sid, auth_token)

configuration = client.conversations \
                      .v1 \
                      .services(service_sid) \
                      .configuration() \
                      .update(reachability_enabled=True)
print(configuration.reachability_enabled)


app = flask.Flask(__name__)

SWAGGER_URL = '/docs'  # URL for exposing Swagger UI (without trailing '/')
API_URL = '/static/swagger.json'  # Our API url (can of course be a local resource)

# Call factory function to create our blueprint
swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,  # Swagger UI static files will be mapped to '{SWAGGER_URL}/dist/'
    API_URL,
    config={  # Swagger UI config overrides
        'app_name': "Test application"
    },
    # oauth_config={  # OAuth config. See https://github.com/swagger-api/swagger-ui#oauth2-configuration .
    #    'clientId': "your-client-id",
    #    'clientSecret': "your-client-secret-if-required",
    #    'realm': "your-realms",
    #    'appName': "your-app-name",
    #    'scopeSeparator': " ",
    #    'additionalQueryStringParams': {'test': "hello"}
    # }
)

app.register_blueprint(swaggerui_blueprint)

api=Api(app)


# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chat.db'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)







# def get_data():
   
#     #get the list of conversations
#     conversations = client.conversations \
#                             .v1 \
#                             .conversations \
#                             .list()
#     for record in conversations:
#         #put the conversation in the db
#         print(record.sid)
#         print(record.friendly_name)

#         c = Conversation(c_id=record.sid, friendly_name=record.friendly_name)
#         db.session.add(c)
#         db.session.commit()
#         #get the list of participants
    
#     # user = client.conversations \
#     #                     .v1 \
#     #                     .users \
#     #                     .create(identity="test"
#     #                             )
#     users = client.conversations \
#                         .v1 \
#                         .users \
#                         .list()
#     # for user in users:
#     #     print(user.is_notifiable)
#         # #make the user notifiable
#         # user = client.conversations \
#         #                 .v1 \
#         #                 .users(user.identity) \
#         #                 .update(is_online=True,is_notifiable=True)

    
    
#     # user_conversation = client.conversations \
#     #                         .v1 \
#     #                         .users('USXXXXXXXXXXXXX') \
#     #                         .user_conversations('CHXXXXXXXXXXXXX') \
#     #                         .fetch()

#     # print(user_conversation.friendly_name)

    
#     for record in users:
#         #put the user in the db
#         print(record.sid)
#         print(record.identity)
#         print(record.is_online)

    
        
#         u=Participant(p_id=record.sid, identity=record.identity)
#         convs=client.conversations \
#                         .v1 \
#                         .users(record.sid) \
#                         .user_conversations\
#                         .list()
        
#         if convs is not []:
#             for conv in convs:
#                 print(conv.notification_level)
#                 u.con_id=conv.conversation_sid
#                 conv.update(notification_level="default")
        
#         db.session.add(u)   
#         db.session.commit()
#         print("User "+u.identity+" added")

#         # if convs is not []:
#         #     for conv in convs:
#         #         print(conv.sid)
#         #         print(conv.conversation_sid)
#         #         if conv.conversation_sid is not None:
#         #             u = Participant(p_id=record.sid, identity=record.identity,con_id=conv.conversation_sid)
#         #             db.session.add(u)
#         #             db.session.commit()
#         # else:
#         #     u = Participant(p_id=record.sid, identity=record.identity)
#         #     db.session.add(u)
#         #     db.session.commit()
#     #lets check  if any of the users are in any of the conversations

    


#     for record in conversations:
#         #get the list of messages
#         messages = client.conversations \
#                             .v1 \
#                             .conversations(record.sid) \
#                             .messages \
#                             .list()
#         #store the conversation sid
#         conversation_sid = record.sid
#         for record in messages:
#             #put the message in the db
#             print(record.sid)
#             print(record.body)
#             print(record.author)

#             m = Message(m_id=record.sid, body=record.body,conversation_id=conversation_sid,author=record.author)
#             db.session.add(m)
#             db.session.commit()
#     #load the home page
#     # return render_template('index.html')
#     #update 1 user
    
#     db.session.commit()
#     return {'message': 'hello'}
# with app.app_context():
#     get_data()

@app.route('/', methods=['GET'])
def home():
    return 'Welcome to the Twilio Conversations API'


@app.route('/conversations', methods=['GET'])
def conversations_info(): #create a new conversation
    """
        Get a conversation by id or author or get all the conversations
    ---
    tags:
        - Conversations
    definitions:
        - schema:
            id: Conversation
            properties:
                c_id:
                    type: string
                    description: The conversation id
            
    
    parameters:
        - in: query
            name:c_id
            type:string
            description:The conversation id
        - in: query
            name:author
            type:string
            description:The ID of the user we want to filter conversations by
    responses:
        200:
            description: Conversation found
        400:
            description: Bad request
    """
    #get the parameters from the query string like ?c_id=1234 or ?author=1234

    c_id= flask.request.args.get('c_id')
    author= flask.request.args.get('author')



    # data = flask.request.get_json()
    # #args should be c_id or author

    # c_id = data.get('c_id')
    # author = data.get('author')

    if c_id is not None and author is None:
        # conversations = Conversation.query.all()
        conversation = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .fetch()
        
       
        
        # for message in messages:
        #     print(message.sid)
        #     print(message.body)
        #     print(message.author)



        if not conversation:
            return {'message': 'No conversation found'}
        conversation_data = {}
        conversation_data['id'] = conversation.sid
        conversation_data['friendly_name'] = conversation.friendly_name
        #get the messages for that conversation
        # messages = Message.query.filter_by(conversation_id=c_id).all()
        messages=client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .messages\
                            .list()
        conversation_data['messages'] = []
        for message in messages:
            message_data = {}
            message_data['id'] = message.sid
            message_data['body'] = message.body
            message_data['author'] = message.author
            conversation_data['messages'].append(message_data)
        return {'conversation': conversation_data}
        
    elif author is not None and c_id is None:
        # conversations = Conversation.query.all()
        user=client.conversations \
                            .v1 \
                            .users(author)\
                            .fetch()
                

        conversations = client.conversations \
                            .v1 \
                            .conversations \
                            .list()

        output = []
        for conversation in conversations:
        
            conversation_data = {}
            conversation_data['id'] = conversation.sid
            conversation_data['friendly_name'] = conversation.friendly_name
            messages=client.conversations \
                            .v1 \
                            .conversations(conversation.sid) \
                            .messages\
                            .list()
            # messages = Message.query.filter_by(conversation_id=conversation.c_id).all()
            print (messages)
            conversation_data['messages'] = []
            for message in messages:
                message_data = {}
                message_data['id'] = message.sid
                message_data['body'] = message.body
                message_data['author'] = message.author
                conversation_data['messages'].append(message_data)
            #check if that conversation has a participant with the name

            participants = client.conversations \
                            .v1 \
                            .conversations(conversation.sid) \
                            .participants \
                            .list()
            
            #users of this conversation
            user=client.conversations \
                            .v1 \
                            .users(author) \
                            .fetch()
                            
          
            
            #check if the user is in the conversation

           
            for participant in participants:
                print(participant.sid)
                print(user.identity)
                
                if participant.identity == user.identity:
                    output.append(conversation_data)
        return jsonify(output)

    else:
        #all conversations
        conversations = client.conversations \
                            .v1 \
                            .conversations \
                            .list()
        output = []
        for conversation in conversations:
            conversation_data = {}
            conversation_data['id'] = conversation.sid
            conversation_data['friendly_name'] = conversation.friendly_name
            output.append(conversation_data)
        return {'conversations': output}
    
    
@app.route('/conversations', methods=['POST'])
def update_conversation():
    """
        Get a conversation by id or author or get all the conversations
    ---
    tags:
        - Conversations
    definitions:
        - schema:
            id: Conversation
            properties:
                c_id: 
                    type: string
                    description: The conversation id
                message:
                    type: string
                    description: The message to send
                member:
                    type: string
                    description: The member to add
                author:
                    type: string
                    description: The author of the message 
            
    parameters:
        - in: body
            name:c_id
            type:string
            description:The conversation id
            required:true
        - in: body
            name:author
            type:string
            description:The author of the conversation
        - in: body
            name:message
            type:string
            description:The message to send
        - in: body
            name:member
            type:string
            description:The member to add
        - in: body
            name:friendly_name
            type:string
            description:The friendly name of the conversation
    responses:
        200:
            description: Conversation found
        400:
            description: Bad request
    """
    
    #use params to update the conversation
    # data = flask.request.args()
    f_name = flask.request.args.get('f_name') ##must not be none
    message=flask.request.args.get('message') #message to send
    member=flask.request.args.get('member') #member to add  (user id)
    author=flask.request.args.get('author') #author of the message (user id)
    c_id=''
    ##get the c_id of the conversation from the friendly name
    if f_name is not None:
        conversations = client.conversations \
                            .v1 \
                            .conversations \
                            .list()
        for c in conversations:
            if c.friendly_name == f_name:
                print(c.sid)
                c_id = c.sid


    if c_id is None:
        return {'message': 'No conversation id provided'}
    
    # conversation = Conversation.query.filter_by(c_id=c_id).first()
    conversation=client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .fetch()
    
    if not conversation:
        return {'message': 'No conversation found'}
    if message is not None and author is not None:
        message = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .messages \
                            .create(author=author,body=message)
        # m=Message(m_id=message.sid, body=message.body, conversation_id=c_id, author=message.author)
        if not message:
            return {'message': 'The message was not sent'}
        # db.session.add(m)
        # db.session.commit(k)
        notification = client.conversations \
                            .v1 \
                            .services(service_sid) \
                            .configuration \
                            .notifications() \
                            .update(
                                new_message_enabled=True,
                                new_message_sound='default',
                                new_message_template='There is a new message in ${CONVERSATION} from ${PARTICIPANT}: ${MESSAGE}'
                            )

        #get that notification

        # print(notification.added_to_conversation)
        #send the notification

        #check if any new notifications are added
        # notifications = client.conversations \
        #                     .v1 \
        #                     .services(service_sid) \
        #                     .configuration \
        #                     .notifications() \
        #                     .list()
        
        
        return {'message': 'The message was sent'}
    if member is not None and message is None and author is None:
        #get the user 
        # participant = client.conversations \
        #                     .v1 \
        #                     .conversations(c_id) \
        #                     .participants \
        #                     .list()

        user=client.conversations \
                            .v1 \
                            .users(member) \
                            .fetch()
        

                            
        # user = Participant.query.filter_by(p_id=member).first()
        if not user:
            return {'message': 'No user found'}
        participant = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .participants \
                            .create(identity=user.identity)
        
        return {'message': 'The member was added'}
    
    
    else:
        return {'message': 'Bad request'}
    
@app.route('/new_conversation', methods=['POST'])
def new_conversation():
    friendly_name = flask.request.args.get('friendly_name')

    if friendly_name is None:
        return {'message': 'No friendly name provided'}
    conversation = client.conversations \
                        .v1 \
                        .conversations \
                        .create(friendly_name=friendly_name)
    
    return {'message': 'The conversation was created',
            'friendly_name': conversation.friendly_name}
@app.route('/new_user', methods=['POST'])
def new_user():
    identity = flask.request.args.get('identity')
    if identity is None:
        return {'message': 'No identity provided'}
    #get all the users
    users = client.conversations \
                    .v1 \
                    .users \
                    .list()
    for u in users:
        if u.identity == identity:
            return {'message': 'The user is already in the database',
                    'UID': u.sid}
        
    user = client.conversations \
                        .v1 \
                        .users \
                        .create(identity=identity)
    
    return {'UID': user.sid}
@app.route('/conversations', methods=['DELETE'])
def delete():
    member = flask.request.args.get('member')
    # c_id = flask.request.args.get('c_id')
    c_id=''
    f_name = flask.request.args.get('f_name')
    print(f_name)
    print(member)

    ##get the c_id of the conversation from the friendly name
    if f_name is not None:
        conversations = client.conversations \
                            .v1 \
                            .conversations \
                            .list()
        for c in conversations:
            if c.friendly_name == f_name:
                print(c.sid)
                c_id = c.sid
        

    if c_id is None:
        return {'message': 'No conversation id provided'}
    # conversation = Conversation.query.filter_by(c_id=c_id).first()
    conversation = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .fetch()
    
    if not conversation:
        return {'message': 'No conversation found'}
    if member is None:
        print('here')
        print(c_id)
        #get conversation from db and delete it
        # c = Conversation.query.filter_by(c_id=c_id).first()
        conversation = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .delete()
        
        return {'message': 'The conversation was deleted'}
    elif member is not None:
        #get participant from db and delete it
        participant = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .participants(member) \
                            .fetch()
        if not participant:
            return {'message': 'No participant found'}
        
        participant = client.conversations \
                            .v1 \
                            .conversations(c_id) \
                            .participants(member) \
                            .delete()
        # p = Participant(p_id=participant.sid, con_id=c_id, identity=participant.identity)
        return {'message': 'The member was removed from the conversation'}
    else:
        return {'message': 'Bad request'}



@app.route("/spec")
def spec():
    return jsonify(swagger(app))

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True,port = 5010)
    