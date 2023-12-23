echo "Compiling the project."
javac -source 1.8 -target 1.8 commInfra/*.java clientSide/*/*.java serverSide/*/*.java interfaces/*.java

echo "Distributing intermediate code to the different execution environments."

echo "  RMI registry"
rm -rf dirRMI/interfaces
mkdir -p dirRMI/interfaces
cp interfaces/*.class dirRMI/interfaces

echo "  Register Remote Objects"
rm -rf dirRegistry/interfaces/ dirRegistry/serverSide
mkdir -p dirRegistry/interfaces dirRegistry/serverSide dirRegistry/serverSide/main dirRegistry/serverSide/objects
cp serverSide/main/ServerRegisterRemoteObject.class dirRegistry/serverSide/main
cp serverSide/objects/RegisterRemoteObject.class dirRegistry/serverSide/objects
cp interfaces/Register.class dirRegistry/interfaces

echo "  General Repository of Information"
rm -rf dirGeneralRepo/serverSide/ dirGeneralRepo/interfaces dirGeneralRepo/clientSide
mkdir -p dirGeneralRepo/serverSide dirGeneralRepo/serverSide/main dirGeneralRepo/serverSide/objects dirGeneralRepo/clientSide dirGeneralRepo/clientSide/entities dirGeneralRepo/interfaces
cp serverSide/main/SimulPar.class serverSide/main/ServerGeneralRepo.class dirGeneralRepo/serverSide/main
cp serverSide/objects/GeneralRepo.class dirGeneralRepo/serverSide/objects
cp interfaces/Register.class interfaces/GeneralRepoInterface.class dirGeneralRepo/interfaces
cp clientSide/entities/NormalThiefStates.class clientSide/entities/MasterThiefStates.class dirGeneralRepo/clientSide/entities

echo "  Assault Party"
rm -rf dirAssaultParty/serverSide/ dirAssaultParty/interfaces dirAssaultParty/clientSide
mkdir -p dirAssaultParty/serverSide dirAssaultParty/serverSide/main dirAssaultParty/serverSide/objects dirAssaultParty/clientSide dirAssaultParty/clientSide/entities dirAssaultParty/interfaces
cp serverSide/main/SimulPar.class serverSide/main/ServerAssaultParty.class dirAssaultParty/serverSide/main
cp serverSide/objects/AssaultParty.class dirAssaultParty/serverSide/objects
cp interfaces/*.class dirAssaultParty/interfaces
cp clientSide/entities/NormalThiefStates.class clientSide/entities/MasterThiefStates.class dirAssaultParty/clientSide/entities

echo "  Concentration Site"
rm -rf dirConcentrationSite/serverSide/ dirConcentrationSite/interfaces dirConcentrationSite/clientSide dirConcentrationSite/commInfra
mkdir -p dirConcentrationSite/serverSide dirConcentrationSite/serverSide/main dirConcentrationSite/serverSide/objects dirConcentrationSite/clientSide dirConcentrationSite/clientSide/entities dirConcentrationSite/interfaces dirConcentrationSite/commInfra
cp serverSide/main/SimulPar.class serverSide/main/ServerConcentrationSite.class dirConcentrationSite/serverSide/main
cp serverSide/objects/ConcentrationSite.class dirConcentrationSite/serverSide/objects
cp interfaces/*.class dirConcentrationSite/interfaces
cp clientSide/entities/NormalThiefStates.class clientSide/entities/MasterThiefStates.class dirConcentrationSite/clientSide/entities
cp commInfra/*.class dirConcentrationSite/commInfra

echo "  Control and Collection Site"
rm -rf dirControlCollectionSite/serverSide/ dirControlCollectionSite/interfaces dirControlCollectionSite/clientSide dirControlCollectionSite/commInfra
mkdir -p dirControlCollectionSite/serverSide dirControlCollectionSite/serverSide/main dirControlCollectionSite/serverSide/objects dirControlCollectionSite/clientSide dirControlCollectionSite/clientSide/entities dirControlCollectionSite/interfaces dirControlCollectionSite/commInfra
cp serverSide/main/SimulPar.class serverSide/main/ServerControlCollectionSite.class dirControlCollectionSite/serverSide/main
cp serverSide/objects/ControlCollection*.class dirControlCollectionSite/serverSide/objects
cp interfaces/*.class dirControlCollectionSite/interfaces
cp clientSide/entities/NormalThiefStates.class clientSide/entities/MasterThiefStates.class dirControlCollectionSite/clientSide/entities
cp commInfra/*.class dirControlCollectionSite/commInfra

echo "  Museum"
rm -rf dirMuseum/serverSide/ dirMuseum/interfaces dirMuseum/clientSide
mkdir -p dirMuseum/serverSide dirMuseum/serverSide/main dirMuseum/serverSide/objects dirMuseum/clientSide dirMuseum/clientSide/entities dirMuseum/interfaces
cp serverSide/main/SimulPar.class serverSide/main/ServerMuseum.class dirMuseum/serverSide/main
cp serverSide/objects/Museum.class dirMuseum/serverSide/objects
cp interfaces/*.class dirMuseum/interfaces
cp clientSide/entities/NormalThiefStates.class clientSide/entities/MasterThiefStates.class dirMuseum/clientSide/entities

echo "  Normal Thief"
rm -rf dirNormalThief/clientSide dirNormalThief/interfaces dirNormalThief/serverSide
mkdir -p dirNormalThief/clientSide dirNormalThief/clientSide/entities dirNormalThief/clientSide/main dirNormalThief/interfaces dirNormalThief/serverSide dirNormalThief/serverSide/main
cp serverSide/main/SimulPar.class dirNormalThief/serverSide/main
cp clientSide/main/ClientNormalThief.class dirNormalThief/clientSide/main
cp clientSide/entities/NormalThief*.class dirNormalThief/clientSide/entities
cp interfaces/*.class dirNormalThief/interfaces

echo "  Master Thief"
rm -rf dirMasterThief/clientSide dirMasterThief/interfaces
mkdir -p dirMasterThief/clientSide dirMasterThief/clientSide/entities dirMasterThief/clientSide/main dirMasterThief/interfaces
cp clientSide/main/ClientMasterThief.class dirMasterThief/clientSide/main
cp clientSide/entities/MasterThief*.class dirMasterThief/clientSide/entities
cp interfaces/*.class dirMasterThief/interfaces

echo "Compressing execution environments."
echo "  RMI registry"
rm -f  dirRMI.zip
zip -rq dirRMI.zip dirRMI
echo "  Register Remote Objects"
rm -f  dirRegistry.zip
zip -rq dirRegistry.zip dirRegistry
echo "  General Repository of Information"
rm -f dirGeneralRepo.zip
zip -rq dirGeneralRepo.zip dirGeneralRepo
echo "  Assault Party"
rm -f dirAssaultParty.zip
zip -rq dirAssaultParty.zip dirAssaultParty
echo "  Concentration Site"
rm -f dirConcentrationSite.zip
zip -rq dirConcentrationSite.zip dirConcentrationSite
echo "  Control and Collection Site"
rm -f dirControlCollectionSite.zip
zip -rq dirControlCollectionSite.zip dirControlCollectionSite
echo "  Museum"
rm -f dirMuseum.zip
zip -rq dirMuseum.zip dirMuseum
echo "  Normal Thief"
rm -f dirNormalThief.zip
zip -rq dirNormalThief.zip dirNormalThief
echo "  Master Thief"
rm -f dirMasterThief.zip
zip -rq dirMasterThief.zip dirMasterThief
