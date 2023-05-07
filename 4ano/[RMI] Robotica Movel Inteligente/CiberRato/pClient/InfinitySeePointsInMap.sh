head -n 21 ../simulator/planning.out  > ../simulator/planning2.out
echo "" > myrob.path
watch -n 0.1 ./SeePointsInMap.sh
