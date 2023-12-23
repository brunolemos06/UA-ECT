echo "Cleaning ports."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws10.ua.pt 'killall -9 -u sd104'
echo "Transfering data to normal thief node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws10.ua.pt 'mkdir -p Heist'
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws10.ua.pt 'rm -rf Heist/*'
sshpass -f password scp dirNormalThief.zip sd104@l040101-ws10.ua.pt:Heist
echo "Decompressing data sent to normal thief node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws10.ua.pt 'cd Heist ; unzip -q dirNormalThief.zip'
echo "Executing program at the Normal Thief node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws10.ua.pt 'cd Heist/dirNormalThief ; chmod +x *.sh ; ./nt_com_d.sh'
echo "Normal Thief node shutdown."