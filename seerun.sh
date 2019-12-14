tmpfile="tmp_file"

function show_help ()  
{
	echo "Usage: run -ec <file> 3 4"
	echo "       -e Execute commands. Default is not execute."
	echo "       -c Confirm each command."
	echo "       <file>: is the file you have commands in"
	echo "       3 4: from lines 3 to 4"
	echo "       5: only line 5"
}

function clean_up () 
{
	if [ -f "$tmpfile" ]; then
		rm "$tmpfile"
	fi
}

# set cmd line input variables
# ref: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

check=0
execute=0
while getopts "ceh" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    c)  check=1
        ;;
    e)  execute=1
        ;;
    esac
done

shift $((OPTIND-1))
#echo "check is: $check"

# ensure file exists
file="$1"
if [ -z "$file" ]; then
	echo "No input file given."
	exit 1
fi
if [ ! -f "$file" ]; then
	echo "Given input file does not exist: $file"
	exit 1
fi

start=$2
end=$3

if [ "$start" -gt "$end" ]; then
	echo "Start line cannot be greater than end."
	clean_up
	exit 0
fi

if [ -z $start ]; then
	echo "No lines specified, so listing full file..."
	cat $file
	clean_up
	exit 0
fi

# if end is not mentioned, then it is equal to start
if [ -z $end ]; then
	end=$start
fi

sed -n "$start,$end"p $file > $tmpfile
#echo $lines
#cat $file | sed -n "$start,$end"p
#sed -n "$start,$end"p $file | while read $line || [[ -n $line ]];
line_count=$start
cat "$tmpfile" | while read line || [[ -n $line ]]; do

	if [[ ! $execute == "1" ]]; then
		echo "$line_count $line"
		let "line_count+=1"
		continue
	fi

	#echo $check
	if [[ $check == "0" ]]; then
		echo ""
		echo "-> Running:"
		echo "$line"
		eval "$(echo $line)"
	else
		echo "-> $line"
		echo -n "Run above statemet? (yes is default) "
		read should_run</dev/tty

		if [ "$should_run" = "y" ] || [ "$should_run" = "Y" ] || [ -z "$should_run" ]; then
			echo "-> Running:"
			echo "$line"
			eval "$(echo $line)"
		else
			echo "Exiting"
			clean_up
			exit 0
		fi
	fi

done 

clean_up
exit 0
