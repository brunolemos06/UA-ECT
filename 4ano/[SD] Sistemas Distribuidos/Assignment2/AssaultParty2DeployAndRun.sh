cd build
echo "Cleaning ports."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws05.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Assault Party 2 Node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws05.ua.pt 'mkdir -p Heist'
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws05.ua.pt 'rm -rf Heist/*'
sshpass -f ../password scp dirAssaultParty.zip sd104@l040101-ws05.ua.pt:Heist
echo "Decompressing data sent to the Assault Party 2 node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws05.ua.pt 'cd Heist ; unzip -q dirAssaultParty.zip'
echo "Executing program at the Assault Party 2 node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws05.ua.pt 'cd Heist/dirAssaultParty ; java serverSide.main.ServerAssaultParty 22134 l040101-ws01.ua.pt 22130 1'
echo "Assault Party 2 server shutdown."