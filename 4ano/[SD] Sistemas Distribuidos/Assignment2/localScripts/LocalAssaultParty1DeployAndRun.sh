echo "Executing the Assault Party 1 Node"
cd /home/$USER/Heist/dirAssaultParty
java serverSide.main.ServerAssaultParty 22133 127.0.0.1 22130 0
# listens on port 22133,
# sends requests to General Repository on localhost port 22130
# and has id 0
echo "Assault Party 1 Server shutdown."