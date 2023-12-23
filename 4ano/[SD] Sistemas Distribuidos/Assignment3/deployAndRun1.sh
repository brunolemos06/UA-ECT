chmod +x *.sh
chmod +x */*.sh
xterm -T "RMI Register" -hold -e "./RMIDeployAndRun.sh" &
sleep 10
xterm -T "Registry" -hold -e "./RegistryDeployAndRun.sh" &
sleep 10
xterm -T "General Repo" -hold -e "./GRDeployAndRun.sh" &
sleep 4
xterm -T "Assault Party 0" -hold -e "./AP0DeployAndRun.sh" &
xterm -T "Assault Party 1" -hold -e "./AP1DeployAndRun.sh" &
sleep 8
xterm -T "Museum" -hold -e "./MuseumDeployAndRun.sh" &
sleep 4
xterm -T "Concentration Site" -hold -e "./CSDeployAndRun.sh" &
sleep 4
xterm -T "Control Collection Site" -hold -e "./CCSDeployAndRun.sh" &
sleep 18
xterm -T "Master Thief" -hold -e "./MTDeployAndRun.sh" &
xterm -T "Normal Thief" -hold -e "./NTDeployAndRun.sh" &
