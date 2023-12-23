cd build 
echo "Cleaning ports."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Master Thief Node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'mkdir -p Heist'
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'rm -rf Heist/*'
sshpass -f ../password scp dirMasterThief.zip sd104@l040101-ws08.ua.pt:Heist
echo "Decompressing data sent to the Master Thief node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'cd Heist ; unzip -q dirMasterThief.zip'
echo "Executing program at the Master Thief node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws08.ua.pt 'cd Heist/dirMasterThief ; java clientSide.main.ClientMasterThief l040101-ws03.ua.pt 22132 l040101-ws02.ua.pt 22131 l040101-ws04.ua.pt 22133 l040101-ws05.ua.pt 22134'
echo "Master Thief node shutdown."