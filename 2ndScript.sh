#!/bin/bash

if(($# == 0))
then
   echo Параметр не задан
else
   di=$1
   countFiles=$(expr $RANDOM % 10)

   for((i=-1; i<$countFiles; i++))
   do
      suffix=$(eval date +%s)$RANDOM
      filename="$di/file_$suffix.AAA"
      touch $filename

      countLines=$(expr $RANDOM % 10)

      for ((j=-1; j<$countLines; j++))
      do
         let id=$(eval date +%s)/$(expr $RANDOM+1)
         numbers=""
   
         for((k=-1; k<$(expr $RANDOM % 5); k++))
         do
            numbers="$numbers $(expr $RANDOM % 50)"
         done

         echo $id"ID" $numbers >> "$filename"
      done

      #hash-sum
      md5sum $filename | awk '{print $1}' >> $filename.md5
   done
fi
