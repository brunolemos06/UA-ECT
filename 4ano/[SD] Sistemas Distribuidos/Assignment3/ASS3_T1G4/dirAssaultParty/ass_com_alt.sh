CODEBASE="file:///home/"$1"/Heist/dirAssaultParty/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=false\
     -Djava.security.policy=java.policy\
     serverSide.main.ServerAssaultParty $2 localhost 22137 $3

# $1 - user
# $2 - port to listen to requests
# $3 - id of assault party (0 or 1)