cd build
echo "Cleaning ports."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Normal Thief Node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'mkdir -p Heist'
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'rm -rf Heist/*'
sshpass -f ../password scp dirNormalThief.zip sd104@l040101-ws09.ua.pt:Heist
echo "Decompressing data sent to the Normal Thief node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'cd Heist ; unzip -q dirNormalThief.zip'
echo "Executing program at the Normal Thief node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'cd Heist/dirNormalThief ; java clientSide.main.ClientNormalThief l040101-ws03.ua.pt 22132 l040101-ws02.ua.pt 22131 l040101-ws04.ua.pt 22133 l040101-ws05.ua.pt 22134 l040101-ws06.ua.pt 22135 l040101-ws01.ua.pt 22130'
echo "Normal Thief node shutdown."