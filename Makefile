directory=dir
malicious_directory=malicious_dir
interval=1
.PHONY: prebuild antivirus restore

prebuild:
	mkdir -p $(malicious_directory)

antivirus:prebuild
	./antivirusd.sh $(directory) $(malicious_directory) $(interval)
restore:prebuild
	./restore.sh $(directory) $(malicious_directory)
