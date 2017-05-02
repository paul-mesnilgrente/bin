commandNum=0
function execute() {
	commandNum=`expr $commandNum + 1`
	# echo "$1"
	command="$1"
	cleanCommand=${command// /_}
	cleanCommand=${cleanCommand//\./_}
	cleanCommand=${cleanCommand//\//_}
	file="$commandNum"_"${cleanCommand:0:25}"
	eval $1 > $file
	ret=$?
	if [ $ret -ne 0 ]; then
		echo ERROR: $command returned $ret
		echo "Do you want to print the corresponding output (y/n)?"
		read y
		if [ "$y" = "y" ]; then
			echo -e "---------------------BEGINNING OF THE FILE---------------------"
			cat $file
			echo -e "------------------------END OF THE FILE------------------------"
		fi
		exit $commandNum
	fi
}
