sudo bash buildAndGenerate.sh
chmod +x *.sh
xterm -T "General Repo" -hold -e "./GeneralRepoDeployAndRun.sh" &
sleep 2
xterm -T "AssaultParty1" -hold -e "./AssaultParty1DeployAndRun.sh" &
xterm -T "AssaultParty2" -hold -e "./AssaultParty2DeployAndRun.sh" &
sleep 2
xterm -T "Museum" -hold -e "./MuseumDeployAndRun.sh" &
xterm -T "Concentration Site" -hold -e "./ConcentrationSiteDeployAndRun.sh" &
xterm -T "Control Collection Site" -hold -e "./ControlCollectionSiteDeployAndRun.sh" &
sleep 2
xterm -T "Normal Thieves"  -hold -e "./NormalThiefDeployAndRun.sh" &
xterm -T "Master Thief"  -hold -e "./MasterThiefDeployAndRun.sh" &
sleep 20
sudo rm -rf build