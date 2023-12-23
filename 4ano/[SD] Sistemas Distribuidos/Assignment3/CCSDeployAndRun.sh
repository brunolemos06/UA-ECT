echo "Cleaning ports."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws02.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Control Collection Site Node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws02.ua.pt 'mkdir -p Heist'
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws02.ua.pt 'rm -rf Heist/*'
sshpass -f password scp dirControlCollectionSite.zip sd104@l040101-ws02.ua.pt:Heist
echo "Decompressing data sent to the Control Collection Site node."
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws02.ua.pt 'cd Heist ; unzip -q dirControlCollectionSite.zip'
echo "Executing program at the Control Collection Site node." 
sshpass -f password ssh -o StrictHostKeyChecking=no sd104@l040101-ws02.ua.pt 'cd Heist/dirControlCollectionSite ; chmod +x *.sh ; ./ccs_com_d.sh sd104'
echo "Control Collection Site server shutdown."