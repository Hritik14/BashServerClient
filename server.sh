#!/bin/bash


echo "Waiting for client..."

until [ -p pipe ] #Won't proceed before the pipe is open
do
	sleep 1
done

echo "Client detected"
read -r response < pipe
if [ "$response" == "SYN" ]; then
	echo "[S] SYN received. Sending ACK"
	echo "ACK" > pipe
else
	echo "[E] Invalid response from client"
	exit
fi

while true
do
	echo "[S] Waiting for data"
	read -r answer < pipe
	echo "[C] $answer"
	case $answer in
		exit|Exit)
			echo "BBye!" | tee pipe
			exit
			;;
		ls)
			tee pipe 1>/dev/null <<EOF
			File 1
			file 2
			file 3
			folder 1
			dir 2
EOF
			;;

		*)
			echo "Invalid" > pipe
	esac
done

