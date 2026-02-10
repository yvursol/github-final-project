#!/bin/bash

# Simple Interest Calculator
# Author: [Your Name]
# Date: $(date +%Y-%m-%d)
# Version: 1.0
#
# Calculates simple interest using formula:
# Interest = (Principal * Rate * Time) / 100

set -e  # Exit on error

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to validate numeric input
validate_number() {
    local input=$1
    local field_name=$2
    
    # Check if input is a positive number (integer or float)
    if ! [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "${RED}✗ Error: '$field_name' must be a number${NC}"
        return 1
    fi
    
    # Check if greater than zero
    if (( $(echo "$input <= 0" | bc -l 2>/dev/null) )); then
        echo -e "${RED}✗ Error: '$field_name' must be greater than zero${NC}"
        return 1
    fi
    
    return 0
}

# Function to calculate simple interest
calculate_interest() {
    local p=$1
    local r=$2
    local t=$3
    
    # The actual calculation
    local interest=$(echo "scale=2; $p * $r * $t / 100" | bc -l)
    echo "$interest"
}

# Clear screen and show header
clear
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════╗"
echo "║    SIMPLE INTEREST CALCULATOR v1.0       ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo "This script calculates simple interest using"
echo "the formula: I = P × R × T / 100"
echo ""

# Get principal amount
while true; do
    read -p "💰 Enter principal amount: $" principal
    if validate_number "$principal" "Principal"; then
        break
    fi
done

# Get interest rate
while true; do
    read -p "📈 Enter annual interest rate (%): " rate
    if validate_number "$rate" "Interest rate"; then
        break
    fi
done

# Get time period
while true; do
    read -p "⏰ Enter time period (years): " time
    if validate_number "$time" "Time period"; then
        break
    fi
done

echo ""
echo -e "${YELLOW}Calculating...${NC}"
sleep 1  # Small delay for realism

# Perform calculations
interest=$(calculate_interest "$principal" "$rate" "$time")
total=$(echo "scale=2; $principal + $interest" | bc -l)

# Display results
echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}           💰 CALCULATION RESULTS 💰        ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""

# Format output with proper alignment
printf "%-25s: $%.2f\n" "Principal" "$principal"
printf "%-25s: %.2f%%\n" "Annual Interest Rate" "$rate"
printf "%-25s: %.2f years\n" "Time Period" "$time"
echo "------------------------------------------"
printf "%-25s: ${GREEN}$%.2f${NC}\n" "Simple Interest" "$interest"
printf "%-25s: ${GREEN}$%.2f${NC}\n" "Total Amount" "$total"

echo ""
echo -e "${YELLOW}══════════════════════════════════════════${NC}"
echo -e "${YELLOW}Formula used: I = P × R × T / 100${NC}"
echo -e "${YELLOW}Where:${NC}"
echo -e "${YELLOW}  P = Principal (\$$principal)${NC}"
echo -e "${YELLOW}  R = Rate ($rate%)${NC}"
echo -e "${YELLOW}  T = Time ($time years)${NC}"
echo -e "${YELLOW}══════════════════════════════════════════${NC}"

# Offer to save results
echo ""
read -p "📄 Save results to file? (y/n): " save_choice
if [[ "$save_choice" =~ ^[Yy]$ ]]; then
    timestamp=$(date +"%Y%m%d_%H%M%S")
    filename="interest_calculation_${timestamp}.txt"
    
    cat > "$filename" << EOF
SIMPLE INTEREST CALCULATION
===========================
Date: $(date)
Principal: \$$principal
Interest Rate: $rate%
Time Period: $time years
---------------------------
Simple Interest: \$$interest
Total Amount: \$$total
===========================
EOF
    
    echo -e "${GREEN}✓ Results saved to: $filename${NC}"
fi

echo ""
echo -e "${GREEN}✅ Calculation complete!${NC}"
echo "Thank you for using Simple Interest Calculator!"
