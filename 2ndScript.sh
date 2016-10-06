#!/bin/bash

if(($# == 0)) #проверка на наличие необходимых параметров
then
   echo Параметр не задан
else
   di=$1 #целевая аудитория
   ext=$2 #расширение файлов
   countFiles=$(expr $RANDOM % 10) #количество генерируемых файлов

   for((i=-1; i<$countFiles; i++))
   do
      #создание файла
      suffix=$(eval date +%s)$RANDOM
      filename="$di/file_$suffix.$ext"
      touch $filename

      countLines=$(expr $RANDOM % 10) #количество строк в файле

      for ((j=-1; j<$countLines; j++))
      do
         let id=$(eval date +%s)/$(expr $RANDOM+1) #id записи
         numbers="" #числа
   
         #генерация чисел
         for((k=-1; k<$(expr $RANDOM % 5); k++))
         do
            numbers="$numbers $(expr $RANDOM % 50)"
         done

         #запись строки в файл
         echo $id"ID" $numbers >> "$filename"
      done

      #вычисление хеша и запись в отдельный файл
      md5sum $filename | awk '{print $1}' >> $filename.md5
   done
fi
