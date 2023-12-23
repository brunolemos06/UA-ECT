echo "Cleaning ports."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Assault Party 1 Node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'mkdir -p Heist'
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'rm -rf Heist/*'
sshpass -f password scp dirAssaultParty.zip sd104@l040101-ws08.ua.pt:Heist
echo "Decompressing data sent to the Assault Party 1 node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'cd Heist ; unzip -q dirAssaultParty.zip'
echo "Executing program at the Assault Party 1 node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'cd Heist/dirAssaultParty ; chmod +x *.sh ; ./ass_com_d.sh sd104 22134 0 8'
echo "Assault Party 0 server shutdown."