CODEBASE="http://localhost/"$1"/classes/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=true\
     -Djava.security.policy=java.policy\
     serverSide.main.ServerAssaultParty $2 localhost 22137 $3

# $1 - user
# $2 - port to listen to requests
# $3 - id of assault party (0 or 1)