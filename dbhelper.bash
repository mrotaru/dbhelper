#!/bin/bash

# the idea is to be able to do stuff like:
# db ls - show all tables
# db cat <table_name> - show all rows in table

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

#echo $db_name;
#echo $db_user;
#echo $db_password;

function query {
    mysql --user=$db_user --password=$db_password -e $1 $db_name
}

#set -o xtrace
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
#set +o xtrace
