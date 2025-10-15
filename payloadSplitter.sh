#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

script_name=$(basename "$0")

if [ $# -ne 2 ]; then
    echo -e "${RED}❌ ERROR: Incorrect usage${NC}"
    echo -e "${YELLOW}📋 Usage: $script_name original_payloads_file.txt payloads_per_file${NC}"
    exit 1
fi

original_payloads_file="$1"
payloads_per_file="$2"
directory="payloads"

if [ ! -f "$original_payloads_file" ]; then
    echo -e "${RED}❌ ERROR: File '$original_payloads_file' does not exist${NC}"
    exit 1
fi

mkdir -p "$directory"

total_lines=$(wc -l < "$original_payloads_file")
num_files=$(( (total_lines + payloads_per_file - 1) / payloads_per_file ))

echo -e "${PURPLE}🚀 Starting payload division...${NC}"
echo -e "${CYAN}📊 Total payloads: $total_lines${NC}"
echo -e "${CYAN}📦 Files to create: $num_files${NC}"
echo -e "${CYAN}🎯 Payloads per file: $payloads_per_file${NC}"
echo -e "${YELLOW}⏳ Processing...${NC}"

show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))
    
    printf "\r${BLUE}[${NC}"
    printf "${GREEN}%${completed}s${NC}" | tr ' ' '='
    printf "${BLUE}%${remaining}s${NC}" | tr ' ' ' '
    printf "${BLUE}] ${percentage}%% (%d/%d)${NC}" "$current" "$total"
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

echo -e "\n\n${GREEN}✅ Division completed!${NC}"
echo -e "${GREEN}📁 Files are located in: ${PURPLE}$directory/${NC}"
echo -e "${GREEN}🎯 Each file contains: ${PURPLE}$payloads_per_file payloads${NC}"
