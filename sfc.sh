#!/bin/bash

fmissed=./missed.list
fpackets=./packets.list

make_missed_files_list() {
    echo -n'' > $1
    dpkg -V | cut -d' ' -f4 >> $1
}

get_packet_by_filename() {
    dpkg -S "$1" | cut -d':' -f1
}

make_packets_list() {
    echo -n '' > $2
    for fname in $(cat "$1"); do 
	get_packet_by_filename "$fname" >> $2
    done
}

reinstall_packets() {
    for pkg in $(cat "$1"); do
        apt-get install --reinstall -y ${pkg}
    done
}

make_missed_files_list $fmissed
make_packets_list $fmissed "$fpackets".tmp
awk '!seen[$0]++' "$fpackets".tmp > "$fpackets"
rm "$fpackets".tmp
reinstall_packets "$fpackets"
