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

count64=`dpkg -l | grep "amd64" | wc -l`
countAll=`dpkg -l | tail -n +8 | wc -l`
let persent=($count64*100)/$countAll

echo "В системе установлено $persent% 64-разрядных пакетов"
echo ""

echo "Сводка по RAID массивам:"
printf "Массив: " 
nameRAID=`sudo mdadm --detail --scan --verbose | grep "ARRAY" | awk '{print $2}'`
echo $nameRAID

printf "	Версия: "
version=`sudo mdadm --detail --scan --verbose | grep "ARRAY" | awk '{print $5}'`
echo $version | awk -F "=" '{print $2}'

printf "	Тип: " 
type=`sudo mdadm --detail --scan --verbose | grep "ARRAY" | awk '{print $3}'`
echo $type | awk -F "=" '{print $2}'

printf "	Размер: "
size=`sudo mdadm --detail $nameRAID | grep "Array Size :" | awk '{print $7 " " $8}'`
echo $size | awk -F ")" '{print $1}'

echo "	Устройства и статусы: "
countDev=`sudo mdadm --detail $nameRAID | grep "Total Devices : 4" | awk '{print $4}'`
sudo mdadm --detail $nameRAID | tail -n -$countDev | while read line
do
   echo $line | awk -F " " '{print "	   " $5 " " $6 " " $7}'
done





