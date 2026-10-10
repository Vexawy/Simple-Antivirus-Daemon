#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
	echo "command error, the command $0 needs at least 2 arguments"
	echo "./restore.sh dir malicious_dir"
	exit 1
fi

if [[ ! -d "$1" || ! -d "$2" ]]; then
        echo "invalid path entered, try again!"
        exit 1
fi

dir=$1
malicious_dir=$2
while true; do
	malicious_content=$(ls -l "$malicious_dir"| awk '{print $9}')
	if [[ -z "$malicious_content" ]]; then
		echo "No malicious files to review."
		exit 0
	fi
	echo "files in malicious_dir:"
	counter=1
        for file in $malicious_content; do
                echo "$counter $file"
                counter=$((counter+1))
        done
	echo "pick one file by number starts from 1"
	read index
	counter=1
	for file in $malicious_content; do
    		if [[ "$counter" -eq "$index" ]]; then
        		file_choosed_by_user=$file
        		break
    		fi
    		counter=$((counter+1))
	done 
	echo "You have three options:"
	echo "Input 1: Restore this file back into dir(it was false positive)"
	echo "Input 2: Permanently delete this file from malicious_dir (it was genuinely malicious)"
	echo "Input 3: Leave this file as is and go back to the list"
	echo "enter from (1 to 3):"
	read choice
	if [[ "$choice" -eq 1 ]]; then
		mv "$malicious_dir/$file_choosed_by_user" "$dir/"
		echo "$file_choosed_by_user" >> .whitelist.list
		echo "Restored $file_choosed_by_user to $dir."
	elif [[ "$choice" -eq 2 ]]; then
		rm -f "$malicious_dir/$file_choosed_by_user"
		echo "$file_choosed_by_user permanently deleted."
	elif [[ "$choice" -eq 3 ]]; then
		continue
	else
		echo "invalid choice"
	fi
done
