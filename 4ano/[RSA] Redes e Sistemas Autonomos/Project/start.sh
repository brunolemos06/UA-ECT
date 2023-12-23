#!/bin/bash

# start API
cd api
xterm -T "API" -hold -e "python3 api.py " &
sleep 4


# start platform
cd ../platform
xterm -T "NPM" -hold -e  'npm start' &
sleep 4


cd ../mission
xterm -T "WATCHER" -hold -e "python3 script_watcher.py 5" &
echo "Running WATCHER"
xterm -T "SENSOR BROKER" -hold -e "python3 script_sensors.py 192.168.98.1" &
echo "Running SENSOR BROKER"
# station id, station ip, grid size, initial xposition, initial yposition
xterm -fa 'Monospace' -fs 14 -T "BOAT1" -hold -e "python3 script_boat.py 1 192.168.98.110 30 15 2 0" &
echo "Running BOAT1"
xterm -fa 'Monospace' -fs 14 -T "BOAT2" -hold -e "python3 script_boat.py 2 192.168.98.120 30 15 4 0" &
echo "Running BOAT2"
xterm -fa 'Monospace' -fs 14 -T "BOAT3" -hold -e "python3 script_boat.py 3 192.168.98.130 30 15 2 2" &
echo "Running BOAT3"
# 30 grid size, 3 sensors, 1 (generate sensor locations)
xterm -T "BS" -hold -e "python3 script_bs.py 30 15 8 1" &
echo "Running BS"
echo ""

read -p "Press enter to close : xterms & platform & API .."
echo "Closing.."
sleep 1
# close all xterm windows
killall xterm
echo "Closed xterms"

# close platform
killall node
echo "Closed platform"

# close API
killall python3
echo "Closed API"
