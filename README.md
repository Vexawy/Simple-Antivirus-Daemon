## Simple antivirus script using bash and Makefile

### Overview:

#### 1. Hierarchy of the project

#### 2. Content of each file/directory

#### 3. Bonus: Whitelist

#### 4. Any prequisties for the project and how to install on Ubuntu

#### 5. Step by step instructions for running the antivirus and restore tools

#### 6. Where in the code the required flagged-extensions and flagged-keywords lists are defined

---

## 1.

The project folder hierarchy is as following:

```
|---> dir/
|
|---> antivirusd.sh
|
|---> restore.sh
|
|---> malicious_dir/ (it's crated by default when running makefile)
|
|---> Makefile
|
|---> README.md
|
|---> .whitelist.list (created if the user restored a file from malicious_dir/)
```

---

## 2.

dir/ is the targeted directory to check whether a virus or threat<br>exist or not

antivirusd.sh contains basic bash code to check flagged extensions and flagged keywords in the dir/ and move them to malicious_dir/ 

restore.sh contains basic bash code to make user select an quarantined file and user can choose between removing, restoring to dir/ or simply back to the menu of files and if the malicious_dir is empty the script finishes his work

malicious_dir/ is that directory which threatens moved to then you have the choice for deleting or moving them

Makefile used to simply run commands for scripts

README.md is this file where I explain the project

.whitelist.list is created to store filenames that are false positive

---

## 3.

The whitelist stores the names of files that identified as false positive and restored by the user<br>
when running the antivirus it will skip files during future scans

I made the whitelist file as hidden to avoid the user change it only manually

to test it you need to run the antivirus and add a malicious file inside dir<br>
when the file is quarantined run restore.sh and choose option 1 to restore it<br>
you can verify that the filename was added to **.whitelist.list**
run the antivirus again and verify that the whitelisted file is not quarantined again

---

## 4.

The code needs only to have installed Makefile runner and bash before running<br>
so use:

`sudo apt install make`

---

## 5.

To run scripts you need to verify that you have dir/ exist:

then 

`make antivirus` <br>to run the antivirus script

`make restore` <br>to run the restore script

---

## 6.

I used function definition for scanning malicious files

and I call it twice

first when you want to scan for the first time

second when there's a change happened to the dir/

```
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
```

### Notice for using:

**grep -qiE**

-q ---> for silent output and avoid showing output in the screen<br>
-i ---> for ignoring case sensetive searching<br>
-E ---> to seperate multi target expressions with pipes<br>

**basename "$file"**

basename gets the file name not the path of the file

---