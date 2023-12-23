#!/bin/bash
cd mission
xterm -T "WATCHER" -hold -e "python3 script_watcher.py 4" &
echo "Running WATCHER"
# station id, station ip, grid size, initial xposition, initial yposition
xterm -fa 'Monospace' -fs 14 -T "BOAT1" -hold -e "python3 script_boat.py 1 192.168.98.110 30 15 2 0" &
echo "Running BOAT1"
xterm -fa 'Monospace' -fs 14 -T "BOAT2" -hold -e "python3 script_boat.py 2 192.168.98.120 30 15 0 2" &
echo "Running BOAT2"
xterm -fa 'Monospace' -fs 14 -T "BOAT3" -hold -e "python3 script_boat.py 3 192.168.98.130 30 15 2 2" &
echo "Running BOAT3"
# 30 grid size, 3 sensors, 1 (generate sensor locations)
xterm -T "BS" -hold -e "python3 script_bs.py 30 15 200 1" &
echo "Running BS"
echo ""
# # start platform
# cd ../nautic
# npm start > /dev/null 2>&1 &
# echo "Running platform"

# # start API 
# cd /home/bruno/Projects/UA-ECT/4ano/RSA/RSA/Project_Files
# python3 api.py > /dev/null 2>&1 &
# echo "Running API"

# wait for user to press enter
read -p "Press enter to close : xterms & platform & API .."
echo "Closing.."
sleep 1
# close all xterm windows
killall xterm
echo "Closed xterms"
# # kil all python3 processes
# killall python3
# echo "Closed python3"

# # kill all node processes
# killall node
# echo "Closed node"

# #close brave
# killall brave