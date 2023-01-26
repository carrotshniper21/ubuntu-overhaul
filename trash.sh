#!/bin/bash

# This function checks if the system is Debian-based
check_system() {
    if [ ! -f /etc/debian_version ]; then
        echo "This script is for Debian-based systems only. Exiting..."
        exit 1
    fi
}

# This function removes unnecessary packages based on user input
remove_unnecessary_packages() {
    # $1 is the user input (y/n) to remove unnecessary packages
    if [ "$1" == "y" ]; then
        sudo apt autoremove -y
    fi
}

# This function creates a list of installed packages and removes text after the backslash based on user input
create_list_of_installed_packages() {
    # Creating a list of installed packages
    apt list --installed > output.txt

    # $1 is the user input (y/n) to remove everything after the backslash
    if [ "$1" == "y" ]; then
        sed 's//.//' output.txt > parsed.txt
    fi
}

# This function counts the number of packages and inserts it at the top of the file
count_and_insert_packages() {
    line_count=$(wc -l < parsed.txt)
    echo "PACKAGE COUNT: $line_count" | cat - parsed.txt > temp.txt
    mv temp.txt parsed.txt
}

# This function removes 'Listing...' from the file
remove_text_from_file() {
    sed -i 's/Listing...//g' parsed.txt
}

main() {
    check_system
    # $1 is the user input (y/n) to remove unnecessary packages
    # $2 is the user input (y/n) to remove everything after the backslash
    remove_unnecessary_packages "$1"
    create_list_of_installed_packages "$2"
    count_and_insert_packages
    remove_text_from_file
    cat parsed.txt
}

main "$1" "$2"
