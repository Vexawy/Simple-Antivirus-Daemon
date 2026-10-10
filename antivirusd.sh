#!/usr/bin/env bash

if [[ $# -lt 3 ]]; then
	echo "command error, the command $0 needs at least 3 arguments"
	echo "./antivirusd.sh dir malicious_dir time_in_sec"
	exit 1
fi

if [[ ! -d "$1" || ! -d "$2" || ! "$3" -eq "$3" ]]; then
	echo "invalid path/integer entered, try again!"
	exit 1
fi

dir=$1
malicious_dir=$2
interval=$3

file1="directory-info.last"
file2="directory-info.new"
scan_for_malicious()
{
	for file in "$dir"/*; do
		malicious=false
		if grep -q "$(basename "$file")" .whitelist.list; then
    			continue
		fi
		if [[ "$file" == *.exe || "$file" == *.bat || "$file" == *.vbs || "$file" == *.scr || "$file" == *.ps1 ]]; then
			malicious=true
		elif grep -qiE 'virus|trojan|malware|worm|ransomware' "$file"; then
			malicious=true
		fi
		if [[ "$malicious" == true ]]; then
			echo "$file is malicious and it is DELETED"
			cp "$file" "$malicious_dir"
			rm "$file"
		fi
	done
}

if [[ ! -f "$file1" ]]; then
	scan_for_malicious
	ls -l "$dir" > "$file1"
fi

while true; do
    ls -l "$dir" > "$file2"
    if ! cmp -s "$file1" "$file2"; then
	echo ""
        scan_for_malicious
        cp "$file2" "$file1"
    fi
    sleep "$interval"
done
