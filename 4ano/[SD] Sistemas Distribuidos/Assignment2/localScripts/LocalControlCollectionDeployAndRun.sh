echo "Executing the Control Collection Node"
cd /home/$USER/Heist/dirControlCollectionSite
java serverSide.main.ServerControlCollectionSite 22131 127.0.0.1 22130 127.0.0.1 22133 127.0.0.1 22134 
# listens on port 22131,                            
# sends requests to General Repository on localhost port 22130,
# sends requests to Assault Party 1 on localhost port 22133,
# sends requests to Assault Party 2 on localhost port 22134
echo "Control Collection Server Shutdown."