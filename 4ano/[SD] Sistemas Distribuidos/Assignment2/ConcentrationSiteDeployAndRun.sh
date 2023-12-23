cd build
echo "Cleaning ports."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws03.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Concentration Site Node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws03.ua.pt 'mkdir -p Heist'
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws03.ua.pt 'rm -rf Heist/*'
sshpass -f ../password scp dirConcentrationSite.zip sd104@l040101-ws03.ua.pt:Heist
echo "Decompressing data sent to the Concentration Site node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws03.ua.pt 'cd Heist ; unzip -q dirConcentrationSite.zip'
echo "Executing program at the Concentration Site node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws03.ua.pt 'cd Heist/dirConcentrationSite ; java serverSide.main.ServerConcentrationSite 22132 l040101-ws01.ua.pt 22130 l040101-ws04.ua.pt 22133 l040101-ws05.ua.pt 22134'
echo "Concentration Site server shutdown."