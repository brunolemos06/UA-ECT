echo "Transfering data to the Master Thief node."
cd /home/$USER/Heist/dirMasterThief
java clientSide.main.ClientMasterThief 127.0.0.1 22132 127.0.0.1 22131 127.0.0.1 22133 127.0.0.1 22134
# sends requests to Concentration Site on localhost port 22132,
# sends requests to Control Collection Site on localhost port 22131,
# sends requests to Assault Party 1 on localhost port 22133,
# sends requests to Assault Party 2 on localhost port 22134
echo "Master Thief node shutdown."