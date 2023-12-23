CODEBASE="file:///home/"$1"/Heist/dirGeneralRepo/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=false\
     -Djava.security.policy=java.policy\
     serverSide.main.ServerGeneralRepo 22131 localhost 22137