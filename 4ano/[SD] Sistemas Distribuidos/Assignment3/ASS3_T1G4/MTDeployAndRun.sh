echo "Cleaning ports."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Master Thief Node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'mkdir -p Heist'
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'rm -rf Heist/*'
sshpass -f password scp dirMasterThief.zip sd104@l040101-ws09.ua.pt:Heist
echo "Decompressing data sent to the Master Thief node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'cd Heist ; unzip -q dirMasterThief.zip'
echo "Executing program at the Master Thief node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws09.ua.pt 'cd Heist/dirMasterThief ; chmod +x *.sh ; ./mt_com_d.sh'
echo "Master Thief node shutdown."