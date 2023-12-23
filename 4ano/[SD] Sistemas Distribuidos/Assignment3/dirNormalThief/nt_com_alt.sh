CODEBASE="file:///home/"$1"/Heist/dirNormalThief/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=false\
     clientSide.main.ClientNormalThief localhost 22137