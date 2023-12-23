bash buildAndGenerate.sh

cd build

echo "Decompressing execution environment files on the deployment directory ..."
mkdir /home/$USER/Heist
rm -rf /home/$USER/Heist/*
cp *.zip /home/$USER/Heist
rm -rf *.zip

cd ../
rm -rf build

cd /home/$USER/Heist
unzip -q dirGeneralRepo.zip
unzip -q dirConcentrationSite.zip
unzip -q dirControlCollectionSite.zip
unzip -q dirMuseum.zip
unzip -q dirAssaultParty.zip
unzip -q dirMasterThief.zip
unzip -q dirNormalThief.zip
rm -rf *.zip