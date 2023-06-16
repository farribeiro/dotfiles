netsh reset winsock
ipconfig /release
ipconfig /renew
arp -d *
nbtstat -R
nbstat -RR
ipconfig /flushdns
ipconfig /registerdns
netsh interface ip delete arpcache
