cd build
echo "Cleaning ports."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws01.ua.pt 'killall -9 -u sd104 java'
echo "Transfering data to the General Repo Node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws01.ua.pt 'mkdir -p Heist'
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws01.ua.pt 'rm -rf Heist/*'
sshpass -f ../password scp dirGeneralRepo.zip sd104@l040101-ws01.ua.pt:Heist
echo "Decompressing data sent to the General Repo node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws01.ua.pt 'cd Heist ; unzip -q dirGeneralRepo.zip'
echo "Executing program at the General Repo node."
sshpass -f ../password ssh -o StrictHostKeyChecking=no sd104@l040101-ws01.ua.pt 'cd Heist/dirGeneralRepo ; java serverSide.main.ServerGeneralRepo 22130'
echo "General Repo server shutdown."
echo "Bringing Log File."
cd ../
sshpass -f password scp -o StrictHostKeyChecking=no sd104@l040101-ws01.ua.pt:Heist/dirGeneralRepo/log.txt .