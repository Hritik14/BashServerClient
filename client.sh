#!/bin/bash

cleanup(){
	echo "\nCleaning up"; rm pipe; exit
}

trap 'cleanup' TERM KILL INT

until mkfifo pipe 2>/dev/null; do
	echo "[E] Error with pipe"
	echo -n "Remove pipe ? Y/N: "
	read response
	if [ "$response" == "Y" ]; then
		rm pipe
	fi
done

echo "[C] Sending SYN to server"
echo "SYN"  >  pipe 

read response < pipe
echo "[S] $response"
if [ ! "$response" == "ACK" ]; then 
	echo "[E] Malformed server initial response"
	exit
fi

echo "Connection established!"

while true
do
	echo "Request: "
	read request
	echo $request > pipe
	response=$(<pipe)
	echo "[S] $response"
done

