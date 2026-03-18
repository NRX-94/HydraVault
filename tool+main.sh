#!/bin/bash

# ============================================
# ADVANCED ZIP PASSWORD CRACKER WITH MULTI-FORMAT
# AND PERSONAL INFORMATION ATTACK
# ============================================

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Global Variables
CURRENT_FILE=""
PASSWORD_LENGTH=0
PATTERN=""
CHARSET=""
ATTACK_MODE=""
DICT_FILE=""
OUTPUT_DIR="extracted"
PYTHON_CRACKER="advanced+cracker.py"
ZIP_TYPE="standard"
DICT_TYPE="default"

# ============================================
# DISPLAY FUNCTIONS
# ============================================

clear_screen() {
    clear
}

print_header() {
    local title="$1"
    echo ""
    echo -e "${PURPLE}╭───────────────────────────────────────────────╮${NC}"
    echo -e "${PURPLE}│${NC}${WHITE}        $title${NC}"
    echo -e "${PURPLE}╰───────────────────────────────────────────────╯${NC}"
    echo ""
}

print_prompt() {
    echo -e "${CYAN}►${NC} ${WHITE}$1${NC}"
}

print_choice() {
    echo -e "${GREEN}$1.${NC} ${WHITE}$2${NC}"
}

print_error() {
    echo -e "${RED}[!]${NC} ${WHITE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} ${WHITE}$1${NC}"
}

print_info() {
    echo -e "${BLUE}[*]${NC} ${WHITE}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} ${WHITE}$1${NC}"
}

print_line() {
    echo -e "${BLUE}────────────────────────────────────────────────${NC}"
}

# ============================================
# REQUIREMENT CHECK
# ============================================

check_requirements() {
    print_info "Checking requirements..."
    
    local need_pyzipper=0
    local need_rarfile=0
    local need_py7zr=0
    local need_python=0
    local need_pip=0
    local need_unrar=0
    local need_7z=0
    local need_pypdf2=0
    local need_openpyxl=0
    local need_pptx=0
    local need_docx=0
    local need_xlrd=0
    
    if ! command -v python3 &> /dev/null; then
        print_warning "Python3 not found!"
        need_python=1
    else
        print_success "Python3: $(python3 --version 2>&1)"
    fi
    
    if ! command -v pip3 &> /dev/null; then
        print_warning "pip3 not found!"
        need_pip=1
    else
        print_success "pip3: $(pip3 --version 2>&1 | head -n1)"
    fi
    
    if ! python3 -c "import pyzipper" 2>/dev/null; then
        print_warning "pyzipper module not found (for AES encryption)"
        need_pyzipper=1
    else
        print_success "pyzipper: OK"
    fi
    
    if ! python3 -c "import rarfile" 2>/dev/null; then
        print_info "rarfile module not found (optional, for RAR support)"
        need_rarfile=1
    else
        print_success "rarfile: OK"
    fi
    
    if ! command -v unrar &> /dev/null; then
        print_info "unrar not found (optional, for RAR support)"
        need_unrar=1
    else
        print_success "unrar: OK"
    fi
    
    if ! python3 -c "import py7zr" 2>/dev/null; then
        print_info "py7zr module not found (optional, for 7Z support)"
        need_py7zr=1
    else
        print_success "py7zr: OK"
    fi
    
    if ! command -v 7z &> /dev/null; then
        print_info "7z not found (optional, for 7Z support)"
        need_7z=1
    else
        print_success "7z: OK"
    fi
    
    # PDF support
    if ! python3 -c "import PyPDF2" 2>/dev/null; then
        print_info "PyPDF2 module not found (for PDF support)"
        need_pypdf2=1
    else
        print_success "PyPDF2: OK"
    fi
    
    # Excel support
    if ! python3 -c "import openpyxl" 2>/dev/null; then
        print_info "openpyxl module not found (for Excel XLSX support)"
        need_openpyxl=1
    else
        print_success "openpyxl: OK"
    fi
    
    if ! python3 -c "import xlrd" 2>/dev/null; then
        print_info "xlrd module not found (for Excel XLS support)"
        need_xlrd=1
    else
        print_success "xlrd: OK"
    fi
    
    # PowerPoint support
    if ! python3 -c "from pptx import Presentation" 2>/dev/null; then
        print_info "python-pptx module not found (for PowerPoint support)"
        need_pptx=1
    else
        print_success "python-pptx: OK"
    fi
    
    # Word support
    if ! python3 -c "import docx" 2>/dev/null; then
        print_info "python-docx module not found (for Word support)"
        need_docx=1
    else
        print_success "python-docx: OK"
    fi
    
    echo ""
    
    if [[ $need_python -eq 1 ]]; then
        print_info "Installing Python3..."
        pkg install python3 -y
    fi
    
    if [[ $need_pip -eq 1 ]]; then
        print_info "Installing pip3..."
        pkg install python3-pip -y
    fi
    
    if [[ $need_pyzipper -eq 1 ]]; then
        print_info "Installing pyzipper (required)..."
        pip3 install pyzipper
    fi
    
    echo ""
    echo -e "${CYAN}Install optional modules for RAR/7Z/PDF/Office support? (y/n):${NC}"
    read install_optional
    
    if [[ "$install_optional" =~ ^[Yy]$ ]]; then
        if [[ $need_rarfile -eq 1 ]]; then
            print_info "Installing rarfile (for RAR)..."
            pip3 install rarfile
        fi
        
        if [[ $need_unrar -eq 1 ]]; then
            print_info "Installing unrar (for RAR extraction)..."
            pkg install unrar -y
        fi
        
        if [[ $need_py7zr -eq 1 ]]; then
            print_info "Installing py7zr (for 7Z)..."
            pip3 install py7zr
        fi
        
        if [[ $need_7z -eq 1 ]]; then
            print_info "Installing 7z (for 7Z extraction)..."
            pkg install p7zip -y
        fi
        
        if [[ $need_pypdf2 -eq 1 ]]; then
            print_info "Installing PyPDF2 (for PDF)..."
            pip3 install PyPDF2
        fi
        
        if [[ $need_openpyxl -eq 1 ]]; then
            print_info "Installing openpyxl (for Excel XLSX)..."
            pip3 install openpyxl
        fi
        
        if [[ $need_xlrd -eq 1 ]]; then
            print_info "Installing xlrd (for Excel XLS)..."
            pip3 install xlrd
        fi
        
        if [[ $need_pptx -eq 1 ]]; then
            print_info "Installing python-pptx (for PowerPoint)..."
            pip3 install python-pptx
        fi
        
        if [[ $need_docx -eq 1 ]]; then
            print_info "Installing python-docx (for Word)..."
            pip3 install python-docx
        fi
    else
        print_info "Skipping optional modules"
    fi
    
    print_success "Requirements check completed"
    sleep 1
}

# ============================================
# STEP 1: FILE SELECTION
# ============================================

select_file() {
    while true; do
        clear_screen
        print_header "File Selection"
        
        print_prompt "Please enter the file location"
        echo -e "${CYAN}Enter file path:${NC}"
        read -e file_path
        
        file_path="${file_path//\'/}"
        file_path="${file_path//\"/}"
        file_path="${file_path/#\~/$HOME}"
        
        if [[ -z "$file_path" ]]; then
            print_error "No file path provided"
            echo ""
            echo -e "${YELLOW}Press Enter to try again...${NC}"
            read
            continue
        fi
        
        if [[ ! -f "$file_path" ]];then
            print_error "File not found: $file_path"
            echo ""
            echo -e "${CYAN}Current directory:${NC} $(pwd)"
            echo -e "${CYAN}Files available:${NC}"
            ls -la | head -10
            echo ""
            echo -e "${YELLOW}Press Enter to try again...${NC}"
            read
            continue
        fi
        
        local file_size=$(du -h "$file_path" 2>/dev/null | cut -f1)
        local file_type=$(file -b "$file_path" 2>/dev/null || echo "Unknown")
        
        echo ""
        print_line
        echo -e "${GREEN}File Information:${NC}"
        echo -e "${CYAN}Name:${NC} ${WHITE}$(basename "$file_path")${NC}"
        echo -e "${CYAN}Size:${NC} ${WHITE}$file_size${NC}"
        echo -e "${CYAN}Type:${NC} ${WHITE}$file_type${NC}"
        print_line
        
        echo ""
        echo -e "${CYAN}Use this file? (y/n):${NC}"
        read confirm
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            CURRENT_FILE="$file_path"
            return 0
        fi
    done
}

# ============================================
# STEP 1A: FILE TYPE SELECTION
# ============================================

select_file_type() {
    clear_screen
    print_header "Select File Type"
    
    echo -e "${WHITE}Choose file format:${NC}"
    echo ""
    
    print_choice "1" "Standard ZIP (zipcrypt)"
    print_choice "2" "AES Encrypted ZIP (WinZip, 7-Zip AES)"
    print_choice "3" "7Z Archive (7-Zip format)"
    print_choice "4" "RAR Archive (WinRAR)"
    print_choice "5" "PDF Document (Adobe PDF)"
    print_choice "6" "Excel File (XLS/XLSX)"
    print_choice "7" "PowerPoint File (PPT/PPTX)"
    print_choice "8" "Word Document (DOC/DOCX)"
    print_choice "9" "Auto Detect (Recommended)"
    echo ""
    
    while true; do
        echo -e "${CYAN}Select option [1-9]:${NC}"
        read choice
        
        case $choice in
            1) ZIP_TYPE="standard"; break ;;
            2) ZIP_TYPE="aes"; break ;;
            3) 
                if ! command -v 7z &> /dev/null; then
                    print_warning "7z command not found"
                    echo -e "${CYAN}Install p7zip? (y/n):${NC}"
                    read install7z
                    if [[ "$install7z" =~ ^[Yy]$ ]]; then
                        pkg install p7zip -y
                    fi
                fi
                ZIP_TYPE="7z"
                break
                ;;
            4)
                if ! command -v unrar &> /dev/null; then
                    print_warning "unrar command not found"
                    echo -e "${CYAN}Install unrar? (y/n):${NC}"
                    read installunrar
                    if [[ "$installunrar" =~ ^[Yy]$ ]]; then
                        pkg install unrar -y
                    fi
                fi
                ZIP_TYPE="rar"
                break
                ;;
            5) ZIP_TYPE="pdf"; break ;;
            6) ZIP_TYPE="excel"; break ;;
            7) ZIP_TYPE="powerpoint"; break ;;
            8) ZIP_TYPE="word"; break ;;
            9) ZIP_TYPE="auto"; break ;;
            *) print_error "Invalid choice" ;;
        esac
    done
    
    print_success "Selected: $ZIP_TYPE mode"
    sleep 1
}

# ============================================
# STEP 2: ATTACK MODE SELECTION
# ============================================

select_attack_mode() {
    clear_screen
    print_header "Select Attack Mode"
    
    echo -e "${WHITE}Choose attack method:${NC}"
    echo ""
    
    print_choice "1" "Brute Force Attack (Pattern based)"
    print_choice "2" "Dictionary Attack (Password list)"
    print_choice "3" "Smart Dictionary Attack (Advanced)"
    print_choice "4" "Personal Information Attack"
    print_choice "5" "Test Single Password"
    echo ""
    
    while true; do
        echo -e "${CYAN}Select option [1-5]:${NC}"
        read choice
        
        case $choice in
            1) ATTACK_MODE="bruteforce"; break ;;
            2) ATTACK_MODE="dictionary"; break ;;
            3) ATTACK_MODE="smartdict"; break ;;
            4) ATTACK_MODE="personal"; break ;;
            5) ATTACK_MODE="single"; break ;;
            *) print_error "Invalid choice" ;;
        esac
    done
}

# ============================================
# PERSONAL INFORMATION ATTACK MODE
# ============================================

setup_personal_info_attack() {
    clear_screen
    print_header "Personal Information Attack"
    
    echo -e "${WHITE}Generate passwords from personal information${NC}"
    echo ""
    
    # Create Python generator with ALL patterns and MULTIPLE MOBILE SUPPORT
    cat > personal_generator.py << 'PYEOF'
#!/usr/bin/env python3

import sys
import itertools

def generate_passwords_from_info(first_name, last_name, birth_day, birth_month, birth_year, 
                                 mobile, girlfriend, spouse, pet, city, fav_num, old_pwds, special_dates):
    
    passwords = set()
    
    # Clean and prepare data
    first = first_name.strip()
    last = last_name.strip()
    day = birth_day.strip()
    month = birth_month.strip()
    year = birth_year.strip()
    gf = girlfriend.strip()
    sp = spouse.strip()
    pt = pet.strip()
    ct = city.strip()
    fn = fav_num.strip()
    
    # Year variations
    year_full = year
    year_short = year[-2:] if len(year) >= 2 else ""
    
    # ============================================
    # MULTIPLE MOBILE NUMBERS SUPPORT
    # ============================================
    mobile_numbers = []
    if mobile.strip():
        # Split by comma and clean each number
        raw_numbers = [num.strip() for num in mobile.split(',') if num.strip()]
        for num in raw_numbers:
            # Remove any non-digit characters
            clean_num = ''.join(filter(str.isdigit, num))
            if clean_num:
                mobile_numbers.append(clean_num)
    
    # If no valid numbers found, add empty string
    if not mobile_numbers:
        mobile_numbers.append("")
    
    # Process EACH mobile number separately
    for mob_full in mobile_numbers:
        if mob_full:
            mob_last4 = mob_full[-4:] if len(mob_full) >= 4 else ""
            mob_last5 = mob_full[-5:] if len(mob_full) >= 5 else ""
            mob_last6 = mob_full[-6:] if len(mob_full) >= 6 else ""
            mob_first4 = mob_full[:4] if len(mob_full) >= 4 else ""
            mob_first5 = mob_full[:5] if len(mob_full) >= 5 else ""
            mob_first6 = mob_full[:6] if len(mob_full) >= 6 else ""
            mob_mid5 = mob_full[2:7] if len(mob_full) >= 7 else ""
            mob_last2 = mob_full[-2:] if len(mob_full) >= 2 else ""
            mob_first2 = mob_full[:2] if len(mob_full) >= 2 else ""
            mob_international = "+88" + mob_full if len(mob_full) > 0 else ""
            mob_international2 = "88" + mob_full if len(mob_full) > 0 else ""
            mob_last3 = mob_full[-3:] if len(mob_full) >= 3 else ""
            mob_last7 = mob_full[-7:] if len(mob_full) >= 7 else ""
            mob_last8 = mob_full[-8:] if len(mob_full) >= 8 else ""
        else:
            mob_last4 = mob_last5 = mob_last6 = mob_first4 = mob_first5 = mob_first6 = ""
            mob_mid5 = mob_last2 = mob_first2 = mob_international = mob_international2 = ""
            mob_last3 = mob_last7 = mob_last8 = ""
        
        # All possible components
        components = []
        if first: components.append(first)
        if last: components.append(last)
        if day: components.append(day)
        if month: components.append(month)
        if year_full: components.append(year_full)
        if year_short: components.append(year_short)
        if mob_full: components.append(mob_full)
        if mob_last4: components.append(mob_last4)
        if mob_last5: components.append(mob_last5)
        if mob_last6: components.append(mob_last6)
        if mob_first4: components.append(mob_first4)
        if mob_first5: components.append(mob_first5)
        if mob_first6: components.append(mob_first6)
        if mob_mid5: components.append(mob_mid5)
        if mob_last2: components.append(mob_last2)
        if mob_first2: components.append(mob_first2)
        if mob_international: components.append(mob_international)
        if mob_international2: components.append(mob_international2)
        if mob_last3: components.append(mob_last3)
        if mob_last7: components.append(mob_last7)
        if mob_last8: components.append(mob_last8)
        if gf: components.append(gf)
        if sp: components.append(sp)
        if pt: components.append(pt)
        if ct: components.append(ct)
        if fn: components.append(fn)
        
        # Add combined names
        if first and last:
            components.append(first + last)
            components.append(last + first)
            components.append(first + "." + last)
            components.append(first + "_" + last)
            components.append(first[0] + last)
            components.append(first + last[0])
        
        # Common suffixes and numbers
        common_suffixes = ['', '123', '1234', '12345', '123456', '!', '@', '#', '!@#', '!@#$']
        common_numbers = ['', '1', '12', '123', '1234', '007', '100', '200', '500', '1000']
        
        # PATTERN 1: Name + Year (Minhaz2008)
        if first and year_full:
            passwords.add(first + year_full)
            passwords.add(first.lower() + year_full)
            passwords.add(first.capitalize() + year_full)
            passwords.add(first + year_short)
            
            # With suffixes
            for suf in common_suffixes:
                passwords.add(first + year_full + suf)
                passwords.add(first.lower() + year_full + suf)
        
        # PATTERN 2: Name + Year + Extra (Minhaz2008uddin)
        if first and last and year_full:
            passwords.add(first + year_full + last)
            passwords.add(first + last + year_full)
            passwords.add(first.capitalize() + year_full + last.lower())
        
        # PATTERN 3: Full name + Year (Minhazuddin2008)
        if first and last and year_full:
            full_name = first + last
            passwords.add(full_name + year_full)
            passwords.add(full_name.lower() + year_full)
            passwords.add(full_name.capitalize() + year_full)
            
            # Variations
            passwords.add(first + last + year_short)
            passwords.add(first.capitalize() + last.capitalize() + year_full)
        
        # PATTERN 4: Name + Mobile (Sajim Islam01852288884) - FOR EACH MOBILE
        if first and mob_full:
            # With space
            passwords.add(first + " " + last + mob_full if last else first + mob_full)
            # Without space
            passwords.add(first + last + mob_full if last else first + mob_full)
            # Last digits only
            if mob_last6:
                passwords.add(first + mob_last6)
                passwords.add(first.lower() + mob_last6)
                passwords.add(first + last + mob_last6 if last else first + mob_last6)
            if mob_last5:
                passwords.add(first + mob_last5)
                passwords.add(first.lower() + mob_last5)
            if mob_last4:
                passwords.add(first + mob_last4)
                passwords.add(first + "123" + mob_last4)
                passwords.add(first + last + mob_last4 if last else first + mob_last4)
            # First digits only
            if mob_first4:
                passwords.add(first + mob_first4)
                passwords.add(first + last + mob_first4 if last else first + mob_first4)
            if mob_first5:
                passwords.add(first + mob_first5)
                passwords.add(first + last + mob_first5 if last else first + mob_first5)
            if mob_first6:
                passwords.add(first + mob_first6)
                passwords.add(first + last + mob_first6 if last else first + mob_first6)
        
        # PATTERN 5: Name + Common numbers (Sajim Islam123)
        if first:
            for num in common_numbers:
                if num:
                    passwords.add(first + " " + last + num if last else first + num)
                    passwords.add(first + last + num if last else first + num)
                    passwords.add(first.lower() + num)
                    passwords.add(first.capitalize() + num)
        
        # PATTERN 6: Name + Special char + numbers (Minhaz@2008)
        if first and year_full:
            special_chars = ['@', '_', '.', '-', '#', '!']
            for char in special_chars:
                passwords.add(first + char + year_full)
                passwords.add(first + char + year_short)
                passwords.add(first.lower() + char + year_full)
        
        # PATTERN 7: Reverse (2008Minhaz)
        if first and year_full:
            passwords.add(year_full + first)
            passwords.add(year_short + first)
            passwords.add(year_full + first.lower())
        
        # PATTERN 8: Name + Short numbers (Minhaz008)
        if first:
            for i in range(10, 1000, 1):
                if len(passwords) > 50000:
                    break
                passwords.add(first + str(i).zfill(3))
                passwords.add(first.lower() + str(i).zfill(3))
        
        # PATTERN 9: Name.Last (Minhaz.islam)
        if first and last:
            passwords.add(first + "." + last)
            passwords.add(first + "." + last.lower())
            passwords.add(first.lower() + "." + last.lower())
        
        # PATTERN 10: Namesurname + year (Minhazislam2008)
        if first and last and year_full:
            passwords.add(first + last + year_full)
            passwords.add(first.lower() + last.lower() + year_full)
            passwords.add(first + last + year_short)
        
        # PATTERN 11: Name + Multiple numbers (Minhaz123456)
        if first:
            for num in ['123', '1234', '12345', '123456', '1234567', '12345678']:
                passwords.add(first + num)
                passwords.add(first.lower() + num)
        
        # PATTERN 12: First name + Last name only
        if first and last:
            passwords.add(first + last)
            passwords.add(last + first)
            passwords.add(first.upper() + last.upper())
            passwords.add(first.capitalize() + last.capitalize())
        
        # PATTERN 13: Lowercase only (minhaz2008)
        if first and year_full:
            passwords.add(first.lower() + year_full)
            passwords.add(first.lower() + year_short)
        
        # PATTERN 14: Uppercase only (MINHAZ2008)
        if first and year_full:
            passwords.add(first.upper() + year_full)
            passwords.add(first.upper() + year_short)
        
        # PATTERN 15: Name + @ + year (Minhaz@2008)
        if first and year_full:
            passwords.add(first + "@" + year_full)
            passwords.add(first + "@" + year_short)
        
        # PATTERN 16: Name + _ + year (Minhaz_2008)
        if first and year_full:
            passwords.add(first + "_" + year_full)
            passwords.add(first + "_" + year_short)
        
        # PATTERN 17: Girlfriend related (MinhazPriya, MinhazLovePriya)
        if first and gf:
            passwords.add(first + gf)
            passwords.add(gf + first)
            passwords.add(first + "Love" + gf)
            passwords.add(first + "My" + gf)
            passwords.add(first + "&" + gf)
            passwords.add(first + gf + year_full if year_full else first + gf)
            
            # With numbers
            for num in common_suffixes:
                passwords.add(first + gf + num)
                passwords.add(first + "Love" + gf + num)
        
        # PATTERN 18: Spouse related
        if first and sp:
            passwords.add(first + sp)
            passwords.add(first + "Wife" + sp)
            passwords.add(first + "Husband" + sp)
            passwords.add(first + "&" + sp)
        
        # PATTERN 19: Pet related
        if first and pt:
            passwords.add(first + pt)
            passwords.add(pt + first)
            passwords.add(first + "My" + pt)
        
        # PATTERN 20: City related
        if first and ct:
            passwords.add(first + ct)
            passwords.add(ct + first)
            passwords.add(first + ct + year_full if year_full else first + ct)
        
        # PATTERN 21: Favorite number
        if first and fn:
            passwords.add(first + fn)
            passwords.add(fn + first)
            passwords.add(first + "No" + fn)
        
        # PATTERN 22: Name + Day + Month
        if first and day and month:
            passwords.add(first + day + month)
            passwords.add(first + month + day)
            passwords.add(first + day + month + year_short if year_short else first + day + month)
        
        # PATTERN 23: Initials + year (MI2008)
        if first and last and year_full:
            initials = first[0] + last[0]
            passwords.add(initials + year_full)
            passwords.add(initials.upper() + year_full)
            passwords.add(initials.lower() + year_full)
        
        # PATTERN 24: First 3 letters + year (Min2008)
        if first and year_full and len(first) >= 3:
            passwords.add(first[:3] + year_full)
            passwords.add(first[:3].capitalize() + year_full)
        
        # PATTERN 25: Last 3 letters + year (haz2008)
        if first and year_full and len(first) >= 3:
            passwords.add(first[-3:] + year_full)
            passwords.add(first[-3:].capitalize() + year_full)
        
        # PATTERN 26: Date combinations (DDMMYYYY)
        if day and month and year_full:
            passwords.add(day + month + year_full)
            passwords.add(year_full + month + day)
            if first:
                passwords.add(first + day + month + year_full)
                passwords.add(day + month + year_full + first)
        
        # PATTERN 27: Simple combinations (2 components)
        for i in range(len(components)):
            for j in range(len(components)):
                if i != j:
                    combo = components[i] + components[j]
                    if 4 <= len(combo) <= 20:
                        passwords.add(combo)
                        passwords.add(combo.lower())
                        passwords.add(combo.capitalize())
        
        # PATTERN 28: Add common suffixes to all passwords
        enhanced = set()
        for pwd in list(passwords):
            enhanced.add(pwd)
            for suf in ['!', '@', '#', '$', '123', '1234', '1', '0', '00', '000']:
                if len(pwd + suf) <= 20:
                    enhanced.add(pwd + suf)
        
        # ============================================
        # @ SYMBOL VARIATIONS - COMPLETE SET
        # ============================================
        
        # PATTERN 29: @ AT THE BEGINNING - ALL VARIATIONS
        if first:
            passwords.add("@" + first)
            passwords.add("@" + first.lower())
            passwords.add("@" + first.upper())
            passwords.add("@" + first.capitalize())
            
            if last:
                passwords.add("@" + first + last)
                passwords.add("@" + first.lower() + last.lower())
                passwords.add("@" + first.upper() + last.upper())
                passwords.add("@" + first.capitalize() + last.capitalize())
                
                if year_full:
                    passwords.add("@" + first + last + year_full)
                    passwords.add("@" + first + last + year_short)
                    passwords.add("@" + first.lower() + last.lower() + year_full)
                    passwords.add("@" + first.upper() + last.upper() + year_full)
                    passwords.add("@" + first + year_full + last)
                    passwords.add("@" + first + year_short + last)
                    passwords.add("@" + first.lower() + year_full + last.lower())
            
            if year_full:
                passwords.add("@" + first + year_full)
                passwords.add("@" + first + year_short)
                passwords.add("@" + first.lower() + year_full)
                passwords.add("@" + first.upper() + year_full)
        
        # PATTERN 30: @ AT THE END - ALL VARIATIONS
        if first:
            passwords.add(first + "@")
            passwords.add(first.lower() + "@")
            passwords.add(first.upper() + "@")
            
            if last:
                passwords.add(first + last + "@")
                passwords.add(first.lower() + last.lower() + "@")
                passwords.add(first.upper() + last.upper() + "@")
                
                if year_full:
                    passwords.add(first + last + year_full + "@")
                    passwords.add(first + last + year_short + "@")
                    passwords.add(first + year_full + last + "@")
                    passwords.add(first + year_short + last + "@")
            
            if year_full:
                passwords.add(first + year_full + "@")
                passwords.add(first + year_short + "@")
                passwords.add(first.lower() + year_full + "@")
        
        # PATTERN 31: @ IN THE MIDDLE - NAME@NAME
        if first and last:
            passwords.add(first + "@" + last)
            passwords.add(first + "@" + last.capitalize())
            passwords.add(first.lower() + "@" + last.lower())
            passwords.add(first.upper() + "@" + last.upper())
            passwords.add(first.capitalize() + "@" + last.capitalize())
        
        # PATTERN 32: @ IN THE MIDDLE - NAME@YEAR
        if first and year_full:
            passwords.add(first + "@" + year_full)
            passwords.add(first + "@" + year_short)
            passwords.add(first.lower() + "@" + year_full)
            passwords.add(first.upper() + "@" + year_full)
        
        # PATTERN 33: @ IN THE MIDDLE - YEAR@NAME
        if first and year_full:
            passwords.add(year_full + "@" + first)
            passwords.add(year_short + "@" + first)
            passwords.add(year_full + "@" + first.lower())
            passwords.add(year_full + "@" + first.upper())
        
        # PATTERN 34: @ IN THE MIDDLE - NAME@NAME@YEAR
        if first and last and year_full:
            passwords.add(first + "@" + last + "@" + year_full)
            passwords.add(first + "@" + last + "@" + year_short)
            passwords.add(first + "@" + year_full + "@" + last)
            passwords.add(first + "@" + year_short + "@" + last)
            passwords.add(year_full + "@" + first + "@" + last)
            passwords.add(year_short + "@" + first + "@" + last)
        
        # PATTERN 35: @ WITH MOBILE - FOR EACH MOBILE
        if first and mob_full:
            passwords.add(first + "@" + mob_full)
            passwords.add(first + "@" + mob_last6)
            passwords.add(first + "@" + mob_last4)
            passwords.add(first.lower() + "@" + mob_full)
            passwords.add(first + last + "@" + mob_full if last else first + "@" + mob_full)
            passwords.add(mob_full + "@" + first)
            passwords.add(mob_last6 + "@" + first)
            passwords.add(mob_last4 + "@" + first)
            passwords.add(mob_full + "@" + first + last if last else mob_full + "@" + first)
        
        # PATTERN 36: @ WITH GIRLFRIEND
        if first and gf:
            passwords.add(first + "@" + gf)
            passwords.add(gf + "@" + first)
            passwords.add(first.lower() + "@" + gf.lower())
            
            if year_full:
                passwords.add(first + "@" + gf + "@" + year_full)
                passwords.add(gf + "@" + first + "@" + year_short)
        
        # ============================================
        # $ SYMBOL VARIATIONS - COMPLETE SET
        # ============================================
        
        # PATTERN 37: $ AT THE BEGINNING
        if first:
            passwords.add("$" + first)
            passwords.add("$" + first.lower())
            
            if last:
                passwords.add("$" + first + last)
                
            if year_full:
                passwords.add("$" + first + year_full)
                passwords.add("$" + first + year_short)
        
        # PATTERN 38: $ AT THE END
        if first:
            passwords.add(first + "$")
            
            if last:
                passwords.add(first + last + "$")
                
            if year_full:
                passwords.add(first + year_full + "$")
        
        # PATTERN 39: $ IN THE MIDDLE
        if first and year_full:
            passwords.add(first + "$" + year_full)
            passwords.add(year_full + "$" + first)
        
        # ============================================
        # & SYMBOL VARIATIONS - COMPLETE SET
        # ============================================
        
        # PATTERN 40: & VARIATIONS
        if first and last:
            passwords.add(first + "&" + last)
            
            if year_full:
                passwords.add(first + "&" + year_full)
                passwords.add(first + "&" + last + "&" + year_full)
        
        # PATTERN 41: & WITH COUPLE NAMES
        if first and gf:
            passwords.add(first + "&" + gf)
            passwords.add(gf + "&" + first)
            
            if year_full:
                passwords.add(first + "&" + year_full + "&" + gf)
        
        # ============================================
        # ! SYMBOL VARIATIONS - COMPLETE SET
        # ============================================
        
        # PATTERN 42: ! AT THE BEGINNING
        if first:
            passwords.add("!" + first)
            
            if year_full:
                passwords.add("!" + first + year_full)
        
        # PATTERN 43: ! AT THE END
        if first:
            passwords.add(first + "!")
            
            if year_full:
                passwords.add(first + year_full + "!")
        
        # PATTERN 44: ! IN THE MIDDLE
        if first and year_full:
            passwords.add(first + "!" + year_full)
            passwords.add(year_full + "!" + first)
        
        # ============================================
        # # SYMBOL VARIATIONS - COMPLETE SET
        # ============================================
        
        # PATTERN 45: # AT THE BEGINNING
        if first:
            passwords.add("#" + first)
            
            if year_full:
                passwords.add("#" + first + year_full)
        
        # PATTERN 46: # AT THE END
        if first:
            passwords.add(first + "#")
            
            if year_full:
                passwords.add(first + year_full + "#")
        
        # PATTERN 47: # IN THE MIDDLE
        if first and year_full:
            passwords.add(first + "#" + year_full)
        
        # ============================================
        # % SYMBOL VARIATIONS
        # ============================================
        
        # PATTERN 48: % VARIATIONS
        if first and year_full:
            passwords.add(first + "%" + year_full)
            passwords.add("%" + first + year_full)
            passwords.add(first + year_full + "%")
        
        # ============================================
        # = SYMBOL VARIATIONS
        # ============================================
        
        # PATTERN 49: = VARIATIONS
        if first and year_full:
            passwords.add(first + "=" + year_full)
            passwords.add("=" + first + year_full)
        
        # ============================================
        # + SYMBOL VARIATIONS
        # ============================================
        
        # PATTERN 50: + VARIATIONS
        if first and year_full:
            passwords.add(first + "+" + year_full)
            passwords.add("+" + first + year_full)
        
        # ============================================
        # * SYMBOL VARIATIONS
        # ============================================
        
        # PATTERN 51: * VARIATIONS
        if first and year_full:
            passwords.add(first + "*" + year_full)
            passwords.add("*" + first + year_full)
        
        # ============================================
        # MIXED SYMBOLS COMBINATIONS
        # ============================================
        
        # PATTERN 52: @@ (DOUBLE AT)
        if first and year_full:
            passwords.add(first + "@@" + year_full)
            passwords.add(first + "@@" + year_short)
            passwords.add(year_full + "@@" + first)
            
            if last:
                passwords.add(first + last + "@@" + year_full)
        
        # PATTERN 53: !! VARIATIONS
        if first and year_full:
            passwords.add(first + "!!" + year_full)
            passwords.add("!!" + first + year_full)
        
        # PATTERN 54: ## VARIATIONS
        if first and year_full:
            passwords.add(first + "##" + year_full)
        
        # PATTERN 55: $$ VARIATIONS
        if first and year_full:
            passwords.add(first + "$$" + year_full)
        
        # PATTERN 56: && VARIATIONS
        if first and year_full:
            passwords.add(first + "&&" + year_full)
        
        # PATTERN 57: ++ VARIATIONS
        if first and year_full:
            passwords.add(first + "++" + year_full)
        
        # PATTERN 58: == VARIATIONS
        if first and year_full:
            passwords.add(first + "==" + year_full)
        
        # PATTERN 59: ~~ VARIATIONS
        if first and year_full:
            passwords.add(first + "~~" + year_full)
        
        # PATTERN 60: ^^ VARIATIONS
        if first and year_full:
            passwords.add(first + "^^" + year_full)
        
        # ============================================
        # MIXED SYMBOLS - MULTIPLE DIFFERENT SYMBOLS
        # ============================================
        
        # PATTERN 61: @ AND ! COMBINATION
        if first and year_full:
            passwords.add(first + "@" + year_full + "!")
            passwords.add(first + "@" + year_short + "!")
            passwords.add("@" + first + year_full + "!")
            passwords.add("!" + first + year_full + "@")
        
        # PATTERN 62: @ AND # COMBINATION
        if first and year_full:
            passwords.add(first + "@" + year_full + "#")
            passwords.add("#" + first + year_full + "@")
        
        # PATTERN 63: @ AND $ COMBINATION
        if first and year_full:
            passwords.add(first + "@" + year_full + "$")
        
        # PATTERN 64: ! AND # COMBINATION
        if first and year_full:
            passwords.add(first + "!" + year_full + "#")
        
        # ============================================
        # SYMBOL + NUMBER COMBOS
        # ============================================
        
        # PATTERN 65: SYMBOL + 123
        if first:
            passwords.add(first + "@" + "123")
            passwords.add(first + "@" + "1234")
            passwords.add(first + "!" + "123")
            passwords.add(first + "#" + "123")
            
            if year_full:
                passwords.add(first + year_full + "@" + "123")
                passwords.add("123" + "@" + first + year_full)
        
        # ============================================
        # SYMBOL BETWEEN NAME AND MOBILE - FOR EACH MOBILE
        # ============================================
        
        # PATTERN 66: ALL SYMBOLS BETWEEN NAME AND MOBILE
        if first and mob_full:
            for sym in ["@", "#", "!", "$", "%", "&", "*", "+", "=", "~", "^", "?"]:
                passwords.add(first + sym + mob_full)
                passwords.add(first + sym + mob_last6)
                passwords.add(first + sym + mob_last4)
                passwords.add(first + last + sym + mob_full if last else first + sym + mob_full)
                passwords.add(mob_full + sym + first)
                passwords.add(mob_last6 + sym + first)
                passwords.add(mob_full + sym + first + last if last else mob_full + sym + first)
        
        # ============================================
        # SYMBOL BETWEEN MOBILE AND YEAR - FOR EACH MOBILE
        # ============================================
        
        # PATTERN 67: SYMBOL BETWEEN MOBILE AND YEAR
        if mob_full and year_full:
            for sym in ["@", "#", "!", "$", "&", "*"]:
                passwords.add(mob_full + sym + year_full)
                passwords.add(mob_last6 + sym + year_short)
                passwords.add(year_full + sym + mob_full)
                passwords.add(year_short + sym + mob_last6)
        
        # ============================================
        # ALL SYMBOLS WITH NAME - COMPLETE SET
        # ============================================
        
        # PATTERN 68: ALL SYMBOLS - BEGINNING, END, MIDDLE
        if first:
            all_symbols = ["@", "$", "&", "!", "#", "%", "=", "+", "*", "~", "^", "?", "|", "/", "\\", "`", "'", "\"", ";", ":", ",", ".", "<", ">"]
            
            for sym in all_symbols:
                # Symbol at beginning
                passwords.add(sym + first)
                if last:
                    passwords.add(sym + first + last)
                if year_full:
                    passwords.add(sym + first + year_full)
                
                # Symbol at end
                passwords.add(first + sym)
                if last:
                    passwords.add(first + last + sym)
                if year_full:
                    passwords.add(first + year_full + sym)
                
                # Symbol in middle
                if last:
                    passwords.add(first + sym + last)
                if year_full:
                    passwords.add(first + sym + year_full)
                    passwords.add(year_full + sym + first)
                if mob_full:
                    passwords.add(first + sym + mob_last4)
                    passwords.add(first + sym + mob_last6)
                    passwords.add(mob_last4 + sym + first)
                    passwords.add(mob_last6 + sym + first)
        
        # ============================================
        # DOUBLE SYMBOLS - ALL COMBINATIONS
        # ============================================
        
        # PATTERN 69: DOUBLE SYMBOLS WITH NAME
        if first:
            double_symbols = ["@@", "!!", "##", "$$", "&&", "++", "==", "~~", "^^", "**", "??", "||", "//", "::", ";;", ",,", "..", "--", "__"]
            
            for sym in double_symbols:
                # Double symbol at beginning
                passwords.add(sym + first)
                # Double symbol at end
                passwords.add(first + sym)
                
                if year_full:
                    # Double symbol between
                    passwords.add(first + sym + year_full)
                    passwords.add(year_full + sym + first)
                
                if last:
                    passwords.add(first + sym + last)
                
                if mob_full:
                    passwords.add(first + sym + mob_last4)
                    passwords.add(mob_last4 + sym + first)
        
        # ============================================
        # TRIPLE SYMBOLS
        # ============================================
        
        # PATTERN 70: TRIPLE SYMBOLS
        if first:
            triple_symbols = ["@@@", "!!!", "###", "$$$", "&&&", "+++", "===", "~~~", "^^^", "***"]
            
            for sym in triple_symbols:
                passwords.add(sym + first)
                passwords.add(first + sym)
                
                if year_full:
                    passwords.add(first + sym + year_full)
        
        # ============================================
        # COMMON PASSWORD PATTERNS WITH SYMBOLS
        # ============================================
        
        # PATTERN 71: P@ssw0rd STYLE
        if first:
            passwords.add(first.replace('a', '@').replace('s', '$').replace('i', '1').replace('o', '0'))
            
            if year_full:
                pwd = first.replace('a', '@').replace('s', '$').replace('i', '1').replace('o', '0')
                passwords.add(pwd + year_full)
        
        # PATTERN 72: SYMBOL BETWEEN EACH LETTER (Rare but possible)
        if first and len(first) <= 6:
            syms = ['@', '!', '#', '$']
            for sym in syms:
                passwords.add(sym.join(first))
        
        # PATTERN 73: SYMBOL + NAME + REVERSE NAME
        if first:
            passwords.add("@" + first + first[::-1])
            if year_full:
                passwords.add("@" + first + first[::-1] + year_short)
        
        # ============================================
        # MOBILE NUMBER VARIATIONS WITH SYMBOLS - FOR EACH MOBILE
        # ============================================
        
        # PATTERN 74: MOBILE WITH ALL SYMBOLS
        if mob_full:
            all_symbols = ["@", "#", "!", "$", "%", "&", "*", "+", "=", "~", "^", "?"]
            for sym in all_symbols:
                passwords.add(sym + mob_full)
                passwords.add(mob_full + sym)
                passwords.add(sym + mob_last6)
                passwords.add(mob_last6 + sym)
                passwords.add(sym + mob_last4)
                passwords.add(mob_last4 + sym)
        
        # ============================================
        # YEAR VARIATIONS WITH SYMBOLS
        # ============================================
        
        # PATTERN 75: YEAR WITH ALL SYMBOLS
        if year_full:
            all_symbols = ["@", "#", "!", "$", "%", "&", "*", "+", "=", "~", "^", "?"]
            for sym in all_symbols:
                passwords.add(sym + year_full)
                passwords.add(year_full + sym)
                passwords.add(sym + year_short)
                passwords.add(year_short + sym)
        
        # ============================================
        # GIRLFRIEND/SPOUSE VARIATIONS WITH SYMBOLS
        # ============================================
        
        # PATTERN 76: GIRLFRIEND WITH SYMBOLS
        if gf:
            for sym in ["@", "&", "!", "#", "$"]:
                passwords.add(sym + gf)
                passwords.add(gf + sym)
                
                if first:
                    passwords.add(first + sym + gf + sym)
                    passwords.add(sym + first + sym + gf)
                
                if year_full:
                    passwords.add(gf + sym + year_full)
        
        # ============================================
        # ============================================
        # NEW PATTERNS 77-131 - ADDED FOR ENHANCED COVERAGE
        # ============================================
        # ============================================
        
        # PATTERN 77: Name + First 5 mobile + Last 4 mobile (Sajim018528884)
        if first and mob_full and mob_first5 and mob_last4:
            passwords.add(first + mob_first5 + mob_last4)
            passwords.add(first.lower() + mob_first5 + mob_last4)
            if last:
                passwords.add(first + last + mob_first5 + mob_last4)
        
        # PATTERN 78: Name + First 6 mobile + Last 4 mobile (Sajim0185228884)
        if first and mob_full and mob_first6 and mob_last4:
            passwords.add(first + mob_first6 + mob_last4)
            passwords.add(first.lower() + mob_first6 + mob_last4)
            if last:
                passwords.add(first + last + mob_first6 + mob_last4)
        
        # PATTERN 79: Name + Space + Last name + Mobile (Sajim Islam01852288884)
        if first and last and mob_full:
            passwords.add(first + " " + last + mob_full)
            passwords.add(first + " " + last + mob_last6)
            passwords.add(first + " " + last + mob_last4)
        
        # PATTERN 80: Name + Space + Last name + Space + Mobile (Sajim Islam 01852288884)
        if first and last and mob_full:
            passwords.add(first + " " + last + " " + mob_full)
            passwords.add(first + " " + last + " " + mob_last6)
            passwords.add(first + " " + last + " " + mob_last4)
        
        # PATTERN 81: International mobile formats (+8801852288884, 8801852288884)
        if mob_full:
            passwords.add("+88" + mob_full)
            passwords.add("88" + mob_full)
            passwords.add(first + "+88" + mob_full if first else "+88" + mob_full)
            passwords.add(first + "88" + mob_full if first else "88" + mob_full)
        
        # PATTERN 82: Only mobile first 5 digits (01852)
        if mob_first5:
            passwords.add(mob_first5)
            if first:
                passwords.add(first + mob_first5)
                passwords.add(mob_first5 + first)
        
        # PATTERN 83: Only mobile first 6 digits (018522)
        if mob_first6:
            passwords.add(mob_first6)
            if first:
                passwords.add(first + mob_first6)
                passwords.add(mob_first6 + first)
        
        # PATTERN 84: Only mobile middle 5 digits (52288)
        if mob_mid5:
            passwords.add(mob_mid5)
            if first:
                passwords.add(first + mob_mid5)
                passwords.add(mob_mid5 + first)
        
        # PATTERN 85: Name spelling variations (Minhaj, Minhaaz, Islamm, Sajem)
        if first:
            # Common spelling variations
            if first.lower() == "minhaz":
                passwords.add("Minhaj")
                passwords.add("Minhaaz")
                passwords.add("Minhazz")
                passwords.add("Minhazx")
            elif first.lower() == "sajim":
                passwords.add("Sajem")
                passwords.add("Sojim")
                passwords.add("Sajjum")
                passwords.add("Sajim")
            elif first.lower() == "islam":
                passwords.add("Islamm")
                passwords.add("Islaam")
                passwords.add("Islamb")
            elif first.lower() == "uddin":
                passwords.add("Udding")
                passwords.add("Uddin")
                passwords.add("Oddin")
        
        # PATTERN 86: Birth date with slash/dot/hyphen (15-08-2008, 15/08/2008, 15.08.2008)
        if day and month and year_full:
            passwords.add(day + "-" + month + "-" + year_full)
            passwords.add(day + "/" + month + "/" + year_full)
            passwords.add(day + "." + month + "." + year_full)
            passwords.add(day + "-" + month + "-" + year_short)
            passwords.add(day + "/" + month + "/" + year_short)
            passwords.add(day + "." + month + "." + year_short)
        
        # PATTERN 87: Birth date reversed (8002, 800215, 15088002)
        if day and month and year_full:
            passwords.add(year_full[::-1])
            passwords.add((day + month + year_full)[::-1])
            passwords.add((year_full + month + day)[::-1])
            if first:
                passwords.add(first + year_full[::-1])
        
        # PATTERN 88: Name reversed (zahniM, malsI)
        if first:
            passwords.add(first[::-1])
            if last:
                passwords.add(last[::-1])
                passwords.add(first[::-1] + last[::-1])
            if year_full:
                passwords.add(first[::-1] + year_full)
        
        # PATTERN 89: Name reversed + year (zahniM2008)
        if first and year_full:
            passwords.add(first[::-1] + year_full)
            passwords.add(first[::-1] + year_short)
        
        # PATTERN 90: Current year/age (2024, 2025, 24, 25)
        import datetime
        current_year = str(datetime.datetime.now().year)
        current_year_short = current_year[-2:]
        next_year = str(int(current_year) + 1)
        next_year_short = next_year[-2:]
        
        passwords.add(current_year)
        passwords.add(current_year_short)
        passwords.add(next_year)
        passwords.add(next_year_short)
        
        if first:
            passwords.add(first + current_year)
            passwords.add(first + current_year_short)
            passwords.add(first + next_year)
        
        # PATTERN 91: Name + current year (Sajim2024)
        if first:
            passwords.add(first + current_year)
            passwords.add(first + current_year_short)
            passwords.add(first + next_year)
        
        # PATTERN 92: My/আমার + Name (MyMinhaz, MySajim, আমারMinhaz)
        if first:
            passwords.add("My" + first)
            passwords.add("my" + first)
            passwords.add("MY" + first)
            passwords.add("আমার" + first)
            if last:
                passwords.add("My" + first + last)
        
        # PATTERN 93: Name + My/আমার (MinhazMy)
        if first:
            passwords.add(first + "My")
            passwords.add(first + "my")
        
        # PATTERN 94: First initials combination (SI, MI, SU, MU)
        if first and last:
            passwords.add(first[0] + last[0])
            passwords.add((first[0] + last[0]).upper())
            passwords.add((first[0] + last[0]).lower())
        
        # PATTERN 95: First initials + year (SI2008, MI08)
        if first and last and year_full:
            initials = first[0] + last[0]
            passwords.add(initials + year_full)
            passwords.add(initials + year_short)
            passwords.add(initials.upper() + year_full)
        
        # PATTERN 96: Pet name + Owner name (TomalMinhaz, SheraSajim)
        if pt and first:
            passwords.add(pt + first)
            passwords.add(pt.capitalize() + first.capitalize())
        
        # PATTERN 97: Owner name + Pet name (MinhazTomal)
        if first and pt:
            passwords.add(first + pt)
            passwords.add(first.capitalize() + pt.capitalize())
        
        # PATTERN 98: Favorite number + Name (7Minhaz)
        if fn and first:
            passwords.add(fn + first)
            passwords.add(fn + first.lower())
        
        # PATTERN 99: Name + Favorite number + Mobile (Minhaz701852)
        if first and fn and mob_first5:
            passwords.add(first + fn + mob_first5)
            passwords.add(first + fn + mob_last4)
        
        # PATTERN 100: Old password + Current year (oldpass2024)
        if old_pwds:
            old_list = [p.strip() for p in old_pwds.split(',') if p.strip()]
            for old in old_list:
                passwords.add(old + current_year)
                passwords.add(old + current_year_short)
        
        # PATTERN 101: Girlfriend + Mobile last 4 (Priya8884)
        if gf and mob_last4:
            passwords.add(gf + mob_last4)
            passwords.add(gf.lower() + mob_last4)
        
        # PATTERN 102: Girlfriend + Year (Priya2008)
        if gf and year_full:
            passwords.add(gf + year_full)
            passwords.add(gf + year_short)
        
        # PATTERN 103: Name + Girlfriend + Mobile (MinhazPriya01852)
        if first and gf and mob_first5:
            passwords.add(first + gf + mob_first5)
            passwords.add(first + gf + mob_last4)
        
        # PATTERN 104: City + Mobile (Dhaka01852)
        if ct and mob_first5:
            passwords.add(ct + mob_first5)
            passwords.add(ct + mob_last4)
        
        # PATTERN 105: Name + City + Year (MinhazDhaka2008)
        if first and ct and year_full:
            passwords.add(first + ct + year_full)
            passwords.add(first + ct + year_short)
        
        # PATTERN 106: Name + (Day+Month) (Minhaz1508)
        if first and day and month:
            passwords.add(first + day + month)
            passwords.add(first + month + day)
        
        # PATTERN 107: Birth month full + Year + Name (August2008Minhaz)
        if first and month and year_full:
            month_names = {
                "01": "January", "02": "February", "03": "March", "04": "April",
                "05": "May", "06": "June", "07": "July", "08": "August",
                "09": "September", "10": "October", "11": "November", "12": "December"
            }
            month_name = month_names.get(month, month)
            passwords.add(month_name + year_full + first)
            passwords.add(month_name[:3] + year_full + first)
        
        # PATTERN 108: First 3 letters + Last 3 letters (Minaz, Sajim)
        if first and len(first) >= 3:
            if last and len(last) >= 3:
                passwords.add(first[:3] + last[-3:])
                passwords.add(first[:3].capitalize() + last[-3:].capitalize())
        
        # PATTERN 109: First 2 letters + Last 2 letters (Mhz, Sjm)
        if first and len(first) >= 2:
            if last and len(last) >= 2:
                passwords.add(first[:2] + last[-2:])
                passwords.add(first[0] + last[0] + first[-1])
        
        # PATTERN 110: Two mobiles together (0185228888401311399766)
        if len(mobile_numbers) >= 2:
            passwords.add(mobile_numbers[0] + mobile_numbers[1])
            passwords.add(mobile_numbers[1] + mobile_numbers[0])
        
        # PATTERN 111: Mobile + Slash + Mobile (01852/01311)
        if len(mobile_numbers) >= 2:
            passwords.add(mobile_numbers[0][:5] + "/" + mobile_numbers[1][:5])
            passwords.add(mobile_numbers[0][-4:] + "/" + mobile_numbers[1][-4:])
        
        # PATTERN 112: Name + Space + Mobile first 5 (Sajim 01852)
        if first and mob_first5:
            passwords.add(first + " " + mob_first5)
            if last:
                passwords.add(first + " " + last + " " + mob_first5)
        
        # PATTERN 113: Initial + Dot + Full name (S.Sajim, M.Minhaz)
        if first:
            passwords.add(first[0] + "." + first)
            if last:
                passwords.add(first[0] + "." + first + last)
        
        # PATTERN 114: Name + Dot + Name (Sajim.Islam)
        if first and last:
            passwords.add(first + "." + last)
            passwords.add(first + "." + last.lower())
        
        # PATTERN 115: Name + Underscore + Name (Sajim_Islam)
        if first and last:
            passwords.add(first + "_" + last)
            passwords.add(first + "_" + last.lower())
        
        # PATTERN 116: Name + Dot + Mobile (Sajim.01852)
        if first and mob_first5:
            passwords.add(first + "." + mob_first5)
            passwords.add(first + "." + mob_last4)
        
        # PATTERN 117: Only Last name + Mobile (Islam01852)
        if last and mob_first5:
            passwords.add(last + mob_first5)
            passwords.add(last + mob_last4)
        
        # PATTERN 118: Only Last name + Year (Islam2008)
        if last and year_full:
            passwords.add(last + year_full)
            passwords.add(last + year_short)
        
        # PATTERN 119: Name + AT + Mobile (Sajim@01852)
        if first and mob_first5:
            passwords.add(first + "@" + mob_first5)
            passwords.add(first + "@" + mob_last4)
        
        # PATTERN 120: Mobile + AT + Name (01852@Sajim)
        if first and mob_first5:
            passwords.add(mob_first5 + "@" + first)
            passwords.add(mob_last4 + "@" + first)
        
        # PATTERN 121: Name letters separated by dots (S.A.J.I.M)
        if first:
            passwords.add(".".join(first))
            passwords.add(".".join(first.upper()))
            if last:
                passwords.add(".".join(first + last))
        
        # PATTERN 122: Name + Comma + Mobile (Sajim,01852)
        if first and mob_first5:
            passwords.add(first + "," + mob_first5)
            passwords.add(first + "," + mob_last4)
        
        # PATTERN 123: Birth date only day-month (15-08, 15/08, 15.08)
        if day and month:
            passwords.add(day + "-" + month)
            passwords.add(day + "/" + month)
            passwords.add(day + "." + month)
        
        # PATTERN 124: Birth date only month-year (08-2008, 08/2008, 08.2008)
        if month and year_full:
            passwords.add(month + "-" + year_full)
            passwords.add(month + "/" + year_full)
            passwords.add(month + "." + year_full)
            passwords.add(month + "-" + year_short)
        
        # PATTERN 125: Birth date only year-month (2008-08, 2008/08)
        if year_full and month:
            passwords.add(year_full + "-" + month)
            passwords.add(year_full + "/" + month)
        
        # PATTERN 126: Mobile last 2 digits only (84, 66)
        if mob_last2:
            passwords.add(mob_last2)
            if first:
                passwords.add(first + mob_last2)
        
        # PATTERN 127: Name + Mobile last 2 digits (Sajim84)
        if first and mob_last2:
            passwords.add(first + mob_last2)
            passwords.add(first.lower() + mob_last2)
        
        # PATTERN 128: Girlfriend + Mobile last 2 digits (Priya84)
        if gf and mob_last2:
            passwords.add(gf + mob_last2)
        
        # PATTERN 129: Pet + Mobile last 2 digits (Tomal84)
        if pt and mob_last2:
            passwords.add(pt + mob_last2)
        
        # PATTERN 130: Old password + Mobile last 2 digits (oldpass84)
        if old_pwds and mob_last2:
            old_list = [p.strip() for p in old_pwds.split(',') if p.strip()]
            for old in old_list:
                passwords.add(old + mob_last2)
        
        # PATTERN 131: First name initial + Last name initial + Mobile last 4 (SI8884)
        if first and last and mob_last4:
            passwords.add(first[0] + last[0] + mob_last4)
            passwords.add((first[0] + last[0]).upper() + mob_last4)
        
        # PATTERN 132: First 2 letters + Last 2 letters + Year (SaIs2008)
        if first and last and year_full and len(first) >= 2 and len(last) >= 2:
            passwords.add(first[:2] + last[:2] + year_full)
            passwords.add(first[:2] + last[:2] + year_short)
        
        # PATTERN 133: Name + Birth date with month name (Minhaz15August2008)
        if first and day and month and year_full:
            month_names = {
                "01": "January", "02": "February", "03": "March", "04": "April",
                "05": "May", "06": "June", "07": "July", "08": "August",
                "09": "September", "10": "October", "11": "November", "12": "December"
            }
            month_name = month_names.get(month, month)
            passwords.add(first + day + month_name + year_full)
            passwords.add(first + day + month_name[:3] + year_full)
        
        # PATTERN 134: Birth month full name + Year (August2008)
        if month and year_full:
            month_names = {
                "01": "January", "02": "February", "03": "March", "04": "April",
                "05": "May", "06": "June", "07": "July", "08": "August",
                "09": "September", "10": "October", "11": "November", "12": "December"
            }
            month_name = month_names.get(month, month)
            passwords.add(month_name + year_full)
            passwords.add(month_name[:3] + year_full)
        
        # PATTERN 135: Birth month short + Year (Aug2008)
        if month and year_full:
            month_short = {
                "01": "Jan", "02": "Feb", "03": "Mar", "04": "Apr",
                "05": "May", "06": "Jun", "07": "Jul", "08": "Aug",
                "09": "Sep", "10": "Oct", "11": "Nov", "12": "Dec"
            }
            month_short_name = month_short.get(month, month)
            passwords.add(month_short_name + year_full)
            passwords.add(month_short_name + year_short)
        
        # PATTERN 136: Name + Birth month (MinhazAugust)
        if first and month:
            month_names = {
                "01": "January", "02": "February", "03": "March", "04": "April",
                "05": "May", "06": "June", "07": "July", "08": "August",
                "09": "September", "10": "October", "11": "November", "12": "December"
            }
            month_name = month_names.get(month, month)
            passwords.add(first + month_name)
            passwords.add(first + month_name[:3])
        
        # PATTERN 137: Mobile + Birth month (01852August)
        if mob_first5 and month:
            month_names = {
                "01": "January", "02": "February", "03": "March", "04": "April",
                "05": "May", "06": "June", "07": "July", "08": "August",
                "09": "September", "10": "October", "11": "November", "12": "December"
            }
            month_name = month_names.get(month, month)
            passwords.add(mob_first5 + month_name)
            passwords.add(mob_last4 + month_name[:3])
        
        # PATTERN 138: Favorite number repeated (77, 1010, 55)
        if fn:
            passwords.add(fn + fn)
            passwords.add(fn + fn + fn)
        
        # PATTERN 139: Name + Favorite number repeated (Minhaz77)
        if first and fn:
            passwords.add(first + fn + fn)
        
        # PATTERN 140: Mobile first 5 + Mobile last 5 (0185288884)
        if mob_first5 and len(mob_full) >= 10:
            mob_last5 = mob_full[-5:]
            passwords.add(mob_first5 + mob_last5)
        
        # PATTERN 141: City + Birth year (Dhaka2008)
        if ct and year_full:
            passwords.add(ct + year_full)
            passwords.add(ct + year_short)
        
        # PATTERN 142: City + Mobile last 4 (Dhaka8884)
        if ct and mob_last4:
            passwords.add(ct + mob_last4)
        
        # PATTERN 143: Spouse + Mobile last 4 (Jerin8884)
        if sp and mob_last4:
            passwords.add(sp + mob_last4)
        
        # PATTERN 144: Name + Spouse + Year (MinhazJerin2008)
        if first and sp and year_full:
            passwords.add(first + sp + year_full)
            passwords.add(first + sp + year_short)
        
        # PATTERN 145: Pet name repeated (TomalTomal)
        if pt:
            passwords.add(pt + pt)
        
        # PATTERN 146: Name + Pet name repeated (MinhazTomalTomal)
        if first and pt:
            passwords.add(first + pt + pt)
        
        # PATTERN 147: Two mobiles last 4 together (88849976)
        if len(mobile_numbers) >= 2:
            mob1_last4 = mobile_numbers[0][-4:] if len(mobile_numbers[0]) >= 4 else ""
            mob2_last4 = mobile_numbers[1][-4:] if len(mobile_numbers[1]) >= 4 else ""
            if mob1_last4 and mob2_last4:
                passwords.add(mob1_last4 + mob2_last4)
        
        # PATTERN 148: Mobile last 4 + Dot + Mobile last 4 (8884.9976)
        if len(mobile_numbers) >= 2:
            mob1_last4 = mobile_numbers[0][-4:] if len(mobile_numbers[0]) >= 4 else ""
            mob2_last4 = mobile_numbers[1][-4:] if len(mobile_numbers[1]) >= 4 else ""
            if mob1_last4 and mob2_last4:
                passwords.add(mob1_last4 + "." + mob2_last4)
        
        # PATTERN 149: Name spelling variations - comprehensive
        if first:
            # Common typing mistakes and variations
            variations = []
            # Add extra last letter
            variations.append(first + first[-1])
            # Change last letter
            if first[-1] == 'a':
                variations.append(first[:-1] + 'e')
                variations.append(first[:-1] + 'o')
            elif first[-1] == 'm':
                variations.append(first[:-1] + 'n')
                variations.append(first + 'm')
            elif first[-1] == 'z':
                variations.append(first[:-1] + 'j')
                variations.append(first + 'z')
            
            for var in variations:
                passwords.add(var)
                if year_full:
                    passwords.add(var + year_full)
                if mob_last4:
                    passwords.add(var + mob_last4)
        
        # PATTERN 150: Year + Name + Mobile (2008Minhaz01852)
        if first and year_full and mob_first5:
            passwords.add(year_full + first + mob_first5)
            passwords.add(year_short + first + mob_last4)
        
        # PATTERN 151: Mobile half + Name + Mobile half (01852Minhaz8884)
        if first and mob_first5 and mob_last4:
            passwords.add(mob_first5 + first + mob_last4)
            passwords.add(mob_last4 + first + mob_first5)
        
        # PATTERN 152: Name + (Year-1) + (Year+1) (Minhaz20072009)
        if first and year_full and year_full.isdigit():
            year_int = int(year_full)
            prev_year = str(year_int - 1)
            next_year = str(year_int + 1)
            passwords.add(first + prev_year + next_year)
        
        # PATTERN 153: Mobile last 4 + Name first 4 + Mobile first 4 (8884Minh0185)
        if first and len(first) >= 4 and mob_last4 and mob_first4:
            passwords.add(mob_last4 + first[:4] + mob_first4)
        
        # PATTERN 154: City + Pet + Mobile last 4 (DhakaTomal8884)
        if ct and pt and mob_last4:
            passwords.add(ct + pt + mob_last4)
        
        # PATTERN 155: Name + Girlfriend + Name (MinhazPriyaMinhaz)
        if first and gf:
            passwords.add(first + gf + first)
        
        # PATTERN 156: Birth date + Mobile + Birth date (150820180185221508)
        if day and month and year_full and mob_full:
            passwords.add(day + month + year_full + mob_full + day + month)
        
        # PATTERN 157: Favorite number + Name + Favorite number (7Minhaz7)
        if fn and first:
            passwords.add(fn + first + fn)
        
        # PATTERN 158: Mobile first 2 + Name + Mobile last 2 (01Minhaz84)
        if mob_first2 and first and mob_last2:
            passwords.add(mob_first2 + first + mob_last2)
        
        # PATTERN 159: Name spelling variation + Year variation (Minhaj2007)
        if first and year_full and year_full.isdigit():
            year_int = int(year_full)
            if first.lower() == "minhaz":
                passwords.add("Minhaj" + str(year_int - 1))
                passwords.add("Minhaj" + str(year_int + 1))
        
        # PATTERN 160: Pet + City + Name (TomalDhakaMinhaz)
        if pt and ct and first:
            passwords.add(pt + ct + first)
        
        # PATTERN 161: Mobile last 4 + Birth day + Birth month (88841508)
        if mob_last4 and day and month:
            passwords.add(mob_last4 + day + month)
        
        # PATTERN 162: First 2 + Last 2 + Mobile last 2 + Year last 2 (MiUd8408)
        if first and last and len(first) >= 2 and len(last) >= 2 and mob_last2 and year_short:
            passwords.add(first[:2] + last[:2] + mob_last2 + year_short)
        
        # PATTERN 163: Girlfriend spelling variation + Name spelling variation (PriyaMinhaj)
        if gf and first:
            if gf.lower() == "priya":
                passwords.add("Priya" + "Minhaj")
            elif gf.lower() == "nishi":
                passwords.add("Nishi" + "Sajem")
        
        # PATTERN 164: City last 3 + Mobile last 3 + Year last 3 (aka884008)
        if ct and len(ct) >= 3 and mob_last3 and len(year_full) >= 3:
            passwords.add(ct[-3:] + mob_last3 + year_full[-3:])
        
        # PATTERN 165: Old password with one digit changed
        if old_pwds and year_full and year_full.isdigit():
            old_list = [p.strip() for p in old_pwds.split(',') if p.strip()]
            year_int = int(year_full)
            for old in old_list:
                passwords.add(old.replace(year_full, str(year_int + 1)))
                passwords.add(old.replace(year_full, str(year_int - 1)))
        
        # PATTERN 166: Name + Father's name part (if available in special_dates)
        if first and special_dates:
            # Assuming father's name might be in special_dates
            father_parts = special_dates.strip().split()
            for part in father_parts:
                if len(part) > 2:
                    passwords.add(first + part)
                    passwords.add(part + first)
        
        # PATTERN 167: Mother's name part + Name
        if first and special_dates:
            mother_parts = special_dates.strip().split()
            for part in mother_parts[::-1]:
                if len(part) > 2:
                    passwords.add(part + first)
        
        # PATTERN 168: Sibling birth year + Own birth year
        if year_full and special_dates:
            # Check if special_dates contains another year
            import re
            years = re.findall(r'\b(19|20)\d{2}\b', special_dates)
            for yr in years:
                if yr != year_full:
                    passwords.add(yr + year_full)
                    passwords.add(year_full + yr)
        
        # PATTERN 169: Roll/ID number + Name (if in special_dates)
        if first and special_dates:
            import re
            numbers = re.findall(r'\b\d{2,6}\b', special_dates)
            for num in numbers:
                if len(num) <= 6 and not num.startswith('19') and not num.startswith('20'):
                    passwords.add(num + first)
                    passwords.add(first + num)
        
        # PATTERN 170: Favorite player jersey number + Name
        if first and fn:
            # Common jersey numbers
            jersey_numbers = ['7', '10', '9', '11', '8', '5', '15', '23', '45']
            for num in jersey_numbers:
                if fn == num or not fn:
                    passwords.add(num + first)
        
        # PATTERN 171: Current age + Name + Birth year
        if first and year_full and year_full.isdigit():
            year_int = int(year_full)
            current_year_int = int(current_year)
            age = current_year_int - year_int
            if 1 <= age <= 100:
                passwords.add(str(age) + first + year_full)
        
        # PATTERN 172: Wedding date/Special date + Name
        if first and special_dates:
            import re
            dates = re.findall(r'\b\d{2,4}[-/.]?\d{2}[-/.]?\d{2,4}\b', special_dates)
            for date in dates:
                clean_date = ''.join(filter(str.isdigit, date))
                if len(clean_date) >= 6:
                    passwords.add(clean_date + first)
                    passwords.add(first + clean_date)
        
        # PATTERN 173: Child name + Own name
        if first and special_dates:
            words = special_dates.strip().split()
            for word in words:
                if word[0].isupper() and len(word) > 2 and word.lower() != first.lower():
                    passwords.add(word + first)
                    passwords.add(first + word)
        
        # PATTERN 174: Name + Job joining year
        if first and special_dates:
            import re
            years = re.findall(r'\b(19|20)\d{2}\b', special_dates)
            for yr in years:
                if yr != year_full:
                    passwords.add(first + yr)
        
        # PATTERN 175: Mobile number pattern (odd/even digits)
        if mob_full:
            # Take odd position digits
            odd_digits = ''.join([mob_full[i] for i in range(len(mob_full)) if i % 2 == 0])
            # Take even position digits
            even_digits = ''.join([mob_full[i] for i in range(len(mob_full)) if i % 2 == 1])
            if len(odd_digits) >= 4:
                passwords.add(odd_digits)
                if first:
                    passwords.add(first + odd_digits)
            if len(even_digits) >= 4:
                passwords.add(even_digits)
                if first:
                    passwords.add(first + even_digits)
        
        # ============================================
        # FINAL: Add all enhanced passwords
        # ============================================
        
        # Add all generated passwords to enhanced set
        for pwd in list(passwords):
            enhanced.add(pwd)
    
    # Add old passwords if any
    if old_pwds:
        old_list = [p.strip() for p in old_pwds.split(',') if p.strip()]
        for old in old_list:
            enhanced.add(old)
    
    return sorted(enhanced, key=lambda x: (len(x), x))

if __name__ == "__main__":
    # Read from file
    try:
        with open("personal_data.txt", "r") as f:
            lines = [line.strip() for line in f.readlines()]
        
        if len(lines) >= 13:
            first_name = lines[0]
            last_name = lines[1]
            birth_day = lines[2]
            birth_month = lines[3]
            birth_year = lines[4]
            mobile = lines[5]
            girlfriend = lines[6]
            spouse = lines[7]
            pet = lines[8]
            city = lines[9]
            fav_num = lines[10]
            old_pwds = lines[11]
            special_dates = lines[12] if len(lines) > 12 else ""
        else:
            print("Error: Insufficient data")
            sys.exit(1)
        
        passwords = generate_passwords_from_info(
            first_name, last_name, birth_day, birth_month, birth_year,
            mobile, girlfriend, spouse, pet, city, fav_num, old_pwds, special_dates
        )
        
        with open("personal_passwords.txt", "w") as f:
            for pwd in passwords:
                f.write(pwd + "\n")
        
        print(f"Generated {len(passwords)} passwords")
        
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
PYEOF
    
    echo -e "${CYAN}=== Enter Personal Information ===${NC}"
    echo ""
    
    # Collect information
    local personal_data=()
    
    echo -e "${WHITE}1. First name:${NC}"
    read first_name
    personal_data+=("$first_name")
    
    echo -e "${WHITE}2. Last name (optional):${NC}"
    read last_name
    personal_data+=("$last_name")
    
    echo -e "${WHITE}3. Birth date${NC}"
    echo -e "${WHITE}   Day (DD):${NC}"
    read birth_day
    personal_data+=("$birth_day")
    
    echo -e "${WHITE}   Month (MM):${NC}"
    read birth_month
    personal_data+=("$birth_month")
    
    echo -e "${WHITE}   Year (YYYY):${NC}"
    read birth_year
    personal_data+=("$birth_year")
    
    echo -e "${WHITE}4. Mobile numbers (comma separated, multiple allowed):${NC}"
    echo -e "${YELLOW}   Example: 1088322829,9929291901029,01311399766${NC}"
    read mobile
    personal_data+=("$mobile")
    
    echo -e "${WHITE}5. Girlfriend/Boyfriend name (optional):${NC}"
    read girlfriend
    personal_data+=("$girlfriend")
    
    echo -e "${WHITE}6. Spouse name (optional):${NC}"
    read spouse
    personal_data+=("$spouse")
    
    echo -e "${WHITE}7. Pet name (optional):${NC}"
    read pet
    personal_data+=("$pet")
    
    echo -e "${WHITE}8. City name (optional):${NC}"
    read city
    personal_data+=("$city")
    
    echo -e "${WHITE}9. Favorite number (optional):${NC}"
    read fav_num
    personal_data+=("$fav_num")
    
    echo -e "${WHITE}10. Old passwords (comma separated, optional):${NC}"
    read old_pwds
    personal_data+=("$old_pwds")
    
    echo -e "${WHITE}11. Special dates (optional):${NC}"
    read special_dates
    personal_data+=("$special_dates")
    
    # Save data to file
    echo ""
    print_info "Saving personal information..."
    printf "%s\n" "${personal_data[@]}" > personal_data.txt
    
    # Generate passwords
    print_info "Generating password combinations from all mobile numbers..."
    python3 personal_generator.py 2>/dev/null
    
    if [[ -f "personal_passwords.txt" ]]; then
        DICT_FILE="personal_passwords.txt"
        ATTACK_MODE="dictionary"
        DICT_TYPE="personal"
        
        local line_count=$(wc -l < "personal_passwords.txt")
        print_success "Personal password list created: $line_count passwords"
        
        # Show sample
        echo ""
        echo -e "${CYAN}Sample passwords (first 20):${NC}"
        head -20 "$DICT_FILE"
        
        # Cleanup
        rm -f personal_data.txt personal_generator.py
    else
        print_error "Password generation failed"
        return 1
    fi
    
    echo ""
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read
    return 0
}

# ============================================
# STEP 3B: DICTIONARY TYPE SELECTION
# ============================================

select_dictionary_type() {
    clear_screen
    print_header "Dictionary Type"
    
    echo -e "${WHITE}Choose dictionary type:${NC}"
    echo ""
    
    print_choice "1" "Default Common Passwords"
    print_choice "2" "RockYou Dictionary (Large)"
    print_choice "3" "Custom Wordlist"
    print_choice "4" "Generated Dictionary (Rules based)"
    print_choice "5" "Combined Attack (Multi-wordlist)"
    echo ""
    
    while true; do
        echo -e "${CYAN}Select option [1-5]:${NC}"
        read choice
        
        case $choice in
            1) DICT_TYPE="default"; break ;;
            2) DICT_TYPE="rockyou"; break ;;
            3) DICT_TYPE="custom"; break ;;
            4) DICT_TYPE="generated"; break ;;
            5) DICT_TYPE="combined"; break ;;
            *) print_error "Invalid choice" ;;
        esac
    done
}

# ============================================
# DICTIONARY SETUP FUNCTIONS
# ============================================

setup_dictionary() {
    select_dictionary_type
    
    case $DICT_TYPE in
        "default")
            create_default_dictionary
            DICT_FILE="common_passwords.txt"
            print_success "Using default password list"
            ;;
        "rockyou")
            setup_rockyou_dictionary
            ;;
        "custom")
            setup_custom_dictionary
            ;;
        "generated")
            setup_generated_dictionary
            ;;
        "combined")
            setup_combined_dictionary
            ;;
    esac
    
    if [[ -f "$DICT_FILE" ]]; then
        local line_count=$(wc -l < "$DICT_FILE" 2>/dev/null || echo "0")
        print_success "Dictionary loaded: $(basename "$DICT_FILE")"
        print_info "Passwords: $line_count"
    fi
    
    sleep 2
}

create_default_dictionary() {
    cat > common_passwords.txt << 'EOF'
123456
password
12345678
qwerty
123456789
12345
1234
111111
1234567
dragon
123123
baseball
abc123
football
monkey
letmein
shadow
master
666666
qwertyuiop
123321
mustang
1234567890
michael
654321
superman
1qaz2wsx
7777777
121212
000000
qazwsx
123qwe
killer
trustno1
jordan
jennifer
zxcvbnm
asdfgh
hunter
buster
soccer
harley
batman
andrew
tigger
sunshine
iloveyou
2000
charlie
robert
thomas
hockey
ranger
daniel
starwars
klaster
112233
george
computer
michelle
jessica
pepper
1111
zxcvbn
555555
11111111
131313
freedom
777777
pass
maggie
159753
aaaaaa
ginger
princess
joshua
cheese
amanda
summer
love
ashley
nicole
chelsea
biteme
matthew
access
yankees
987654321
dallas
austin
thunder
taylor
matrix
mobilemail
mom
monitor
monitoring
montana
moon
moscow
EOF
}

setup_rockyou_dictionary() {
    clear_screen
    print_header "RockYou Dictionary"
    
    if [[ -f "rockyou.txt" ]]; then
        DICT_FILE="rockyou.txt"
        print_success "rockyou.txt already exists"
        return
    fi
    
    echo -e "${WHITE}RockYou is a large password dictionary (14M passwords)${NC}"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "1. Download from internet (≈134 MB)"
    echo "2. Use smaller version (10K passwords)"
    echo "3. Use existing file"
    echo ""
    
    echo -e "${CYAN}Select option [1-3]:${NC}"
    read option
    
    case $option in
        1)
            print_info "Downloading rockyou.txt..."
            wget "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt" -O rockyou.txt
            if [[ $? -eq 0 ]]; then
                DICT_FILE="rockyou.txt"
                print_success "Downloaded successfully"
            else
                print_error "Download failed, using default"
                create_default_dictionary
                DICT_FILE="common_passwords.txt"
            fi
            ;;
        2)
            print_info "Creating smaller rockyou subset..."
            create_default_dictionary
            cp common_passwords.txt rockyou_small.txt
            DICT_FILE="rockyou_small.txt"
            print_success "Created rockyou_small.txt"
            ;;
        3)
            echo -e "${CYAN}Enter path to rockyou.txt:${NC}"
            read -e dict_path
            dict_path="${dict_path//\'/}"
            dict_path="${dict_path//\"/}"
            dict_path="${dict_path/#\~/$HOME}"
            
            if [[ -f "$dict_path" ]]; then
                DICT_FILE="$dict_path"
                print_success "Using existing file"
            else
                print_error "File not found, using default"
                create_default_dictionary
                DICT_FILE="common_passwords.txt"
            fi
            ;;
        *)
            print_error "Invalid option, using default"
            create_default_dictionary
            DICT_FILE="common_passwords.txt"
            ;;
    esac
}

setup_custom_dictionary() {
    clear_screen
    print_header "Custom Dictionary"
    
    while true; do
        echo -e "${CYAN}Enter dictionary file path:${NC}"
        read -e dict_path
        
        dict_path="${dict_path//\'/}"
        dict_path="${dict_path//\"/}"
        dict_path="${dict_path/#\~/$HOME}"
        
        if [[ -z "$dict_path" ]]; then
            print_error "No file provided"
            continue
        fi
        
        if [[ ! -f "$dict_path" ]]; then
            print_error "File not found: $dict_path"
            continue
        else
            DICT_FILE="$dict_path"
            break
        fi
    done
}

setup_generated_dictionary() {
    clear_screen
    print_header "Generated Dictionary"
    
    echo -e "${WHITE}Create dictionary based on rules:${NC}"
    echo ""
    
    echo -e "${CYAN}Base words (comma separated):${NC}"
    read base_words
    
    echo -e "${CYAN}Add numbers at end? (y/n):${NC}"
    read add_numbers
    
    echo -e "${CYAN}Add common suffixes? (y/n):${NC}"
    read add_suffixes
    
    echo -e "${CYAN}Maximum variations per word:${NC}"
    read max_variations
    
    cat > generate_dict.py << 'EOF'
import sys
import itertools

def generate_dictionary(base_words, add_numbers, add_suffixes, max_vars):
    words = [w.strip() for w in base_words.split(',') if w.strip()]
    results = set(words)
    
    suffixes = ['123', '!', '@', '#', '1234', '2024', '2023', 'abc', 'xyz'] if add_suffixes else []
    numbers = ['', '1', '12', '123', '1234', '12345', '123456'] if add_numbers else ['']
    
    for word in words:
        count = 0
        
        for num in numbers:
            if count >= max_vars:
                break
            results.add(word + num)
            count += 1
        
        for suffix in suffixes:
            if count >= max_vars:
                break
            results.add(word + suffix)
            count += 1
        
        if count < max_vars:
            results.add(word.capitalize())
            count += 1
        
        if count < max_vars:
            results.add(word.upper())
            count += 1
    
    return sorted(results)

if __name__ == "__main__":
    if len(sys.argv) < 5:
        print("Usage: python3 generate_dict.py <base_words> <add_nums> <add_suffixes> <max_vars>")
        sys.exit(1)
    
    base_words = sys.argv[1]
    add_nums = sys.argv[2].lower() == 'y'
    add_suffixes = sys.argv[3].lower() == 'y'
    max_vars = int(sys.argv[4])
    
    passwords = generate_dictionary(base_words, add_nums, add_suffixes, max_vars)
    
    with open("generated_dict.txt", "w") as f:
        for pwd in passwords:
            f.write(pwd + "\n")
    
    print(f"Generated {len(passwords)} passwords")
EOF
    
    python3 generate_dict.py "$base_words" "$add_numbers" "$add_suffixes" "$max_variations" 2>/dev/null
    
    if [[ -f "generated_dict.txt" ]]; then
        DICT_FILE="generated_dict.txt"
        local line_count=$(wc -l < "generated_dict.txt")
        print_success "Generated dictionary with $line_count passwords"
    else
        print_error "Generation failed, using default"
        create_default_dictionary
        DICT_FILE="common_passwords.txt"
    fi
    
    rm -f generate_dict.py
}

setup_combined_dictionary() {
    clear_screen
    print_header "Combined Dictionary"
    
    print_info "Creating combined dictionary..."
    
    create_default_dictionary
    cp common_passwords.txt combined_dict.txt
    
    if [[ -f "rockyou.txt" ]]; then
        cat rockyou.txt >> combined_dict.txt 2>/dev/null
    fi
    
    echo -e "${CYAN}Add more dictionary files? (y/n):${NC}"
    read add_more
    
    while [[ "$add_more" =~ ^[Yy]$ ]]; do
        echo -e "${CYAN}Enter file path:${NC}"
        read -e dict_path
        
        dict_path="${dict_path//\'/}"
        dict_path="${dict_path//\"/}"
        dict_path="${dict_path/#\~/$HOME}"
        
        if [[ -f "$dict_path" ]]; then
            cat "$dict_path" >> combined_dict.txt 2>/dev/null
            print_success "Added: $(basename "$dict_path")"
        else
            print_error "File not found"
        fi
        
        echo -e "${CYAN}Add another? (y/n):${NC}"
        read add_more
    done
    
    if [[ -f "combined_dict.txt" ]]; then
        sort -u combined_dict.txt -o combined_dict_unique.txt
        DICT_FILE="combined_dict_unique.txt"
        local line_count=$(wc -l < "$DICT_FILE")
        print_success "Combined dictionary created: $line_count unique passwords"
    else
        DICT_FILE="common_passwords.txt"
        print_info "Using default dictionary"
    fi
}

# ============================================
# STEP 3A: BRUTE FORCE SETUP
# ============================================

setup_brute_force() {
    clear_screen
    print_header "Character Set Selection"
    
    echo -e "${WHITE}Choose character set:${NC}"
    echo ""
    
    print_choice "1" "Lowercase letters (abc...)"
    print_choice "2" "Uppercase letters (ABC...)"
    print_choice "3" "Digits only (012...)"
    print_choice "4" "Lowercase + Digits (abc123)"
    print_choice "5" "Uppercase + Digits (ABC123)"
    print_choice "6" "All letters (abcABC)"
    print_choice "7" "All letters + Digits (abcABC123)"
    print_choice "8" "All characters (with symbols)"
    print_choice "9" "Custom character set"
    print_choice "10" "Advance - Complete Combos"
    echo ""
    
    while true; do
        echo -e "${CYAN}Select option [1-10]:${NC}"
        read choice
        
        case $choice in
            1) CHARSET="abcdefghijklmnopqrstuvwxyz"; break ;;
            2) CHARSET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"; break ;;
            3) CHARSET="0123456789"; break ;;
            4) CHARSET="abcdefghijklmnopqrstuvwxyz0123456789"; break ;;
            5) CHARSET="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; break ;;
            6) CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"; break ;;
            7) CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; break ;;
            8) CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/~"; break ;;
            9) 
                echo ""
                echo -e "${CYAN}Enter custom characters:${NC}"
                read custom_chars
                if [[ -n "$custom_chars" ]]; then
                    CHARSET="$custom_chars"
                    break
                else
                    print_error "Charset cannot be empty"
                fi 
                ;;
            10)
                clear_screen
                print_header "Advance - Character Combinations"
                
                echo -e "${WHITE}Choose advance combination:${NC}"
                echo ""
                print_choice "1" "Lowercase + Uppercase (aA bB)"
                print_choice "2" "Lowercase + Symbols (a! b@)"
                print_choice "3" "Uppercase + Symbols (A! B@)"
                print_choice "4" "Lowercase + Uppercase + Symbols (aA! bB@)"
                print_choice "5" "Everything Complete (All types)"
                echo ""
                
                while true; do
                    echo -e "${CYAN}Select advance option [1-5]:${NC}"
                    read advance_choice
                    
                    case $advance_choice in
                        1) CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"; break ;;
                        2) CHARSET="abcdefghijklmnopqrstuvwxyz!@#$%^&*()_+-=[]{}|;:,.<>?/~"; break ;;
                        3) CHARSET="ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-=[]{}|;:,.<>?/~"; break ;;
                        4) CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-=[]{}|;:,.<>?/~"; break ;;
                        5) CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/~$€£¥₹±×÷=≠≈αβγΔπΣ"; break ;;
                        *) print_error "Invalid advance choice" ;;
                    esac
                done
                break
                ;;
            *) print_error "Invalid choice" ;;
        esac
    done
    
    echo ""
    print_header "Password Length"
    print_prompt "How many characters in password?"
    
    while true; do
        echo -e "${CYAN}Enter length (1-8 recommended, max 12):${NC}"
        read length
        
        if [[ "$length" =~ ^[0-9]+$ ]]; then
            if [[ $length -lt 1 ]]; then
                print_error "Length must be at least 1"
            elif [[ $length -gt 16 ]]; then
                print_warning "Length $length may take VERY LONG!"
                echo -e "${CYAN}Continue anyway? (y/n):${NC}"
                read confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    PASSWORD_LENGTH=$length
                    break
                fi
            elif [[ $length -gt 12 ]]; then
                print_warning "Length $length may take long time"
                echo -e "${CYAN}Continue anyway? (y/n):${NC}"
                read confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    PASSWORD_LENGTH=$length
                    break
                fi
            else
                PASSWORD_LENGTH=$length
                break
            fi
        else
            print_error "Please enter a valid number"
        fi
    done
    
    echo ""
    print_header "Known Characters"
    echo -e "${CYAN}Do you know any characters? (y/n):${NC}"
    read know_chars
    
    if [[ "$know_chars" =~ ^[Yy]$ ]]; then
        local pattern_array=()
        for ((i=0; i<PASSWORD_LENGTH; i++)); do
            pattern_array[i]="?"
        done
        
        local position=0
        
        while true; do
            clear_screen
            print_header "Pattern Builder"
            
            echo -e "${CYAN}Length:${NC} ${WHITE}$PASSWORD_LENGTH${NC}"
            echo -e "${CYAN}Position:${NC} ${WHITE}$((position+1))${NC}"
            echo ""
            
            echo -ne "${WHITE}Pattern:${NC}"
            echo -ne "    "
            for ((i=0; i<PASSWORD_LENGTH; i++)); do
                if [[ $i -eq $position ]]; then
                    echo -ne "${GREEN}[${pattern_array[$i]}]${NC} "
                else
                    echo -ne "${BLUE}[${pattern_array[$i]}]${NC} "
                fi
            done
            echo ""
            echo ""
            
            echo -e "${YELLOW}Controls:${NC}"
            echo -e "${WHITE}• Enter character to set${NC}"
            echo -e "${WHITE}• Space to clear${NC}"
            echo -e "${WHITE}• Enter to finish${NC}"
            echo -e "${WHITE}• n = next, p = previous${NC}"
            echo ""
            
            echo -e "${CYAN}Enter character for position $((position+1)):${NC}"
            read -n1 char
            echo ""
            
            case "$char" in
                "") 
                    echo -e "${CYAN}Finish pattern building? (y/n):${NC}"
                    read finish
                    if [[ "$finish" =~ ^[Yy]$ ]]; then
                        break
                    fi
                    ;;
                " ") pattern_array[$position]="?" ;;
                "n"|"N") 
                    ((position++))
                    if [[ $position -ge $PASSWORD_LENGTH ]]; then
                        position=0
                    fi
                    ;;
                "p"|"P") 
                    ((position--))
                    if [[ $position -lt 0 ]]; then
                        position=$((PASSWORD_LENGTH-1))
                    fi
                    ;;
                *) pattern_array[$position]="$char" ;;
            esac
        done
        
        PATTERN=""
        for ((i=0; i<PASSWORD_LENGTH; i++)); do
            PATTERN+="${pattern_array[$i]}"
        done
    else
        PATTERN=$(printf "%0.s?" $(seq 1 $PASSWORD_LENGTH))
    fi
    
    print_success "Brute force configured"
    print_info "Pattern: $PATTERN"
    print_info "Charset: ${#CHARSET} characters"
    
    local total=1
    local unknown_count=0
    for ((i=0; i<${#PATTERN}; i++)); do
        char="${PATTERN:$i:1}"
        if [[ "$char" == "?" ]]; then
            total=$((total * ${#CHARSET}))
            unknown_count=$((unknown_count + 1))
        fi
    done
    
    print_info "Unknown positions: $unknown_count"
    print_info "Total combinations: $(printf "%'d" $total)"
    
    if [[ $total -gt 10000000 ]]; then
        print_warning "WARNING: This may take VERY LONG time!"
        echo -e "${CYAN}Continue anyway? (y/n):${NC}"
        read confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    sleep 2
}

# ============================================
# STEP 3C: SINGLE PASSWORD TEST - FIXED VERSION
# ============================================

setup_single_test() {
    clear_screen
    print_header "Single Password Test"
    
    echo -e "${CYAN}Enter password to test:${NC}"
    read -s password
    echo ""
    
    cat > single_test.py << 'EOF'
import sys
import pyzipper
import zipfile
import os

# PDF support
try:
    import PyPDF2
    HAS_PDF = True
except ImportError:
    HAS_PDF = False

# Excel support
try:
    import openpyxl
    HAS_EXCEL = True
except ImportError:
    try:
        import xlrd
        HAS_EXCEL = True
    except ImportError:
        HAS_EXCEL = False

def test_password_pdf(pdf_path, password):
    if not HAS_PDF:
        return False
    try:
        with open(pdf_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            if reader.is_encrypted:
                result = reader.decrypt(password)
                return result == 1 or result == 2
    except:
        pass
    return False

def test_password_excel(excel_path, password):
    if not HAS_EXCEL:
        return False
    try:
        if excel_path.lower().endswith('.xlsx'):
            workbook = openpyxl.load_workbook(excel_path, read_only=True, data_only=True)
            return True
        elif excel_path.lower().endswith('.xls'):
            import xlrd
            workbook = xlrd.open_workbook(excel_path, password=password)
            return True
    except:
        pass
    return False

def test_password_powerpoint(ppt_path, password):
    try:
        cmd = f'7z t -p"{password}" "{ppt_path}" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        return result == 0
    except:
        return False

def test_password_word(doc_path, password):
    try:
        cmd = f'7z t -p"{password}" "{doc_path}" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        return result == 0
    except:
        return False

def test_password_zip(zip_path, password):
    try:
        pwd_bytes = password.encode('utf-8')
        try:
            with pyzipper.AESZipFile(zip_path, 'r') as zf:
                for info in zf.infolist():
                    if not info.filename.endswith('/'):
                        try:
                            zf.read(info.filename, pwd=pwd_bytes)
                            return True, "ZIP (AES)"
                        except:
                            return False, "Wrong password"
        except:
            pass
        try:
            with zipfile.ZipFile(zip_path, 'r') as zf:
                for info in zf.infolist():
                    if not info.filename.endswith('/'):
                        try:
                            zf.read(info.filename, pwd=pwd_bytes)
                            return True, "Standard ZIP"
                        except:
                            return False, "Wrong password"
        except Exception as e:
            return False, f"ZIP error: {str(e)}"
    except Exception as e:
        return False, f"Error: {str(e)}"
    return False, "Not a ZIP file"

def test_password_7z(archive_path, password):
    try:
        cmd = f'7z t -p"{password}" "{archive_path}" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        if result == 0:
            return True, "7Z Archive"
        else:
            return False, "Wrong password"
    except:
        return False, "7Z test failed"

def test_password_rar(archive_path, password):
    try:
        cmd = f'unrar t -p"{password}" "{archive_path}"'
        result = os.system(cmd + " > /dev/null 2>&1")
        if result == 0:
            return True, "RAR Archive"
        else:
            return False, "Wrong password"
    except:
        return False, "RAR test failed"

def test_single_password(archive_path, password, archive_type="auto"):
    # Based on specified type
    if archive_type == "pdf":
        if test_password_pdf(archive_path, password):
            return True, "PDF Document"
    
    if archive_type == "excel":
        if test_password_excel(archive_path, password):
            return True, "Excel File"
    
    if archive_type == "powerpoint":
        if test_password_powerpoint(archive_path, password):
            return True, "PowerPoint File"
    
    if archive_type == "word":
        if test_password_word(archive_path, password):
            return True, "Word Document"
    
    if archive_type in ["zip", "aes", "standard"]:
        success, msg = test_password_zip(archive_path, password)
        if success:
            return True, msg
    
    if archive_type == "7z":
        success, msg = test_password_7z(archive_path, password)
        if success:
            return True, msg
    
    if archive_type == "rar":
        success, msg = test_password_rar(archive_path, password)
        if success:
            return True, msg
    
    # Auto mode - try all formats
    if archive_type == "auto":
        # Try PDF
        if test_password_pdf(archive_path, password):
            return True, "PDF Document"
        
        # Try Excel
        if test_password_excel(archive_path, password):
            return True, "Excel File"
        
        # Try PowerPoint
        if test_password_powerpoint(archive_path, password):
            return True, "PowerPoint File"
        
        # Try Word
        if test_password_word(archive_path, password):
            return True, "Word Document"
        
        # Try ZIP
        success, msg = test_password_zip(archive_path, password)
        if success:
            return True, msg
        
        # Try 7Z
        success, msg = test_password_7z(archive_path, password)
        if success:
            return True, msg
        
        # Try RAR
        success, msg = test_password_rar(archive_path, password)
        if success:
            return True, msg
    
    return False, "Password incorrect"

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 single_test.py <archive> <password> [type]")
        sys.exit(1)
    
    archive = sys.argv[1]
    password = sys.argv[2]
    archive_type = sys.argv[3] if len(sys.argv) > 3 else "auto"
    
    if not os.path.exists(archive):
        print("Error: File not found!")
        sys.exit(1)
    
    success, message = test_single_password(archive, password, archive_type)
    
    if success:
        print("SUCCESS:1")
        print(f"Password: {password}")
        print(f"Archive Type: {message}")
    else:
        print("SUCCESS:0")
        print(f"Message: {message}")
EOF
    
    echo -e "${BLUE}[*]${NC} Testing password: ${YELLOW}$password${NC}"
    result=$(python3 single_test.py "$CURRENT_FILE" "$password" "$ZIP_TYPE" 2>/dev/null)
    
    if echo "$result" | grep -q "SUCCESS:1"; then
        echo ""
        print_success "PASSWORD IS CORRECT!"
        echo -e "${GREEN}✓ Password:${NC} ${WHITE}$password${NC}"
        archive_type_msg=$(echo "$result" | grep "Archive Type" | cut -d: -f2-)
        echo -e "${GREEN}✓ Archive Type:${NC} ${WHITE}$archive_type_msg${NC}"
        
        echo ""
        echo -e "${CYAN}Extract files? (y/n):${NC}"
        read extract
        
        if [[ "$extract" =~ ^[Yy]$ ]]; then
            extract_files "$password"
        fi
    else
        echo ""
        print_error "PASSWORD IS WRONG!"
        echo -e "${RED}✗ Password:${NC} ${WHITE}$password${NC}"
        error_msg=$(echo "$result" | grep "Message" | cut -d: -f2-)
        echo -e "${RED}✗ Reason:${NC} ${WHITE}$error_msg${NC}"
    fi
    
    rm -f single_test.py
    echo ""
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read
    return 1
}

# ============================================
# EXTRACTION FUNCTION
# ============================================

extract_files() {
    local password="$1"
    
    cat > extract_files.py << 'EOF'
import sys
import pyzipper
import zipfile
import os
import shutil

def extract_pdf(pdf_path, password, output_dir):
    try:
        import PyPDF2
        with open(pdf_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            if reader.is_encrypted:
                reader.decrypt(password)
            
            writer = PyPDF2.PdfWriter()
            for page_num in range(len(reader.pages)):
                writer.add_page(reader.pages[page_num])
            
            output_file = os.path.join(output_dir, os.path.basename(pdf_path))
            with open(output_file, 'wb') as out_file:
                writer.write(out_file)
            print(f"Extracted PDF file")
            return True
    except:
        return False

def extract_excel(excel_path, password, output_dir):
    try:
        if excel_path.lower().endswith('.xlsx'):
            import openpyxl
            workbook = openpyxl.load_workbook(excel_path, data_only=True)
            output_file = os.path.join(output_dir, os.path.basename(excel_path))
            workbook.save(output_file)
            print(f"Extracted Excel file")
            return True
        elif excel_path.lower().endswith('.xls'):
            shutil.copy2(excel_path, output_dir)
            print(f"Copied Excel file")
            return True
    except:
        return False

def extract_powerpoint(ppt_path, password, output_dir):
    try:
        cmd = f'7z x -p"{password}" -o"{output_dir}" "{ppt_path}" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        if result == 0:
            print(f"Extracted PowerPoint file")
            return True
    except:
        return False

def extract_word(doc_path, password, output_dir):
    try:
        cmd = f'7z x -p"{password}" -o"{output_dir}" "{doc_path}" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        if result == 0:
            print(f"Extracted Word document")
            return True
    except:
        return False

def extract_zip(archive_path, password, output_dir):
    try:
        with pyzipper.AESZipFile(archive_path, 'r') as zf:
            zf.extractall(path=output_dir, pwd=password.encode())
            print(f"Extracted files (AES ZIP)")
            return True
    except:
        try:
            with zipfile.ZipFile(archive_path, 'r') as zf:
                zf.extractall(path=output_dir, pwd=password.encode())
                print(f"Extracted files (Standard ZIP)")
                return True
        except:
            return False

def extract_7z(archive_path, password, output_dir):
    try:
        if os.path.exists(output_dir):
            shutil.rmtree(output_dir)
        os.makedirs(output_dir, exist_ok=True)
        cmd = f'7z x -p"{password}" -o"{output_dir}" "{archive_path}" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        if result == 0:
            print(f"Extracted files (7Z)")
            return True
        else:
            return False
    except:
        return False

def extract_rar(archive_path, password, output_dir):
    try:
        if os.path.exists(output_dir):
            shutil.rmtree(output_dir)
        os.makedirs(output_dir, exist_ok=True)
        cmd = f'unrar x -p"{password}" "{archive_path}" "{output_dir}/" -y'
        result = os.system(cmd + " > /dev/null 2>&1")
        if result == 0:
            print(f"Extracted files (RAR)")
            return True
        else:
            return False
    except:
        return False

def extract_archive(archive_path, password, output_dir, archive_type="auto"):
    if archive_type == "pdf":
        return extract_pdf(archive_path, password, output_dir)
    elif archive_type == "excel":
        return extract_excel(archive_path, password, output_dir)
    elif archive_type == "powerpoint":
        return extract_powerpoint(archive_path, password, output_dir)
    elif archive_type == "word":
        return extract_word(archive_path, password, output_dir)
    elif archive_type == "zip" or archive_type == "aes" or archive_type == "standard":
        return extract_zip(archive_path, password, output_dir)
    elif archive_type == "7z":
        return extract_7z(archive_path, password, output_dir)
    elif archive_type == "rar":
        return extract_rar(archive_path, password, output_dir)
    elif archive_type == "auto":
        if extract_pdf(archive_path, password, output_dir):
            return True
        if extract_excel(archive_path, password, output_dir):
            return True
        if extract_powerpoint(archive_path, password, output_dir):
            return True
        if extract_word(archive_path, password, output_dir):
            return True
        if extract_zip(archive_path, password, output_dir):
            return True
        if extract_7z(archive_path, password, output_dir):
            return True
        if extract_rar(archive_path, password, output_dir):
            return True
    return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 extract_files.py <archive> <password> <output_dir> [type]")
        sys.exit(1)
    
    archive = sys.argv[1]
    password = sys.argv[2]
    output_dir = sys.argv[3]
    archive_type = sys.argv[4] if len(sys.argv) > 4 else "auto"
    
    success = extract_archive(archive, password, output_dir, archive_type)
    sys.exit(0 if success else 1)
EOF
    
    echo -e "${BLUE}[*]${NC} Extracting files..."
    
    if python3 extract_files.py "$CURRENT_FILE" "$password" "$OUTPUT_DIR" "$ZIP_TYPE" 2>/dev/null; then
        print_success "Files extracted to: $OUTPUT_DIR"
        echo -e "${CYAN}Extracted files:${NC}"
        ls -la "$OUTPUT_DIR" 2>/dev/null | head -10
    else
        print_error "Extraction failed"
    fi
    
    rm -f extract_files.py
}

# ============================================
# SMART DICTIONARY ATTACK SETUP
# ============================================

setup_smart_dictionary() {
    clear_screen
    print_header "Smart Dictionary Attack"
    
    echo -e "${WHITE}Smart attack uses rules and mutations:${NC}"
    echo ""
    
    echo -e "${CYAN}Base dictionary file:${NC}"
    read -e base_dict
    
    base_dict="${base_dict//\'/}"
    base_dict="${base_dict//\"/}"
    base_dict="${base_dict/#\~/$HOME}"
    
    if [[ ! -f "$base_dict" ]]; then
        print_error "Base dictionary not found, using default"
        create_default_dictionary
        base_dict="common_passwords.txt"
    fi
    
    echo -e "${CYAN}Apply mutation rules? (y/n):${NC}"
    read apply_rules
    
    if [[ "$apply_rules" =~ ^[Yy]$ ]]; then
        print_info "Creating smart dictionary with mutations..."
        
        cat > smart_dict.py << 'EOF'
import sys

def mutate_password(password):
    mutations = set([password])
    
    mutations.add(password.lower())
    mutations.add(password.upper())
    mutations.add(password.capitalize())
    
    for num in ['', '1', '123', '1234', '123456', '2024', '2023', '2025', '!', '@', '#', '!@#']:
        mutations.add(password + num)
        mutations.add(password.lower() + num)
    
    leet = str.maketrans('aeiost', '431057')
    leet_version = password.translate(leet)
    mutations.add(leet_version)
    mutations.add(leet_version.lower())
    
    if len(password) <= 8:
        mutations.add(password[::-1])
    
    mutations.add(password + password)
    mutations.add(password + password.lower())
    
    return mutations

def create_smart_dictionary(input_file, output_file):
    all_passwords = set()
    
    with open(input_file, 'r', encoding='utf-8', errors='ignore') as f:
        passwords = [line.strip() for line in f if line.strip()]
    
    print(f"[*] Base passwords: {len(passwords)}")
    
    for i, pwd in enumerate(passwords):
        if i % 100 == 0:
            print(f"[*] Processing: {i}/{len(passwords)}", end='\r')
        
        mutations = mutate_password(pwd)
        all_passwords.update(mutations)
    
    print(f"\n[*] Total mutations: {len(all_passwords)}")
    
    with open(output_file, 'w') as f:
        for pwd in sorted(all_passwords, key=len):
            f.write(pwd + '\n')
    
    return len(all_passwords)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 smart_dict.py <input_dict> <output_dict>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    count = create_smart_dictionary(input_file, output_file)
    print(f"[+] Created smart dictionary: {output_file} ({count} passwords)")
EOF
        
        python3 smart_dict.py "$base_dict" "smart_dict.txt" 2>/dev/null
        
        if [[ -f "smart_dict.txt" ]]; then
            DICT_FILE="smart_dict.txt"
            DICT_TYPE="smart"
            local line_count=$(wc -l < "smart_dict.txt")
            print_success "Smart dictionary created: $line_count passwords"
        else
            DICT_FILE="$base_dict"
            print_info "Using base dictionary (mutation failed)"
        fi
        
        rm -f smart_dict.py
    else
        DICT_FILE="$base_dict"
        print_info "Using base dictionary without mutations"
    fi
    
    sleep 2
}

# ============================================
# STEP 4: ATTACK SUMMARY
# ============================================

show_attack_summary() {
    clear_screen
    print_header "Attack Summary"
    
    echo -e "${CYAN}Archive:${NC} ${WHITE}$(basename "$CURRENT_FILE")${NC}"
    echo -e "${CYAN}Type:${NC} ${WHITE}$ZIP_TYPE${NC}"
    
    case $ATTACK_MODE in
        "bruteforce")
            local total=1
            local unknown_count=0
            for ((i=0; i<${#PATTERN}; i++)); do
                char="${PATTERN:$i:1}"
                if [[ "$char" == "?" ]]; then
                    total=$((total * ${#CHARSET}))
                    unknown_count=$((unknown_count + 1))
                fi
            done
            
            echo -e "${CYAN}Mode:${NC} ${WHITE}Brute Force${NC}"
            echo -e "${CYAN}Pattern:${NC} ${WHITE}$PATTERN${NC}"
            echo -e "${CYAN}Length:${NC} ${WHITE}$PASSWORD_LENGTH${NC}"
            echo -e "${CYAN}Charset:${NC} ${WHITE}${#CHARSET} chars${NC}"
            echo -e "${CYAN}Unknown positions:${NC} ${WHITE}$unknown_count${NC}"
            echo -e "${CYAN}Combinations:${NC} ${WHITE}$(printf "%'d" $total)${NC}"
            
            local speed=1000
            local seconds=$((total / speed))
            ;;
        
        "dictionary"|"smartdict"|"personal")
            if [[ -f "$DICT_FILE" ]]; then
                local line_count=$(wc -l < "$DICT_FILE" 2>/dev/null || echo "0")
                echo -e "${CYAN}Mode:${NC} ${WHITE}Dictionary Attack${NC}"
                echo -e "${CYAN}Dictionary:${NC} ${WHITE}$(basename "$DICT_FILE")${NC}"
                echo -e "${CYAN}Dictionary Type:${NC} ${WHITE}$DICT_TYPE${NC}"
                echo -e "${CYAN}Passwords:${NC} ${WHITE}$(printf "%'d" $line_count)${NC}"
                
                local speed=5000
                local seconds=$((line_count / speed))
            fi
            ;;
    esac
    
    if [[ -n "$seconds" ]]; then
        echo ""
        echo -e "${YELLOW}ESTIMATION:${NC}"
        if [[ $seconds -gt 86400 ]]; then
            local days=$((seconds / 86400))
            local hours=$(((seconds % 86400) / 3600))
            echo -e "${CYAN}Estimated time:${NC} ${RED}$days days, $hours hours${NC}"
            print_warning "This may take VERY LONG!"
        elif [[ $seconds -gt 3600 ]]; then
            local hours=$((seconds / 3600))
            local minutes=$(((seconds % 3600) / 60))
            echo -e "${CYAN}Estimated time:${NC} ${YELLOW}$hours hours, $minutes minutes${NC}"
            print_warning "This may take some time"
        elif [[ $seconds -gt 60 ]]; then
            local minutes=$((seconds / 60))
            echo -e "${CYAN}Estimated time:${NC} ${GREEN}$minutes minutes${NC}"
        else
            echo -e "${CYAN}Estimated time:${NC} ${GREEN}$seconds seconds${NC}"
        fi
        echo -e "${CYAN}Estimated speed:${NC} ${WHITE}$speed passwords/second${NC}"
        
        if [[ "$ATTACK_MODE" == "bruteforce" ]] && [[ $total -gt 10000000 ]]; then
            echo ""
            print_warning "WARNING: Very large search space!"
            echo -e "${WHITE}Consider using dictionary attack instead.${NC}"
        fi
    fi
    
    echo ""
    print_line
    
    echo ""
    echo -e "${CYAN}Start attack? (y/n):${NC}"
    read confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# ============================================
# CREATE ADVANCED CRACKER - UPDATED WITH FIXED VERSION
# ============================================

create_advanced+cracker() {
    cat > "$PYTHON_CRACKER" << 'PYTHON_EOF'
#!/usr/bin/env python3

import sys
import pyzipper
import zipfile
import itertools
import threading
import time
import os
import signal
from typing import List, Tuple

# ============================================
# LIBRARY CHECKS
# ============================================
try:
    import pyzipper
    HAS_PYZIPPER = True
except ImportError:
    HAS_PYZIPPER = False

# PDF support
try:
    import PyPDF2
    HAS_PDF = True
except ImportError:
    HAS_PDF = False

# Excel support
try:
    import openpyxl
    HAS_EXCEL = True
except ImportError:
    try:
        import xlrd
        HAS_EXCEL = True
    except ImportError:
        HAS_EXCEL = False

# PowerPoint support
try:
    from pptx import Presentation
    HAS_PPT = True
except ImportError:
    HAS_PPT = False

# Word support
try:
    import docx
    HAS_DOCX = True
except ImportError:
    HAS_DOCX = False

class ProgressDisplay:
    def __init__(self, total: int):
        self.total = total
        self.tested = 0
        self.start_time = time.time()
        self.running = True
        self.current_pass = ""
        self.speed_history = []
    
    def update(self, tested: int, current: str):
        self.tested = tested
        self.current_pass = current
        
        elapsed = time.time() - self.start_time
        speed = tested / elapsed if elapsed > 0 else 0
        
        self.speed_history.append(speed)
        if len(self.speed_history) > 10:
            self.speed_history.pop(0)
        avg_speed = sum(self.speed_history) / len(self.speed_history) if self.speed_history else speed
        
        percent = min(100.0, (tested / self.total) * 100) if self.total > 0 else 0
        
        bar_length = 40
        filled = int(bar_length * percent / 100)
        
        if percent < 30:
            bar_color = "\033[91m"
        elif percent < 70:
            bar_color = "\033[93m"
        else:
            bar_color = "\033[92m"
            
        bar_reset = "\033[0m"
        
        bar = bar_color + "█" * filled + bar_reset + "░" * (bar_length - filled)
        
        if avg_speed > 0 and percent < 100:
            remaining = (self.total - self.tested) / avg_speed
            hours = int(remaining // 3600)
            minutes = int((remaining % 3600) // 60)
            seconds = int(remaining % 60)
            if hours > 0:
                eta = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
            else:
                eta = f"{minutes:02d}:{seconds:02d}"
        else:
            eta = "N/A"
        
        sys.stdout.write(f"\r[{bar}] {percent:.1f}% | Tested: {self.tested:,} | Speed: {avg_speed:.0f}/s | ETA: {eta}")
        sys.stdout.flush()
    
    def finish(self):
        elapsed = time.time() - self.start_time
        speed = self.tested / elapsed if elapsed > 0 else 0
        sys.stdout.write(f"\r{' ' * 120}\r")
        sys.stdout.flush()
        return elapsed, speed

class ArchiveCracker:
    def __init__(self, archive_file: str, archive_type: str = "auto", output_dir: str = "extracted"):
        self.archive_file = archive_file
        self.archive_type = archive_type
        self.output_dir = output_dir
        self.found = False
        self.password = ""
        self.tested = 0
        self.total = 0
        self.progress = None
        self.completed = False
        
        if self.archive_type == "auto":
            ext = archive_file.lower()
            if ext.endswith('.zip'):
                self.archive_type = "zip"
            elif ext.endswith('.7z'):
                self.archive_type = "7z"
            elif ext.endswith('.rar'):
                self.archive_type = "rar"
            elif ext.endswith('.pdf'):
                self.archive_type = "pdf"
            elif ext.endswith('.xls') or ext.endswith('.xlsx'):
                self.archive_type = "excel"
            elif ext.endswith('.ppt') or ext.endswith('.pptx'):
                self.archive_type = "powerpoint"
            elif ext.endswith('.doc') or ext.endswith('.docx'):
                self.archive_type = "word"
            else:
                self.archive_type = "zip"
    
    def test_password_zip(self, password: str) -> bool:
        try:
            pwd_bytes = password.encode('utf-8')
            
            if HAS_PYZIPPER:
                try:
                    with pyzipper.AESZipFile(self.archive_file, 'r') as zf:
                        for info in zf.infolist():
                            if not info.filename.endswith('/'):
                                try:
                                    zf.read(info.filename, pwd=pwd_bytes)
                                    return True
                                except RuntimeError as e:
                                    if 'Bad password' in str(e):
                                        return False
                                    continue
                                except:
                                    continue
                except:
                    pass
            
            try:
                with zipfile.ZipFile(self.archive_file, 'r') as zf:
                    for info in zf.infolist():
                        if not info.filename.endswith('/'):
                            try:
                                zf.read(info.filename, pwd=pwd_bytes)
                                return True
                            except RuntimeError as e:
                                if 'Bad password' in str(e):
                                    return False
                                continue
                            except:
                                continue
            except RuntimeError as e:
                if 'Bad password' in str(e):
                    return False
            except:
                pass
                
        except Exception as e:
            pass
        
        return False
    
    def test_password_7z(self, password: str) -> bool:
        try:
            cmd = f'7z t -p"{password}" "{self.archive_file}" -y'
            result = os.system(cmd + " > /dev/null 2>&1")
            return result == 0
        except:
            return False
    
    def test_password_rar(self, password: str) -> bool:
        try:
            cmd = f'unrar t -p"{password}" "{self.archive_file}"'
            result = os.system(cmd + " > /dev/null 2>&1")
            return result == 0
        except:
            return False
    
    def test_password_pdf(self, password: str) -> bool:
        if not HAS_PDF:
            return False
        
        try:
            with open(self.archive_file, 'rb') as file:
                reader = PyPDF2.PdfReader(file)
                if reader.is_encrypted:
                    result = reader.decrypt(password)
                    return result == 1 or result == 2
        except Exception as e:
            pass
        
        return False
    
    def test_password_excel(self, password: str) -> bool:
        if not HAS_EXCEL:
            return False
        
        try:
            if self.archive_file.lower().endswith('.xlsx'):
                workbook = openpyxl.load_workbook(self.archive_file, read_only=True, data_only=True)
                return True
            elif self.archive_file.lower().endswith('.xls'):
                import xlrd
                workbook = xlrd.open_workbook(self.archive_file, password=password)
                return True
        except Exception as e:
            pass
        
        return False
    
    def test_password_powerpoint(self, password: str) -> bool:
        try:
            cmd = f'7z t -p"{password}" "{self.archive_file}" -y'
            result = os.system(cmd + " > /dev/null 2>&1")
            return result == 0
        except:
            pass
        
        return False
    
    def test_password_word(self, password: str) -> bool:
        try:
            cmd = f'7z t -p"{password}" "{self.archive_file}" -y'
            result = os.system(cmd + " > /dev/null 2>&1")
            return result == 0
        except:
            pass
        
        return False
    
    def test_password(self, password: str) -> bool:
        # First check based on specified archive type
        if self.archive_type == "zip" or self.archive_type == "aes" or self.archive_type == "standard":
            return self.test_password_zip(password)
        elif self.archive_type == "7z":
            return self.test_password_7z(password)
        elif self.archive_type == "rar":
            return self.test_password_rar(password)
        elif self.archive_type == "pdf":
            return self.test_password_pdf(password)
        elif self.archive_type == "excel":
            return self.test_password_excel(password)
        elif self.archive_type == "powerpoint":
            return self.test_password_powerpoint(password)
        elif self.archive_type == "word":
            return self.test_password_word(password)
        
        # Auto mode - try all formats
        if self.archive_type == "auto":
            # Try ZIP first
            if self.test_password_zip(password):
                self.archive_type = "zip"
                return True
            
            # Try 7Z
            if self.test_password_7z(password):
                self.archive_type = "7z"
                return True
            
            # Try RAR
            if self.test_password_rar(password):
                self.archive_type = "rar"
                return True
            
            # Try PDF
            if self.test_password_pdf(password):
                self.archive_type = "pdf"
                return True
            
            # Try Excel
            if self.test_password_excel(password):
                self.archive_type = "excel"
                return True
            
            # Try PowerPoint
            if self.test_password_powerpoint(password):
                self.archive_type = "powerpoint"
                return True
            
            # Try Word
            if self.test_password_word(password):
                self.archive_type = "word"
                return True
        
        return False
    
    def extract_files(self, password: str) -> bool:
        try:
            if os.path.exists(self.output_dir):
                import shutil
                shutil.rmtree(self.output_dir)
            os.makedirs(self.output_dir, exist_ok=True)
            
            if self.archive_type in ["zip", "aes", "standard"]:
                try:
                    with pyzipper.AESZipFile(self.archive_file, 'r') as zf:
                        zf.extractall(path=self.output_dir, pwd=password.encode())
                except:
                    with zipfile.ZipFile(self.archive_file, 'r') as zf:
                        zf.extractall(path=self.output_dir, pwd=password.encode())
                return True
                
            elif self.archive_type == "7z":
                cmd = f'7z x -p"{password}" -o"{self.output_dir}" "{self.archive_file}" -y'
                result = os.system(cmd + " > /dev/null 2>&1")
                return result == 0
                
            elif self.archive_type == "rar":
                cmd = f'unrar x -p"{password}" "{self.archive_file}" "{self.output_dir}/" -y'
                result = os.system(cmd + " > /dev/null 2>&1")
                return result == 0
            
            elif self.archive_type == "pdf":
                with open(self.archive_file, 'rb') as file:
                    reader = PyPDF2.PdfReader(file)
                    if reader.is_encrypted:
                        reader.decrypt(password)
                    
                    writer = PyPDF2.PdfWriter()
                    for page_num in range(len(reader.pages)):
                        writer.add_page(reader.pages[page_num])
                    
                    output_file = os.path.join(self.output_dir, os.path.basename(self.archive_file))
                    with open(output_file, 'wb') as out_file:
                        writer.write(out_file)
                    return True
            
            elif self.archive_type == "excel":
                if self.archive_file.lower().endswith('.xlsx'):
                    workbook = openpyxl.load_workbook(self.archive_file, data_only=True)
                    output_file = os.path.join(self.output_dir, os.path.basename(self.archive_file))
                    workbook.save(output_file)
                    return True
                elif self.archive_file.lower().endswith('.xls'):
                    import shutil
                    shutil.copy2(self.archive_file, self.output_dir)
                    return True
            
            elif self.archive_type in ["powerpoint", "word"]:
                cmd = f'7z x -p"{password}" -o"{self.output_dir}" "{self.archive_file}" -y'
                result = os.system(cmd + " > /dev/null 2>&1")
                return result == 0
            
            return False
        except Exception as e:
            print(f"\n[!] Extraction error: {e}")
            return False
    
    # ============================================
    # BRUTE FORCE - PRE-GENERATE ALL PASSWORDS
    # ============================================
    def generate_all_passwords(self, charset: str, pattern: str) -> List[str]:
        """Generate all possible passwords based on pattern"""
        char_sets = []
        
        # Sort charset: lowercase first (a-z), then uppercase (A-Z), then digits (0-9), then symbols
        lowercase = ''.join(sorted([c for c in charset if c.islower()]))
        uppercase = ''.join(sorted([c for c in charset if c.isupper()]))
        digits = ''.join(sorted([c for c in charset if c.isdigit()]))
        symbols = ''.join(sorted([c for c in charset if not c.isalnum()]))
        
        sorted_charset = lowercase + uppercase + digits + symbols
        
        for char in pattern:
            if char == '?':
                char_sets.append(sorted_charset)
            else:
                char_sets.append(char)
        
        # Generate all passwords
        passwords = []
        total = 1
        for cs in char_sets:
            if isinstance(cs, str) and len(cs) > 1:
                total *= len(cs)
        
        print(f"\n[*] Generating {total:,} passwords...")
        
        for combo in itertools.product(*char_sets):
            passwords.append(''.join(combo))
        
        return passwords
    
    # ============================================
    # BRUTE FORCE WITH PRE-GENERATED PASSWORDS
    # ============================================
    def brute_force(self, charset: str, pattern: str, max_threads: int = 4) -> Tuple[bool, str]:
        # Generate all passwords first
        passwords = self.generate_all_passwords(charset, pattern)
        self.total = len(passwords)
        self.progress = ProgressDisplay(self.total)
        self.completed = False
        
        print(f"\033[96m[*] Starting brute force attack\033[0m")
        print(f"[*] Archive Type: {self.archive_type.upper()}")
        print(f"[*] Pattern: {pattern}")
        print(f"[*] Total combinations: {self.total:,}")
        
        if self.total > 0:
            est_time = self.total / 1000
            if est_time > 3600:
                hours = int(est_time // 3600)
                minutes = int((est_time % 3600) // 60)
                print(f"[*] Estimated time: ~{hours}h {minutes}m")
            elif est_time > 60:
                minutes = int(est_time // 60)
                print(f"[*] Estimated time: ~{minutes} minutes")
            else:
                print(f"[*] Estimated time: ~{int(est_time)} seconds")
        print()
        
        def worker(start_idx, end_idx, result):
            try:
                for i in range(start_idx, min(end_idx, self.total)):
                    if self.found:
                        break
                    
                    password = passwords[i]
                    
                    with threading.Lock():
                        self.tested += 1
                        self.progress.update(self.tested, password)
                    
                    if self.test_password(password):
                        with threading.Lock():
                            if not self.found:
                                self.found = True
                                self.password = password
                                result[0] = password
                        break
            except Exception as e:
                pass
        
        threads = []
        result = [None]
        chunk_size = self.total // max_threads + 1
        
        def signal_handler(sig, frame):
            print("\n\033[93m[!] Stopped by user\033[0m")
            self.found = True
            sys.exit(1)
        
        signal.signal(signal.SIGINT, signal_handler)
        
        for i in range(max_threads):
            start = i * chunk_size
            end = start + chunk_size
            t = threading.Thread(target=worker, args=(start, end, result))
            t.daemon = True
            threads.append(t)
            t.start()
        
        try:
            while any(t.is_alive() for t in threads) and not self.found:
                time.sleep(0.1)
                
                if self.tested >= self.total and not self.found:
                    self.completed = True
                    break
                    
        except KeyboardInterrupt:
            print("\n\033[93m[!] Stopped by user\033[0m")
            return False, ""
        
        elapsed, speed = self.progress.finish()
        print()
        
        if self.completed and not self.found:
            print("\033[93m[!] 100% complete - All passwords tested\033[0m")
            print("\033[91m[-] Password not found\033[0m")
        
        return self.found, self.password
    
    def dictionary_attack(self, dict_file: str, max_threads: int = 4) -> Tuple[bool, str]:
        if not os.path.exists(dict_file):
            print(f"\033[91m[!] Dictionary file not found\033[0m")
            return False, ""
        
        passwords = []
        try:
            with open(dict_file, 'r', encoding='utf-8', errors='ignore') as f:
                for line in f:
                    line = line.strip()
                    if line:
                        passwords.append(line)
        except:
            print(f"\033[91m[!] Cannot read dictionary file\033[0m")
            return False, ""
        
        total = len(passwords)
        self.total = total
        self.progress = ProgressDisplay(total)
        self.completed = False
        
        print(f"\033[96m[*] Starting dictionary attack\033[0m")
        print(f"[*] Archive Type: {self.archive_type.upper()}")
        print(f"[*] Dictionary: {os.path.basename(dict_file)}")
        print(f"[*] Passwords: {total:,}")
        print()
        
        def dict_worker(start_idx, end_idx, result):
            try:
                for i in range(start_idx, min(end_idx, total)):
                    if self.found:
                        break
                    
                    password = passwords[i]
                    
                    with threading.Lock():
                        self.tested += 1
                        self.progress.update(self.tested, password)
                    
                    if self.test_password(password):
                        with threading.Lock():
                            if not self.found:
                                self.found = True
                                self.password = password
                                result[0] = password
                        break
            except Exception as e:
                pass
        
        threads = []
        result = [None]
        chunk_size = total // max_threads + 1
        
        def signal_handler(sig, frame):
            print("\n\033[93m[!] Stopped by user\033[0m")
            self.found = True
            sys.exit(1)
        
        signal.signal(signal.SIGINT, signal_handler)
        
        for i in range(max_threads):
            start = i * chunk_size
            end = start + chunk_size
            t = threading.Thread(target=dict_worker, args=(start, end, result))
            t.daemon = True
            threads.append(t)
            t.start()
        
        try:
            while any(t.is_alive() for t in threads) and not self.found:
                time.sleep(0.1)
                
                if self.tested >= self.total and not self.found:
                    self.completed = True
                    break
                    
        except KeyboardInterrupt:
            print("\n\033[93m[!] Stopped by user\033[0m")
            return False, ""
        
        elapsed, speed = self.progress.finish()
        print()
        
        if self.completed and not self.found:
            print("\033[93m[!] 100% complete - All passwords tested\033[0m")
            print("\033[91m[-] Password not found in dictionary\033[0m")
        
        return self.found, self.password

def main():
    if len(sys.argv) < 5:
        print("Usage: python3 advanced+cracker.py <mode> <archive> <type> <arg1> [arg2]")
        print("Modes: brute <archive> <type> <charset> <pattern>")
        print("       dict <archive> <type> <dictionary>")
        print("Types: auto, zip, aes, standard, 7z, rar, pdf, excel, powerpoint, word")
        sys.exit(1)
    
    mode = sys.argv[1]
    archive_file = sys.argv[2]
    archive_type = sys.argv[3]
    
    if not os.path.exists(archive_file):
        print(f"\033[91m[!] Archive file not found\033[0m")
        sys.exit(1)
    
    cracker = ArchiveCracker(archive_file, archive_type)
    
    if mode == "brute" and len(sys.argv) >= 6:
        charset = sys.argv[4]
        pattern = sys.argv[5]
        success, password = cracker.brute_force(charset, pattern, max_threads=4)
    elif mode == "dict" and len(sys.argv) >= 5:
        dict_file = sys.argv[4]
        success, password = cracker.dictionary_attack(dict_file, max_threads=4)
    else:
        print("\033[91m[!] Invalid mode or arguments\033[0m")
        sys.exit(1)
    
    elapsed = time.time() - cracker.progress.start_time
    
    if success:
        print(f"\n\033[92m[+] PASSWORD FOUND!\033[0m")
        print(f"\033[92m[+] Password: {password}\033[0m")
        print(f"[+] Archive Type: {cracker.archive_type.upper()}")
        print(f"[+] Tested: {cracker.tested:,} passwords")
        print(f"[+] Time: {elapsed:.2f} seconds")
        print(f"[+] Speed: {cracker.tested/elapsed:.0f} passwords/second")
        
        print(f"\n[*] Extracting files...")
        if cracker.extract_files(password):
            print(f"\033[92m[+] Files extracted to: {cracker.output_dir}\033[0m")
            
            if os.path.exists(cracker.output_dir):
                import glob
                files = glob.glob(os.path.join(cracker.output_dir, "**"), recursive=True)
                files = [f for f in files if os.path.isfile(f)]
                if files:
                    print(f"[+] Extracted {len(files)} files")
                    if len(files) <= 10:
                        for f in files[:10]:
                            size = os.path.getsize(f)
                            print(f"    {os.path.basename(f)} ({size} bytes)")
        else:
            print(f"\033[93m[!] Extraction failed\033[0m")
        
        with open("crack_result.txt", "w") as f:
            f.write(f"Password: {password}\n")
            f.write(f"File: {archive_file}\n")
            f.write(f"Type: {cracker.archive_type}\n")
            f.write(f"Tested: {cracker.tested}\n")
            f.write(f"Time: {elapsed:.2f}s\n")
            f.write(f"Speed: {cracker.tested/elapsed:.0f}/s\n")
        
        sys.exit(0)
    else:
        print(f"\n\033[91m[-] Password not found\033[0m")
        print(f"[-] Tested: {cracker.tested:,} passwords")
        print(f"[-] Time: {elapsed:.2f} seconds")
        print(f"[-] Speed: {cracker.tested/elapsed:.0f} passwords/second")
        sys.exit(1)

if __name__ == "__main__":
    main()
PYTHON_EOF
    
    chmod +x "$PYTHON_CRACKER"
    print_success "Advanced cracker created with all format support"
    print_info "Fix 1: Brute force generation correct order (a-z, A-Z, 0-9, symbols)"
    print_info "Fix 2: 100% complete হলে automatic break এবং result দেখায়"
    print_info "Fix 3: Password verification function ঠিক করা হয়েছে (PDF, Excel, PowerPoint, Word সহ)"
    print_info "Fix 4: PDF decrypt function properly returns 1/2 for success"
    print_info "Fix 5: Excel XLS support added with xlrd"
    print_info "Fix 6: PowerPoint/Word use 7z as fallback"
}

# ============================================
# STEP 5: EXECUTE ATTACK
# ============================================

execute_attack() {
    clear_screen
    print_header "Starting Attack"
    
    if [[ ! -f "$PYTHON_CRACKER" ]]; then
        create_advanced+cracker
    fi
    
    case $ATTACK_MODE in
        "bruteforce")
            echo -e "${BLUE}[*]${NC} Starting brute force attack..."
            echo -e "${CYAN}File Type:${NC} $ZIP_TYPE"
            echo -e "${CYAN}Pattern:${NC} $PATTERN"
            echo -e "${CYAN}Charset:${NC} ${#CHARSET} characters"
            echo ""
            
            python3 "$PYTHON_CRACKER" "brute" "$CURRENT_FILE" "$ZIP_TYPE" "$CHARSET" "$PATTERN"
            ;;
        
        "dictionary"|"smartdict"|"personal")
            echo -e "${BLUE}[*]${NC} Starting dictionary attack..."
            echo -e "${CYAN}File Type:${NC} $ZIP_TYPE"
            echo -e "${CYAN}Dictionary:${NC} $(basename "$DICT_FILE")"
            echo -e "${CYAN}Dictionary Type:${NC} $DICT_TYPE"
            echo ""
            
            python3 "$PYTHON_CRACKER" "dict" "$CURRENT_FILE" "$ZIP_TYPE" "$DICT_FILE"
            ;;
    esac
    
    if [[ $? -eq 0 ]] && [[ -f "crack_result.txt" ]]; then
        echo ""
        print_success "Attack completed successfully!"
        echo ""
        echo -e "${CYAN}Result:${NC}"
        cat "crack_result.txt"
        
        if [[ -d "$OUTPUT_DIR" ]]; then
            echo ""
            echo -e "${CYAN}Extracted files in:${NC} $OUTPUT_DIR"
            ls -la "$OUTPUT_DIR" 2>/dev/null | head -20
        fi
    else
        echo ""
        print_error "Attack failed or password not found"
    fi
    
    echo ""
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read
}

# ============================================
# HELP SCREEN
# ============================================

show_help() {
    clear_screen
    print_header "Help & Instructions"
    
    echo -e "${WHITE}This tool can crack encrypted archives using:${NC}"
    echo ""
    echo -e "${GREEN}1. Brute Force Attack${NC}"
    echo "   - Specify character set"
    echo "   - Set password length"
    echo "   - Build pattern with known characters"
    echo "   - ✓ Fixed: Correct generation order (a-z, A-Z, 0-9, symbols)"
    echo ""
    echo -e "${GREEN}2. Dictionary Attack${NC}"
    echo "   - Use password list file"
    echo "   - Multiple dictionary types"
    echo "   - ✓ Fixed: 100% complete হলে automatic break"
    echo ""
    echo -e "${GREEN}3. Personal Information Attack${NC}"
    echo "   - Generate passwords from personal info"
    echo "   - Multiple mobile numbers support"
    echo "   - Name + Year (Minhaz2008)"
    echo "   - Name + Mobile (Sajim01852288884)"
    echo "   - Name + Girlfriend (MinhazPriya)"
    echo "   - 100+ advanced password patterns"
    echo "   - Smart mutations & variations"
    echo ""
    echo -e "${GREEN}4. Supported File Formats:${NC}"
    echo "   • Standard ZIP (zipcrypt)"
    echo "   • AES Encrypted ZIP (WinZip, 7-Zip AES)"
    echo "   • 7Z Archive (7-Zip format)"
    echo "   • RAR Archive (WinRAR)"
    echo "   • PDF Document (Adobe PDF) ✓ FIXED"
    echo "   • Excel File (XLS/XLSX) ✓ FIXED"
    echo "   • PowerPoint File (PPT/PPTX) ✓ FIXED (7z fallback)"
    echo "   • Word Document (DOC/DOCX) ✓ FIXED (7z fallback)"
    echo ""
    echo -e "${GREEN}5. Fixed Issues:${NC}"
    echo "   • Fix 1: Brute force generation correct order (a-z, A-Z, 0-9, symbols)"
    echo "   • Fix 2: 100% complete হলে automatic break এবং result দেখায়"
    echo "   • Fix 3: Password verification function ঠিক করা হয়েছে (PDF, Excel, PowerPoint, Word)"
    echo "   • Fix 4: PDF decrypt function properly returns 1/2 for success"
    echo "   • Fix 5: Excel XLS support added with xlrd"
    echo "   • Fix 6: PowerPoint/Word use 7z as fallback"
    echo ""
    echo -e "${YELLOW}Requirements:${NC}"
    echo "• Python3"
    echo "• pyzipper (for AES encryption)"
    echo "• unrar (for RAR support)"
    echo "• p7zip (for 7Z support)"
    echo "• PyPDF2 (for PDF support)"
    echo "• openpyxl (for Excel XLSX support)"
    echo "• xlrd (for Excel XLS support)"
    echo "• python-pptx (optional, for PowerPoint support - 7z fallback available)"
    echo "• python-docx (optional, for Word support - 7z fallback available)"
    echo ""
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read
}

# ============================================
# CLEANUP
# ============================================

cleanup() {
    rm -f generate_dict.py personal_generator.py smart_dict.py single_test.py extract_files.py 2>/dev/null
    rm -f personal_data.txt 2>/dev/null
    print_info "Cleanup completed"
}

# ============================================
# MAIN FLOW FUNCTION
# ============================================

main_flow() {
    # Step 1: Select file
    if ! select_file; then
        print_error "File selection cancelled"
        sleep 2
        return 1
    fi
    
    # Step 1A: Select file type
    select_file_type
    
    # Step 2: Select attack mode
    select_attack_mode
    
    # Step 3: Setup based on attack mode
    case $ATTACK_MODE in
        "bruteforce")
            if ! setup_brute_force; then
                print_error "Brute force setup cancelled"
                sleep 2
                return 1
            fi
            ;;
        "dictionary")
            setup_dictionary
            ;;
        "smartdict")
            setup_smart_dictionary
            ;;
        "personal")
            if ! setup_personal_info_attack; then
                print_error "Personal information setup failed"
                sleep 2
                return 1
            fi
            ;;
        "single")
            setup_single_test
            return 0
            ;;
    esac
    
    # Step 4: Show summary and execute
    if show_attack_summary; then
        execute_attack
    else
        print_info "Attack cancelled"
        sleep 1
    fi
    
    return 0
}

# ============================================
# MAIN PROGRAM
# ============================================

main() {
    trap cleanup EXIT
    
    check_requirements
    
    while true; do
        clear_screen
        
        echo -e "${PURPLE}"
        echo "╠══════════════════════════════════════════════╣"
        echo "║                                              ║"
        echo "║   1. Start Password Cracker                 ║"
        echo "║   2. Test Single Password                   ║"
        echo "║   3. Check Requirements                     ║"
        echo "║   4. View Help                              ║"
        echo "║   5. Exit                                   ║"
        echo "║                                              ║"
        echo "╚══════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo ""
        
        echo -e "${CYAN}Select option [1-5]:${NC}"
        read choice
        
        case $choice in
            1)
                main_flow
                ;;
            2)
                clear_screen
                print_header "Single Password Test"
                
                if select_file; then
                    select_file_type
                    ATTACK_MODE="single"
                    setup_single_test
                fi
                ;;
            3)
                check_requirements
                echo ""
                echo -e "${CYAN}Press Enter to continue...${NC}"
                read
                ;;
            4)
                show_help
                ;;
            5)
                print_success "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option"
                sleep 1
                ;;
        esac
    done
}

# ============================================
# START
# ============================================

clear_screen
main