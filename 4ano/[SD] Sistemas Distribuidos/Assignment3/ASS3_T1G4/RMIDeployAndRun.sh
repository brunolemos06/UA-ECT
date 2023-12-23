echo "Cleaning ports."
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the RMI node."
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'mkdir -p Heist'
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'rm -rf Heist/*'
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'mkdir -p Public/classes/interfaces'
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'rm -rf Public/classes/interfaces/*'
sshpass -f password7 scp dirRMI.zip sd104@l040101-ws07.ua.pt:Heist
echo "Decompressing data sent to the RMIr node."
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'cd Heist ; unzip -q dirRMI.zip'
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'cd Heist/dirRMI ; cp interfaces/*.class /home/sd104/Public/classes/interfaces ; cp set_rmi_d.sh /home/sd104'
echo "Executing program at the RMI node."
sshpass -f password7 ssh -o StrictHostKeyChecking=no sd104@l040101-ws07.ua.pt 'chmod +x *.sh ; ./set_rmi_d.sh sd104 22137'
echo "RMI server shutdown."