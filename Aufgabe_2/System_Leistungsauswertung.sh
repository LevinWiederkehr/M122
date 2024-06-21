#!/bin/bash

print_system_info() {

	uptime=$(uptime -p)
	current_time=$(date '+%Y-%m-%d %H:%M:%S')


	disk_space=$(df -h / | awk 'NR==2 {print $2, $4}')


	hostname=$(hostname)
	ip_address=$(hostname -I)

	os_name=$(uname -s)
	os_version=$(uname -r)


	cpu_model=$(cat /proc/cpuinfo | grep 'model name' | uniq | awk -F': ' '{print $2}')
	cpu_cores=$(cat /proc/cpuinfo | grep '^processor' | wc -l)


	memory_total=$(free -h | awk 'NR==2 {print $2}')
	memory_used=$(free -h | awk 'NR==2 {print $3}')


	printf "| %-25s | %-30s |\n" "Current System Time:" "$current_time"
	printf "| %-25s | %-30s |\n" "System Uptime:" "$uptime"
	printf "| %-25s | %-30s |\n" "Disk Space:" "$disk_space"
	printf "| %-25s | %-30s |\n" "Hostname:" "$hostname"
	printf "| %-25s | %-30s |\n" "IP Adress:" "$ip_address"
	printf "| %-25s | %-30s |\n" "Operating System:" "$os_name $os_version"
	printf "| %-25s | %-30s |\n" "CPU Model:" "$cpu_model"
	printf "| %-25s | %-30s |\n" "CPU Cores:" "$cpu_cores"
	printf "| %-25s | %-30s |\n" "Memory Total:" "$memory_total"
	printf "| %-25s | %-30s |\n" "Memory Used:" "$memory_used"
	printf "+----------------------------+-------------------------------+\n"
}

output_to_file=false
log_file=""

while getopts "f" opt; do
	case $opt in
	f) output_to_file=true ;;
	*) ;;
	esac
done


print_system_info


if [ "$output_to_file" = true ]; then
	log_file="$(date '+%Y-%m')-sys-$(hostname).log"
	print_system_info > "$log_file"
	echo "System performance data logged to $log_file"
fi