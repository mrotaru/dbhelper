#!/bin/bash

# link to github repository
remote="https://raw.githubusercontent.com/mrotaru/dbhelper/master/"

# which files are to be copied
files=(
 complete-dbhelper.bash
 dbhelper.bash
 )

# set download method - curl or wget
command -v curl >/dev/null 2>&1
if [ $? -eq 0 ]; then
   get_method="curl"
else
    command -v wget >/dev/null 2>&1
    [ $? -eq 0 ] && get_method="wget"
fi
[ -z "$get_method" ] && { echo "Neither wget nor curl found. Exiting..."; exit 1; }

# download a single file in the current directory
function get_file()
{
    case "$get_method" in
        "curl") curl -s --write-out "%{url_effective} %{http_code}\n" -O "$1" ;;
        "wget") wget --no-verbose "$1" -O "$2" ;;
    esac
    RET=$?
    [ $RET -ne 0 ] && { echo "$get_method failed - returned: $RET. Exiting..."; exit 1; } 
}

# iterate over $files, build URL and download each one
for file in "${!files[@]}"; do
    url="${remote}${files[file]}"
    get_file "$url" "${files[file]}"
done
