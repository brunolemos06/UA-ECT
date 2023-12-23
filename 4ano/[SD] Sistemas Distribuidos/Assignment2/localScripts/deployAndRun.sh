xterm -T "GeneralRepo" -hold -e "bash LocalRepoDeployAndRun.sh" &
sleep 1
xterm -T "AssaultParty1" -hold -e "bash LocalAssaultParty1DeployAndRun.sh" &
sleep 1
xterm -T "AssaultParty2" -hold -e "bash LocalAssaultParty2DeployAndRun.sh" &
sleep 1
xterm -T "Museum" -hold -e "bash LocalMuseumDeployAndRun.sh" &
sleep 1
xterm -T "Concentration" -hold -e "bash LocalConcentrationDeployAndRun.sh" &
sleep 1
xterm -T "ControlCollection" -hold -e "bash LocalControlCollectionDeployAndRun.sh" &
sleep 1
xterm -T "NormalThieves"  -hold -e "bash LocalNormalThiefDeployAndRun.sh" &
xterm -T "MasterThief"  -hold -e "bash LocalMasterThiefDeployAndRun.sh" &