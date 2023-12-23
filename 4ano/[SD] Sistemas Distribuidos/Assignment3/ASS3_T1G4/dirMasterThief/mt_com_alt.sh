CODEBASE="file:///home/"$1"/Heist/dirMasterThief/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=false\
     clientSide.main.ClientMasterThief localhost 22137