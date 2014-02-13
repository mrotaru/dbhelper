#!/bin/bash

# the idea is to be able to do stuff like:
# db ls - show all tables
# db cat <table_name> - show all rows in table

# uncomment to show executed commands
#debug=1

# read config
# -----------
# from: http://stackoverflow.com/a/4434930/447661
configfile=".dbhelperrrc"
shopt -s extglob
while IFS='= ' read lhs rhs
do
    if [[ $lhs != *( )#* ]]
    then
        # you can test for variables to accept or other conditions here
        declare $lhs=$rhs
    fi
done < "$configfile"

[ -n "$debug" ] && { set -o xtrace; }

# execute query using username/password from config file
# $1 - query to execute
function query {
    mysql --user=$db_user --password=$db_password -e "$1" $db_name
}

case $1 in
    'ls')
        query "show tables"
        ;;
    'reset')
        query "drop database $db_name"
        query "create database $db_name"
        ;;
    *)
        query $1
        ;;
esac
[ -n "$debug" ] && { set +o xtrace; }
