#!/bin/bash

# Bright Colors
R='\033[1;91m'  # Bright Red
G='\033[1;92m'  # Bright Green
Y='\033[1;93m'  # Bright Yellow
B='\033[1;94m'  # Bright Blue
P='\033[1;95m'  # Bright Pink/Purple
C='\033[1;96m'  # Bright Cyan
W='\033[1;97m'  # Bright White
M='\033[1;35m'  # Magenta
L='\033[1;36m'  # Light Blue
O='\033[1;33m'  # Orange
N='\033[0m'     # Reset

# Clear screen
clear

# Function for top border - Pink
top_border() {
    echo -e "${P}╭────────────────────────────────────────────────╮${N}"
}

# Function for bottom border - Pink
bottom_border() {
    echo -e "${P}╰────────────────────────────────────────────────╯${N}"
}

# Function for box - Purple
box() {
    echo -e "${M}┌────────────────────────────────────────────────┐${N}"
}

# Function for box end - Purple
box_end() {
    echo -e "${M}└────────────────────────────────────────────────┘${N}"
}

# Function for separator - Yellow
separator() {
    echo -e "${Y}────────────────────────────────────────────────${N}"
}

# Function to center text with colors
center() {
    local text="$1"
    local color="$2"
    local width=48
    local padding=$(( (width - ${#text}) / 2 ))
    printf "${color}%*s%s%*s${N}\n" $padding "" "$text" $padding ""
}

# Show banner with multiple colors
echo -e "${C}"
echo "╔══════════════════════════════════════════════╗"
echo -e "${C}║${N}                                              ${C}║${N}"
center "★ PASSWORD CRACKER TOOL ★" "${P}"
echo -e "${C}║${N}                                              ${C}║${N}"
echo -e "${C}╠══════════════════════════════════════════════╣${N}"
echo -e "${C}║${N}                                              ${C}║${N}"
center "By Repair-A2Z" "${Y}"
echo -e "${C}║${N}                                              ${C}║${N}"
echo -e "${C}╚══════════════════════════════════════════════╝${N}"
echo -e "${N}"

# Function to show main menu
show_menu() {
    echo ""
    top_border
    center "MAIN LAUNCHER MENU" "${G}"
    bottom_border
    echo ""
    
    box
    echo -e "${M}│${N} ${G}1.${N} ${C}Install Requirements & Launch Tool${N}       ${M}│${N}"
    echo -e "${M}│${N} ${G}2.${N} ${L}Launch Tool Directly${N}                     ${M}│${N}"
    echo -e "${M}│${N} ${G}3.${N} ${Y}About Developer${N}                          ${M}│${N}"
    echo -e "${M}│${N} ${G}4.${N} ${R}Exit${N}                                     ${M}│${N}"
    box_end
    echo ""
    separator
}

# Function to show version selection
select_version() {
    echo ""
    top_border
    center "SELECT TOOL VERSION" "${C}"
    bottom_border
    echo ""
    
    box
    echo -e "${M}│${N} ${G}1.${N} ${C}Classic Edition${N}        (tool_main.sh)     ${M}│${N}"
    echo -e "${M}│${N} ${G}2.${N} ${P}Advanced Edition${N}       (tool-main.sh)     ${M}│${N}"
    echo -e "${M}│${N} ${G}3.${N} ${M}Ultimate Edition${N}       (tool+main.sh)     ${M}│${N}"
    echo -e "${M}│${N} ${G}4.${N} ${R}Back to Main Menu${N}                         ${M}│${N}"
    box_end
    echo ""
    separator
}

# Function to launch tool with permission
launch_tool() {
    local tool_file="$1"
    local tool_name="$2"
    
    show_header "LAUNCHING $tool_name"
    
    echo -e "${L}[*]${N} ${W}Starting Password Cracker Tool...${N}"
    echo ""
    
    if [ -f "$tool_file" ]; then
        echo -e "${Y}[~]${N} ${O}Setting execute permission...${N}"
        chmod +x "$tool_file"
        echo -e "${G}[✓]${N} ${C}Permission granted${N}"
        echo ""
        echo -e "${G}[→]${N} ${C}Launching $tool_name...${N}"
        sleep 1
        ./"$tool_file"
    else
        echo -e "${R}[!]${N} ${R}Error: $tool_file not found!${N}"
        echo -e "${Y}[*]${N} ${Y}Please make sure the file exists in current directory${N}"
        echo ""
        read -p "$(echo -e "${C}[?]${N} ${W}Press Enter to continue...${N}")" dummy
    fi
}

# Function to show header with Cyan
show_header() {
    local title="$1"
    echo ""
    top_border
    center "$title" "${C}"
    bottom_border
    echo ""
}

# Function to check requirements with different colors
check_requirements() {
    show_header "CHECKING REQUIREMENTS"
    
    echo -e "${Y}[*]${N} ${W}Checking system requirements...${N}"
    echo ""
    
    local missing=0
    
    # Check Python3 - Green
    if command -v python3 &> /dev/null; then
        echo -e "${G}[✓]${N} ${C}Python3 is installed${N}"
    else
        echo -e "${R}[✗]${N} ${R}Python3 is not installed${N}"
        missing=1
    fi
    
    # Check pip3 - Blue
    if command -v pip3 &> /dev/null; then
        echo -e "${G}[✓]${N} ${B}pip3 is installed${N}"
    else
        echo -e "${R}[✗]${N} ${R}pip3 is not installed${N}"
        missing=1
    fi
    
    # Check Termux - Pink
    if [ -d "/data/data/com.termux" ]; then
        echo -e "${G}[✓]${N} ${P}Running in Termux${N}"
    else
        echo -e "${Y}[!]${N} ${O}Running outside Termux${N}"
    fi
    
    echo ""
    return $missing
}

# Function to install requirements
install_requirements() {
    show_header "INSTALLING REQUIREMENTS"
    
    echo -e "${P}[*]${N} ${W}Installing required packages...${N}"
    echo ""
    
    # Update package list - Yellow
    echo -e "${Y}[~]${N} ${O}Updating package list...${N}"
    apt update -y > /dev/null 2>&1
    
    # Install Python3 if missing - Cyan
    if ! command -v python3 &> /dev/null; then
        echo -e "${C}[~]${N} ${L}Installing Python3...${N}"
        apt install python3 -y > /dev/null 2>&1
        echo -e "${G}[✓]${N} ${G}Python3 installed${N}"
    fi
    
    # Install pip3 if missing - Blue
    if ! command -v pip3 &> /dev/null; then
        echo -e "${B}[~]${N} ${B}Installing pip3...${N}"
        apt install python3-pip -y > /dev/null 2>&1
        echo -e "${G}[✓]${N} ${B}pip3 installed${N}"
    fi
    
    # Install pyzipper - Purple
    echo -e "${M}[~]${N} ${P}Installing pyzipper...${N}"
    pip3 install pyzipper > /dev/null 2>&1
    echo -e "${G}[✓]${N} ${M}pyzipper installed${N}"
    
    echo ""
    echo -e "${G}[✓]${N} ${C}All requirements installed successfully!${N}"
}

# Function to show about with rainbow colors
show_about() {
    clear
    echo -e "${C}"
    echo "╔══════════════════════════════════════════════╗"
    echo -e "${C}║${N}                                              ${C}║${N}"
    center "★ ABOUT DEVELOPER ★" "${P}"
    echo -e "${C}║${N}                                              ${C}║${N}"
    echo -e "${C}╠══════════════════════════════════════════════╣${N}"
    echo -e "${C}║${N}                                              ${C}║${N}"
    echo -e "${N}"
    
    echo -e "${G}          Developer: ${P}Repair-A2Z${N}"
    echo ""
    echo -e "${Y}▸${N} ${C}Tool:${N} ${L}Password Cracker Multi-Tool${N}"
    echo -e "${B}▸${N} ${C}Version:${N} ${G}2.0.0${N}"
    echo -e "${P}▸${N} ${C}Editions:${N} ${Y}Classic | Advanced | Ultimate${N}"
    echo -e "${M}▸${N} ${C}Platform:${N} ${Y}Termux / Linux${N}"
    echo -e "${C}▸${N} ${C}Status:${N} ${G}Active Development${N}"
    echo ""
    echo -e "${Y}══════════════════════════════════════════════${N}"
    echo -e "${R}⚠${N}  ${W}Disclaimer:${N}"
    echo -e "${C}This tool is for educational purposes only.${N}"
    echo -e "${B}Use only on files you own or have permission.${N}"
    echo ""
    echo -e "${C}║${N}                                              ${C}║${N}"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${N}"
    
    read -p "$(echo -e "${P}[?]${N} ${W}Press Enter to continue...${N}")" dummy
}

# Function to show success message - Green theme
success_msg() {
    echo ""
    echo -e "${G}══════════════════════════════════════════════${N}"
    echo -e "${G}                 SUCCESS!                     ${N}"
    echo -e "${G}══════════════════════════════════════════════${N}"
    echo ""
}

# Function to show error message - Red theme
error_msg() {
    echo ""
    echo -e "${R}══════════════════════════════════════════════${N}"
    echo -e "${R}                  ERROR!                      ${N}"
    echo -e "${R}══════════════════════════════════════════════${N}"
    echo ""
}

# Function to show warning message - Yellow theme
warning_msg() {
    echo ""
    echo -e "${Y}══════════════════════════════════════════════${N}"
    echo -e "${Y}                WARNING!                      ${N}"
    echo -e "${Y}══════════════════════════════════════════════${N}"
    echo ""
}

# Function for colorful prompt
color_prompt() {
    local prompt_text="$1"
    echo -e "${C}[?]${N} ${W}$prompt_text${N}"
}

# Main loop
while true; do
    clear
    show_menu
    
    color_prompt "Enter your choice [1-4]"
    echo -ne "${P}Choice: ${G}"
    read choice
    echo -e "${N}"
    
    case $choice in
        1)
            echo ""
            separator
            
            # Check requirements with colorful output
            check_requirements
            if [ $? -eq 0 ]; then
                echo -e "${G}[✓]${N} ${C}All requirements are satisfied${N}"
                sleep 1
                
                # Show version selection
                select_version
                color_prompt "Select version to launch [1-4]"
                echo -ne "${P}Version: ${G}"
                read ver_choice
                echo -e "${N}"
                
                case $ver_choice in
                    1) launch_tool "tool_main.sh" "Classic Edition" ;;
                    2) launch_tool "tool-main.sh" "Advanced Edition" ;;
                    3) launch_tool "tool+main.sh" "Ultimate Edition" ;;
                    4) echo -e "${Y}[*]${N} ${O}Returning to main menu...${N}"; sleep 1 ;;
                    *) echo -e "${R}[!]${N} ${R}Invalid choice!${N}"; sleep 2 ;;
                esac
            else
                warning_msg
                echo -e "${Y}[!]${N} ${O}Missing requirements detected${N}"
                echo ""
                color_prompt "Install missing packages? (y/n)"
                echo -ne "${B}Your choice: ${G}"
                read install_choice
                echo -e "${N}"
                
                if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
                    install_requirements
                    success_msg
                    sleep 1
                    
                    # Show version selection
                    select_version
                    color_prompt "Select version to launch [1-4]"
                    echo -ne "${P}Version: ${G}"
                    read ver_choice
                    echo -e "${N}"
                    
                    case $ver_choice in
                        1) launch_tool "tool_main.sh" "Classic Edition" ;;
                        2) launch_tool "tool-main.sh" "Advanced Edition" ;;
                        3) launch_tool "tool+main.sh" "Ultimate Edition" ;;
                        4) echo -e "${Y}[*]${N} ${O}Returning to main menu...${N}"; sleep 1 ;;
                        *) echo -e "${R}[!]${N} ${R}Invalid choice!${N}"; sleep 2 ;;
                    esac
                else
                    echo -e "${Y}[*]${N} ${O}Skipping installation${N}"
                    read -p "$(echo -e "${P}[?]${N} ${W}Press Enter to continue...${N}")" dummy
                fi
            fi
            ;;
            
        2)
            echo ""
            separator
            warning_msg
            echo -e "${Y}[!]${N} ${O}Warning: Launching without requirement check${N}"
            echo -e "${Y}[*]${N} ${O}Tool may fail if requirements are missing${N}"
            echo ""
            color_prompt "Continue anyway? (y/n)"
            echo -ne "${B}Your choice: ${G}"
            read direct_choice
            echo -e "${N}"
            
            if [[ "$direct_choice" == "y" || "$direct_choice" == "Y" ]]; then
                # Show version selection
                select_version
                color_prompt "Select version to launch [1-4]"
                echo -ne "${P}Version: ${G}"
                read ver_choice
                echo -e "${N}"
                
                case $ver_choice in
                    1) launch_tool "tool_main.sh" "Classic Edition" ;;
                    2) launch_tool "tool-main.sh" "Advanced Edition" ;;
                    3) launch_tool "tool+main.sh" "Ultimate Edition" ;;
                    4) echo -e "${Y}[*]${N} ${O}Returning to main menu...${N}"; sleep 1 ;;
                    *) echo -e "${R}[!]${N} ${R}Invalid choice!${N}"; sleep 2 ;;
                esac
            else
                echo -e "${Y}[*]${N} ${O}Returning to main menu...${N}"
                sleep 1
            fi
            ;;
            
        3)
            show_about
            ;;
            
        4)
            echo ""
            separator
            echo -e "${P}[*]${N} ${C}Thank you for using Password Cracker Tool!${N}"
            echo -e "${Y}[*]${N} ${O}Exiting...${N}"
            echo ""
            exit 0
            ;;
            
        *)
            error_msg
            echo -e "${R}[!]${N} ${R}Invalid choice! Please enter 1, 2, 3 or 4${N}"
            sleep 2
            ;;
    esac
done
