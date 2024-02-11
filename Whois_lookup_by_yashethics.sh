#!/bin/bash

# Function to display the fancy welcome message
display_welcome_message() {
    # ANSI escape codes for darker purple color and increased font size
    PURPLE='\033[0;35m'
    BOLD='\033[1m'
    NC='\033[0m' # No Color

    echo -e "${PURPLE}${BOLD}"
    echo "   _______  _______             _______ _________         _________ _______  _______ "
    echo "  |\     /|(  ___  )(  ____ \|\     /|  (  ____ \\__   __/|\     /|\__   __/(  ____ \(  ____ \\"
    echo "  ( \   / )| (   ) || (    \/| )   ( |  | (    \/   ) (   | )   ( |   ) (   | (    \/| (    \/"
    echo "   \ (_) / | (___) || (_____ | (___) |  | (__       | |   | (___) |   | |   | |      | (_____ "
    echo "    \   /  |  ___  |(_____  )|  ___  |  |  __)      | |   |  ___  |   | |   | |      (_____  )"
    echo "     ) (   | (   ) |      ) || (   ) |  | (         | |   | (   ) |   | |   | |            ) |"
    echo "     | |   | )   ( |/\____) || )   ( |  | (____/\   | |   | )   ( |___) (___| (____/\/\____) |"
    echo "     \_/   |/     \|\_______)|/     \|  (_______/   )_(   |/     \|\_______/(_______/\_______)"
    echo "                                                                                               "
    echo -e "${NC}"

    echo "Welcome to YashEthics Toolbox"
}

# Function to extract domain from URL
extract_domain() {
    local url="$1"
    # Removing 'http://' or 'https://'
    url="${url#*://}"
    # Extracting domain from the remaining string
    domain=$(echo "$url" | cut -d'/' -f1)
}

# Check if domains file is provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <domains_file>"
    exit 1
fi

# Call the function to display the fancy welcome message
display_welcome_message

domains_file="$1"

# Check if domains file exists
if [ ! -f "$domains_file" ]; then
    echo "Error: Domains file '$domains_file' not found."
    exit 1
fi

# Ask the user for the output filename
echo "Enter the name of the output file:"
read output_filename

output_file="$output_filename.txt"

# Perform WHOIS lookup for each domain or URL in the file
while IFS= read -r line; do
    echo "Performing WHOIS lookup for $line..."
    if [[ "$line" == http* ]]; then
        extract_domain "$line"
        whois "$domain" >> "$output_file" || echo "WHOIS lookup failed for $domain"
    else
        whois "$line" >> "$output_file" || echo "WHOIS lookup failed for $line"
    fi
    echo "--------------------------------------" >> "$output_file"
done < "$domains_file"

echo "WHOIS lookup results saved to '$output_file'."
