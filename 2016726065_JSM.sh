#!bin/bash


basic_output()
{
a_pwd=`pwd`
b_wc=`ls -l | wc -l `
b_wc=`expr $b_wc - 1`
echo "=== print file information ==="
echo "current directory : $a_pwd "
echo "the number of elements : $b_wc"
}

user_print()
{

if [ $1 = "1" ]
then
	basic_output
fi



file_count=1


#line_count는 ls -l쳤을때 나타나는 파일 줄의 개수
temp=`ls -l |  wc -l `
line_count=`expr $temp - 1 `


file_data=`ls -l --time-style full-iso  | tail -$line_count `

export line_num=1
touch d_lines.txt
touch b_lines.txt
touch p_lines.txt


 
line_count=`expr $line_count + 1 `

while [ "$line_num" != "$line_count" ]
do

current_line_data=`echo "$file_data" | head -"$line_num" | tail -1  `



first_char=`echo "$current_line_data" | cut -b 1`

if [ $first_char = "d" ]
then
        echo "$current_line_data" >> d_lines.txt
elif [ $first_char = "-" ]
then
	echo "$current_line_data" >> b_lines.txt
else
	echo "$current_line_data" >> p_lines.txt
fi

line_num=`expr $line_num + 1 `

done





#printing directory datas
d_num_count=`cat d_lines.txt | wc -l `
i=1


while [ "$i" -le "$d_num_count" ]
do 
file_name=`cat d_lines.txt | head -$i | tail -1 | cut -c 65- | tr -d ' ' `
file_size=`cat d_lines.txt | head -$i | tail -1 | cut -b 23-27 | tr -d ' ' `
file_perm=`stat $file_name | head -4 | tail -1 | cut -b 11-13 `
file_birth=`cat d_lines.txt | head -$i | tail -1 | cut -c 29-57 `
current_dir=`ls -d $PWD/$file_name`
r_path="$file_name"


echo "[$i] $file_name " 
echo "----------------------------INFORMATION-----------------------------"
echo [34m "file type : 디 렉 토 리 "[0m
echo "file size : $file_size "
echo "creation time : $file_birth"
echo "permission : $file_perm "
echo "absolute path : $current_dir "
echo "relative path : ./$r_path "
echo "--------------------------------------------------------------------"



#printing out full directorys files


cd $file_name

count_i=`ls -l | wc -l`
count=`expr $count_i - 1`
 
if [ $count != 0 ]
then
	echo " " | print_filled_dir  
     	
fi


cd ..

i=`expr $i + 1`
done




file_count=`expr $d_num_count + $file_count `


#printing basic datas
b_num_count=`cat b_lines.txt | wc -l `
i=1

while [ "$i" -le "$b_num_count" ]
do
file_name=`cat b_lines.txt | head -$i | tail -1 | cut -c 64- | tr -d ' ' `
file_size=`cat b_lines.txt | head -$i | tail -1 | cut -b 23-27 | tr -d ' ' `
file_perm=`stat $file_name | head -4 | tail -1 | cut -b 11-13 `
file_birth=`cat b_lines.txt | head -$i | tail -1 | cut -c 29-57 `
current_dir=`ls -d $PWD/$file_name`
r_path="$file_name"



if [ "$file_name" != "out.txt" ]
then
echo "[$file_count] $file_name "
echo "-----------------------------INFORMATION-----------------------------"
echo "file type : 일반파일 "
echo "file size : $file_size "
echo "creation time : $file_birth"
echo "permission : $file_perm "
echo "absolute path : $current_dir "
echo "relative path : ./$r_path"
echo "---------------------------------------------------------------------"

file_count=`expr $file_count + 1 `


fi

i=`expr $i + 1`

done


#printing special file datas
p_num_count=`cat p_lines.txt | wc -l `
i=1

while [ "$i" -le "$p_num_count" ]
do
file_name=`cat p_lines.txt | head -$i | tail -1 | cut -c 65- `
file_size=`cat p_lines.txt | head -$i | tail -1 | cut -b 23-27 | tr -d ' ' `
file_perm=`stat $file_name | head -4 | tail -1 | cut -b 11-13 `
file_birth=`cat p_lines.txt | head -$i | tail -1 | cut -c 29-57 `
current_dir=`ls -d $PWD/$file_name`
r_path="$file_name"

echo "[$file_count] $file_name "
echo "----------------------------INFORMATION------------------------------"
echo [32m "file type : FIFO " [0m
echo "file size : $file_size "
echo "creation time : $file_birth"
echo "permission : $file_perm "
echo "absolute path : $current_dir "
echo "relative path : ./$r_path "
echo "---------------------------------------------------------------------"


file_count=`expr $file_count + 1 `
i=`expr $i + 1 ` 

done



rm d_lines.txt
rm b_lines.txt
rm p_lines.txt


}

print_filled_dir()
{
touch out.txt
user_print 0 > out.txt
sed 's/^/	     /' out.txt
rm out.txt
}

user_print 1








