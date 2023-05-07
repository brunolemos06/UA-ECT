cd ../simulator

echo "my points:" && awk -f mapping_score.awk planning.out ../pClient/myrob.map
awk -f planning_score.awk planning.out ../pClient/myrob.path > bla && tail --lines 1 bla && rm bla
cat ../pClient/myrob.map

echo "max:" && awk -f mapping_score.awk planning.out planning2.out
head -n 21 planning.out 

#cat ../pClient/myrob.map
