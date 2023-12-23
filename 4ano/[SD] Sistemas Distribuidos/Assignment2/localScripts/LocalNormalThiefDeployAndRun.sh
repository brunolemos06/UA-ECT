echo "Transfering data to the Normal Thief node."
cd /home/$USER/Heist/dirNormalThief
java clientSide.main.ClientNormalThief 127.0.0.1 22132 127.0.0.1 22131 127.0.0.1 22133 127.0.0.1 22134 127.0.0.1 22135  127.0.0.1 22130
# sends requests to Concentration Site on localhost port 22132,
# sends requests to Control Collection Site on localhost port 22131,
# sends requests to Assault Party 1 on localhost port 22133,
# sends requests to Assault Party 2 on localhost port 22134,
# sends requests to Museum on localhost port 22135,
# sends requests to General Repo on localhost port 22130
echo "Normal Thief node shutdown."