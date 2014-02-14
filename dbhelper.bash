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
    mysql $2 --user=$db_user --password=$db_password -e "$1" $db_name
}

# same as above, but no db specified
function query_no_db {
    mysql $2 --user=$db_user --password=$db_password -e "$1"
}

case $1 in
    'ls')
        if [ -z "$2" ]
        then query "show tables"
        else query "select * from $2"
        fi
        ;;
    'reset')
        query_no_db "drop database $db_name"
        query_no_db "create database $db_name"
        ;;
    'rm')
        [ -z "$2" ] && { echo "Please specify table"; exit 1; }
        query "drop table $2"
        ;;
    'cat')
        [ -z "$2" ] && { echo "Please specify table"; exit 1; }
        query "select * from $2"
        ;;
    *)
        query $1
        ;;
esac
[ -n "$debug" ] && { set +o xtrace; }
