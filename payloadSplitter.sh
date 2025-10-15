#!/bin/bash

script_name=$(basename "$0")

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
NC='\033[0m'

if [ $# -ne 2 ]; then
    echo -e "${red}❌ ERROR: Incorrect usage${nc}"
    echo -e "${yellow}📋 Usage: $script_name original_payloads_file.txt payloads_per_file${nc}"
    exit 1
fi

original_payloads_file="$1"
payloads_per_file="$2"
directory="payloads"

if [ ! -f "$original_payloads_file" ]; then
    echo -e "${red}❌ ERROR: File '$original_payloads_file' does not exist${nc}"
    exit 1
fi

mkdir -p "$directory"

total_lines=$(wc -l < "$original_payloads_file")
num_files=$(( (total_lines + payloads_per_file - 1) / payloads_per_file ))

echo -e "${purple}🚀 Starting payload division...${nc}"
echo -e "${cyan}📊 Total payloads: $total_lines${nc}"
echo -e "${cyan}📦 Files to create: $num_files${nc}"
echo -e "${cyan}🎯 Payloads per file: $payloads_per_file${nc}"
echo -e "${yellow}⏳ Processing...${nc}"

show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))
    
    printf "\r${blue}[${nc}"
    printf "${green}%${completed}s${nc}" | tr ' ' '='
    printf "${blue}%${remaining}s${nc}" | tr ' ' ' '
    printf "${blue}] ${percentage}%% (%d/%d)${nc}" "$current" "$total"
}

for ((i=1; i<=num_files; i++)); do
    start=$(( (i-1) * payloads_per_file + 1 ))
    end=$(( i * payloads_per_file ))
    
    if [ $end -gt $total_lines ]; then
        end=$total_lines
    fi
    
    output_file="$directory/payloads_$i.txt"
    sed -n "${start},${end}p" "$original_payloads_file" > "$output_file"
    
    show_progress "$i" "$num_files"
    
    sleep 0.1
done

echo -e "\n\n${green}✅ Division completed!${nc}"
echo -e "${green}📁 Files are located in: ${purple}$directory/${nc}"
echo -e "${green}🎯 Each file contains: ${purple}$payloads_per_file payloads${nc}"
