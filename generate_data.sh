

echo $1
#Test if argument exist
if [ $# -lt 1 ]
then
echo "argument does not exist"
exit 1

else
echo "At least one argument exists, the first is"
echo $1
fi