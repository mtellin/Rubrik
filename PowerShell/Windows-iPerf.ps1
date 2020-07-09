# PowerShell script to Download iPerf v2.09, put it in C:\tmp, prompt for Rubrik node to connect to that is running the iperf -s and run the 3 tests and output to a text file.

# Part 1 Download iPerf v2.0.9
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Probably will only use PS script on Windows but use a method to determine OS type to grab the right file?
Invoke-WebRequest -Uri "https://iperf.fr/download/windows/iperf-2.0.9-win64.zip" -OutFile "C:\tmp\iperf-2.0.9-win64.zip"
