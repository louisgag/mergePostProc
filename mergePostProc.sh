#!/bin/bash
# merging postProcessing time folders from an OpenFOAM solver's output
# currently assuming that the most recent file in a time directory is the only one we want to keep

fileRoot=$1 # obtain shell argument (file name root, example: moment, force, etc...
#firstFolder=$(ls |head -n 1)
for iFolder in $(ls -dt postProcessing/*/);
do
  newFile="$iFolder/mergedTimes/$fileRoot.dat"
  mkdir -p $iFolder/mergedTimes/
  echo "doing $iFolder"
  lastTime=1
  lastTimeFolder=$(ls $iFolder|grep -v mergedTimes|LC_ALL=C sort -rh|head -n 1)
  startTime=$( cat $iFolder/$lastTimeFolder/$fileRoot.dat |grep -v "^#"|head -n 1|awk '{print $1}' )
  for iTime in $(ls $iFolder|grep -v mergedTimes|LC_ALL=C sort -rh)
  do
    if [ $lastTime -eq 1 ];
    then
      cat $iFolder/$iTime/$fileRoot.dat|grep -v "^#" > $newFile
      lastTime=0
    else
      cat  <(cat $iFolder/$iTime/$fileRoot.dat|grep -v "^#"|awk -v startTime=$startTime '{if ($1<startTime) print}') $newFile > $newFile.tmp
      mv $newFile.tmp $newFile
      startTime=$( cat $newFile|grep -v "^#"|head -n 1|awk '{print $1}' )
    fi
  done
  cat <(grep "^#" $iFolder/$iTime/$fileRoot.dat) $newFile > $newFile.tmp
  mv $newFile.tmp $newFile
  echo "done $iFolder"
done
