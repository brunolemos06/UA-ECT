CODEBASE="file:///home/"$1"/Heist/dirControlCollectionSite/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=false\
     -Djava.security.policy=java.policy\
     serverSide.main.ServerControlCollectionSite 22132 localhost 22137