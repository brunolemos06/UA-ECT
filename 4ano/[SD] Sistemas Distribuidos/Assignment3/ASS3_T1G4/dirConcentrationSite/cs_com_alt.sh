CODEBASE="file:///home/"$1"/Heist/dirConcentrationSite/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=false\
     -Djava.security.policy=java.policy\
     serverSide.main.ServerConcentrationSite 22133 localhost 22137