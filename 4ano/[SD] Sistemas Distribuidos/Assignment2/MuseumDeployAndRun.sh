cd build
echo "Cleaning ports."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws06.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the Museum Node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws06.ua.pt 'mkdir -p Heist'
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws06.ua.pt 'rm -rf Heist/*'
sshpass -f ../password scp dirMuseum.zip sd104@l040101-ws06.ua.pt:Heist
echo "Decompressing data sent to the Museum node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws06.ua.pt 'cd Heist ; unzip -q dirMuseum.zip'
echo "Executing program at the Museum node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws06.ua.pt 'cd Heist/dirMuseum ; java serverSide.main.ServerMuseum 22135 l040101-ws01.ua.pt 22130 l040101-ws04.ua.pt 22133 l040101-ws05.ua.pt 22134'
echo "Museum server shutdown."