echo "Transfering data to the registry node."
sshpass -f password7 ssh sd104@l040101-ws07.ua.pt 'mkdir -p Heist'
sshpass -f password7 scp dirRegistry.zip sd104@l040101-ws07.ua.pt:Heist
echo "Decompressing data sent to the registry node."
sshpass -f password7 ssh sd104@l040101-ws07.ua.pt 'cd Heist ; unzip -q dirRegistry.zip'
echo "Executing program at the registry node."
sshpass -f password7 ssh sd104@l040101-ws07.ua.pt 'cd Heist/dirRegistry ; chmod +x *.sh ; ./registry_com_d.sh sd104'
echo "Registry node shutdown."