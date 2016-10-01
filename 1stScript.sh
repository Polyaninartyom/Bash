#!/bin/bash

if(($# != 4))
then
   echo Необходимо 4 параметра
else
   directory=$1
   ext=$2
   di=$3
   logfile=$4

   echo `date "+%Y.%m.%d %H:%M:%S"` "Начало работы" >> $logfile 
   echo `date "+%Y.%m.%d %H:%M:%S"` "Исходная директория: $1" >> $logfile
   echo `date "+%Y.%m.%d %H:%M:%S"` "Расширения файлов: $2" >> $logfile
   echo `date "+%Y.%m.%d %H:%M:%S"` "Целевая директория $3" >> $logfile

   resultFile="$di/summar"`date "+%Y%m%d%H%M%S"`
   touch "$resultFile"

   find $directory -name '*.'$ext | while read F
   do
      oldhashmd5=`cat $F.md5`
      newhashmd5=`md5sum $F | awk '{print $1}'`

      if [ "$oldhashmd5" == "$newhashmd5" ]
      then
         cat $F | while read line
         do
            IFS=' ' read -r -a array <<< "$line"
            id="${array[0]}"
            s=0

            for ((i=1; i<"${#array[@]}"; i++))
            do
               let s=s+${array[$i]}
            done

            echo $id $s >> "$resultFile"
         done
      else
         echo `date "+%Y.%m.%d %H:%M:%S"` "Для файла $F хеш не сходится" >> $logfile
      fi
   done

   echo `date "+%Y.%m.%d %H:%M:%S"` "Конец работы" >> $logfile
fi
