echo "Executing the Assault Party 2 Node"
cd /home/$USER/Heist/dirAssaultParty
java serverSide.main.ServerAssaultParty 22134 127.0.0.1 22130 1
# listens on port 22134,
# sends requests to General Repository on localhost port 22130
# and has id 1
echo "Assault Party 2 Server shutdown."