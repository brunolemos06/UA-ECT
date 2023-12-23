echo "Compiling the project."
mkdir compiled
rm -rf build
rm -rf /home/$USER/Heist
javac -source 1.8 -target 1.8 -d compiled commInfra/*.java clientSide/*/*.java serverSide/*/*.java

echo "Distributing intermediate code to the different execution environments."


echo "  General Repository of Information"

mkdir -p build/dirGeneralRepo build/dirGeneralRepo/serverSide build/dirGeneralRepo/serverSide/main build/dirGeneralRepo/serverSide/entities build/dirGeneralRepo/serverSide/sharedRegions \
            build/dirGeneralRepo/clientSide build/dirGeneralRepo/clientSide/entities build/dirGeneralRepo/commInfra

cp compiled/serverSide/main/ServerGeneralRepo.class compiled/serverSide/main/SimulPar.class build/dirGeneralRepo/serverSide/main
cp compiled/serverSide/entities/GeneralReposClientProxy.class build/dirGeneralRepo/serverSide/entities
cp compiled/serverSide/sharedRegions/GeneralRepo.class compiled/serverSide/sharedRegions/GeneralRepoInterface.class build/dirGeneralRepo/serverSide/sharedRegions
cp compiled/clientSide/entities/NormalThiefStates.class compiled/clientSide/entities/MasterThiefStates.class build/dirGeneralRepo/clientSide/entities
cp compiled/clientSide/entities/NormalThief.class compiled/clientSide/entities/MasterThiefStates.class build/dirGeneralRepo/clientSide/entities
cp compiled/commInfra/Message.class compiled/commInfra/MessageType.class compiled/commInfra/MessageException.class compiled/commInfra/ServerCom.class build/dirGeneralRepo/commInfra


echo "  Concentration Site"

mkdir -p build/dirConcentrationSite build/dirConcentrationSite/serverSide build/dirConcentrationSite/serverSide/main build/dirConcentrationSite/serverSide/entities build/dirConcentrationSite/serverSide/sharedRegions \
            build/dirConcentrationSite/clientSide build/dirConcentrationSite/clientSide/entities build/dirConcentrationSite/clientSide/stub build/dirConcentrationSite/commInfra    

cp compiled/serverSide/main/ServerConcentrationSite.class compiled/serverSide/main/SimulPar.class build/dirConcentrationSite/serverSide/main
cp compiled/serverSide/entities/ConcentrationSiteClientProxy.class build/dirConcentrationSite/serverSide/entities
cp compiled/serverSide/sharedRegions/ConcentrationSite.class compiled/serverSide/sharedRegions/ConcentrationSiteInterface.class build/dirConcentrationSite/serverSide/sharedRegions
cp compiled/clientSide/entities/NormalThief*.class compiled/clientSide/entities/MasterThiefStates.class compiled/clientSide/entities/MasterThiefClone.class build/dirConcentrationSite/clientSide/entities
cp compiled/clientSide/stub/*.class build/dirConcentrationSite/clientSide/stub
cp compiled/commInfra/*.class build/dirConcentrationSite/commInfra


echo "  Control and Collection Site"

mkdir -p build/dirControlCollectionSite build/dirControlCollectionSite/serverSide build/dirControlCollectionSite/serverSide/main build/dirControlCollectionSite/serverSide/entities build/dirControlCollectionSite/serverSide/sharedRegions \
            build/dirControlCollectionSite/clientSide build/dirControlCollectionSite/clientSide/entities build/dirControlCollectionSite/clientSide/stub build/dirControlCollectionSite/commInfra

cp compiled/serverSide/main/ServerControlCollectionSite.class compiled/serverSide/main/SimulPar.class build/dirControlCollectionSite/serverSide/main
cp compiled/serverSide/entities/ControlCollectionSiteClientProxy.class build/dirControlCollectionSite/serverSide/entities
cp compiled/serverSide/sharedRegions/ControlCollection*.class  build/dirControlCollectionSite/serverSide/sharedRegions
cp compiled/clientSide/entities/NormalThiefStates.class compiled/clientSide/entities/NormalThiefClone.class compiled/clientSide/entities/MasterThiefStates.class compiled/clientSide/entities/MasterThiefClone.class build/dirControlCollectionSite/clientSide/entities
cp compiled/clientSide/stub/*.class build/dirControlCollectionSite/clientSide/stub
cp compiled/commInfra/*.class build/dirControlCollectionSite/commInfra


echo "  Museum"

mkdir -p build/dirMuseum build/dirMuseum/serverSide build/dirMuseum/serverSide/main build/dirMuseum/serverSide/entities build/dirMuseum/serverSide/sharedRegions \
            build/dirMuseum/clientSide build/dirMuseum/clientSide/entities build/dirMuseum/clientSide/stub build/dirMuseum/commInfra

cp compiled/serverSide/main/ServerMuseum.class compiled/serverSide/main/SimulPar.class build/dirMuseum/serverSide/main
cp compiled/serverSide/entities/MuseumClientProxy.class build/dirMuseum/serverSide/entities
cp compiled/serverSide/sharedRegions/Museum.class compiled/serverSide/sharedRegions/MuseumInterface.class build/dirMuseum/serverSide/sharedRegions
cp compiled/clientSide/entities/NormalThiefStates.class compiled/clientSide/entities/NormalThiefClone.class compiled/clientSide/entities/MasterThiefStates.class compiled/clientSide/entities/MasterThiefClone.class build/dirMuseum/clientSide/entities
cp compiled/clientSide/stub/*.class build/dirMuseum/clientSide/stub
cp compiled/commInfra/*.class build/dirMuseum/commInfra


echo "  Assault Party"

mkdir -p build/dirAssaultParty build/dirAssaultParty/serverSide build/dirAssaultParty/serverSide/main build/dirAssaultParty/serverSide/entities build/dirAssaultParty/serverSide/sharedRegions \
            build/dirAssaultParty/clientSide build/dirAssaultParty/clientSide/entities build/dirAssaultParty/clientSide/stub build/dirAssaultParty/commInfra

cp compiled/serverSide/main/ServerAssaultParty.class compiled/serverSide/main/SimulPar.class build/dirAssaultParty/serverSide/main
cp compiled/serverSide/entities/AssaultPartyClientProxy.class build/dirAssaultParty/serverSide/entities
cp compiled/serverSide/sharedRegions/AssaultParty.class compiled/serverSide/sharedRegions/AssaultPartyInterface.class build/dirAssaultParty/serverSide/sharedRegions
cp compiled/clientSide/entities/NormalThief*.class compiled/clientSide/entities/MasterThiefStates.class compiled/clientSide/entities/MasterThiefClone.class build/dirAssaultParty/clientSide/entities
cp compiled/clientSide/stub/*.class build/dirAssaultParty/clientSide/stub
cp compiled/commInfra/*.class build/dirAssaultParty/commInfra


echo "  Master Thief"

mkdir -p build/dirMasterThief build/dirMasterThief/serverSide build/dirMasterThief/serverSide/main build/dirMasterThief/clientSide \
            build/dirMasterThief/clientSide/main build/dirMasterThief/clientSide/entities build/dirMasterThief/clientSide/stub build/dirMasterThief/commInfra

cp compiled/serverSide/main/SimulPar.class build/dirMasterThief/serverSide/main
cp compiled/clientSide/main/ClientMasterThief.class build/dirMasterThief/clientSide/main
cp compiled/clientSide/entities/MasterThief.class compiled/clientSide/entities/MasterThiefStates.class build/dirMasterThief/clientSide/entities
cp compiled/clientSide/stub/*.class build/dirMasterThief/clientSide/stub
cp compiled/commInfra/Message.class compiled/commInfra/MessageType.class compiled/commInfra/MessageException.class compiled/commInfra/ClientCom.class build/dirMasterThief/commInfra


echo "  Normal Thieves"

mkdir -p build/dirNormalThief build/dirNormalThief/serverSide build/dirNormalThief/serverSide/main build/dirNormalThief/clientSide \
            build/dirNormalThief/clientSide/main build/dirNormalThief/clientSide/entities build/dirNormalThief/clientSide/stub build/dirNormalThief/commInfra

cp compiled/serverSide/main/SimulPar.class build/dirNormalThief/serverSide/main
cp compiled/clientSide/main/ClientNormalThief.class build/dirNormalThief/clientSide/main
cp compiled/clientSide/entities/NormalThief.class compiled/clientSide/entities/NormalThiefStates.class build/dirNormalThief/clientSide/entities
cp compiled/clientSide/stub/*.class build/dirNormalThief/clientSide/stub
cp compiled/commInfra/Message.class compiled/commInfra/MessageType.class compiled/commInfra/MessageException.class compiled/commInfra/ClientCom.class build/dirNormalThief/commInfra

rm -rf compiled

echo "Compresing execution environment files ..."

cd build

echo "  General Repository of Information"
rm -rf dirGeneralRepo.zip
zip -rq dirGeneralRepo.zip dirGeneralRepo

echo "  Concentration Site"
rm -rf dirConcentrationSite.zip
zip -rq dirConcentrationSite.zip dirConcentrationSite

echo "  Control Collection Site"
rm -rf dirControlCollectionSite.zip
zip -rq dirControlCollectionSite.zip dirControlCollectionSite

echo "  Museum"
rm -rf dirMuseum.zip
zip -rq dirMuseum.zip dirMuseum

echo "  Assault Party"
rm -rf dirAssaultParty.zip
zip -rq dirAssaultParty.zip dirAssaultParty

echo "  Master Thief"
rm -rf dirMasterThief.zip
zip -rq dirMasterThief.zip dirMasterThief

echo "  Normal Thieves"
rm -rf dirNormalThief.zip
zip -rq dirNormalThief.zip dirNormalThief