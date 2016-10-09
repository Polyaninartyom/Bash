#!/bin/bash

echo Имя хоста: `hostname`

printf "Процессор: "
lscpu | grep "Model name:" | awk '{print $3 " " $4 " " $5}'

printf "Частота процессора: " 
lscpu | grep "CPU МГц:" | awk '{print $3 "МГц"}'

printf "Общий объем ОЗУ: " 
free | grep "Память:" | awk '{print $2}'

echo ""

#Счётчик процессов
i=0

#список процессов со столбцами PID, CPU, MEM, PRI, NI, COMMAND 
#c сортировкой по CPU и MEM
ps -axo pid,%cpu,%mem,pri,ni,command --sort=-%cpu,-%mem | while read line
do
   #нулевая строка - заголовок, его пропускаем
   if (($i!=0))
   then
      printf "Процесс PID: "
      echo $line | grep " " | awk '{print $1}'

      printf "CPU: "
      echo $line | grep " " | awk '{print $2}'
      
      printf "MEM: "
      echo $line | grep " " | awk '{print $3}'

      printf "Приоритет: "
      echo $line | grep " " | awk '{print $4}'

      printf "Уровень прав: "
      echo $line | grep " " | awk '{print $5}'

      printf "COMMAND: "
      echo $line | grep " " | awk '{print $6}'
     
      echo "------------------------------"
   fi

   #увеличиваем значение счётчика
   let i=i+1
   
   #если вывели 10 процессов, то выходим из цикла
   if (($i==11)) 
   then
      break
   fi
done
