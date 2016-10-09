#!/bin/bash

if(($# != 4)) #проверка на наличие необходимых параметров
then
   echo Необходимо 4 параметра
else
   directory=$1 #директория поиска
   ext=$2       #расширенин искомых файлов
   di=$3        #целевая директория
   logfile=$4   #имя лог-файла

   #записи в логе
   echo `date "+%Y.%m.%d %H:%M:%S"` "Начало работы" >> $logfile 
   echo `date "+%Y.%m.%d %H:%M:%S"` "Исходная директория: $1" >> $logfile
   echo `date "+%Y.%m.%d %H:%M:%S"` "Расширения файлов: $2" >> $logfile
   echo `date "+%Y.%m.%d %H:%M:%S"` "Целевая директория $3" >> $logfile

   resultFile="$di/summar"`date "+%Y%m%d%H%M%S"` #имя выходного файла 
   touch "$resultFile" #создание выходного файла

   #поиск файлов в директории с указанным расширений
   find $directory -name '*.'$ext | while read F
   do
      oldhashmd5=`cat $F.md5` #считывание старого хеша из файла
      newhashmd5=`md5sum $F | awk '{print $1}'` #получение хеша текущего файла

      #проверка хешов
      if [ "$oldhashmd5" == "$newhashmd5" ]
      then
         #построчно ситаем файл
         cat $F | while read line
         do
            #деление строки на слова
            IFS=' ' read -r -a array <<< "$line"
            id="${array[0]}" #id записи
            s=0 #сумма чисел

            #подсчет суммы числе
            for ((i=1; i<"${#array[@]}"; i++))
            do
               let s=s+${array[$i]}
            done

            echo $id $s >> "$resultFile" #запись результата в выходной файл            
         done

         #удаление файлов
         rm -r $F.md5
         rm -r $F
      else
         echo `date "+%Y.%m.%d %H:%M:%S"` "Для файла $F хеш не сходится" >> $logfile
      fi
   done

   echo `date "+%Y.%m.%d %H:%M:%S"` "Конец работы" >> $logfile
fi
