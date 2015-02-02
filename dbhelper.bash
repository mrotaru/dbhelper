#!/bin/bash

# the idea is to be able to do stuff like:
# db ls - show all tables
# db cat <table_name> - show all rows in table

# uncomment to show executed commands
#debug=1

# config file
configfile=""
if [ -f ~/.dbhelper_use ]; then
    configfile=$(head -n 1 ~/.dbhelper_use)
else
    [ -f "~/.dbhelperrc" ] && configfile="~/.dbhelperrc"
    [ -f "./.dbhelperrc" ] && configfile="./.dbhelperrc"
fi

[ -z $configfile ] && [ $1 != "init" ] && [ $1 != "use" ] && { echo "No config file, cannot connect to database."; exit 1; }
[ -z $configfile ] && [ $1 == "init" ] && [ -z $2 ] && { echo "Please provide a name: dbhelper.bash init <my_database>"; exit 1; }

# read config
# -----------
# from: http://stackoverflow.com/a/4434930/447661
readconfig() {
    [ -n "$debug" ] && echo "reading config file: $configfile"
    COMMENT_RE='*( )#*'
    shopt -s extglob
    while IFS='= ' read lhs rhs
    do
        if [[ $lhs != $COMMENT_RE ]]
        then
            [ -n "$debug" ] && echo "setting: $lhs = $rhs"
            declare -g $lhs=$rhs
        fi
    done < "$1"
}

[ $1 != "init" ] && [ $1 != "use" ] && readconfig "$configfile"

[ -n "$debug" ] && { set -o xtrace; }

# execute query using username/password from config file
# $1 - query to execute
function query {
    [ -n "$debug" ] && echo "query: db_name: $db_name"
    mysql $2 --user=$db_user --password=$db_password -e "$1" $db_name
}

# same as above, but no db specified
function query_no_db {
    mysql $2 --user=$db_user --password=$db_password -e "$1"
}

# show all tables and all rows for each table
function tree {
    tables=$(mysql -ss --user=$db_user --password=$db_password -e "show tables" $db_name)
    for table in $tables; do
        echo -e "\n"$table
        query "select * from $table"
    done
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
    'desc')
        [ -z "$2" ] && { echo "Please specify table"; exit 1; }
        query "describe $2"
        ;;
    'cat')
        [ -z "$2" ] && { echo "Please specify table"; exit 1; }
        query "select * from $2"
        ;;
    'count')
        [ -z "$2" ] && { query "SELECT table_name, TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = \"$db_name\""; exit 0; }
        query "select count(*) from $2" "-ss"
        ;;
    'tree')
        tree
        ;;
    'use')
        [ ! -f ~/.dbhelper_use ] && touch ~/.dbhelper_use
        echo "using: $2"
        echo "$2">~/.dbhelper_use
        ;;
    'sh')
        mysql --user=$db_user --password=$db_password $db_name
        ;;
    'export')
        mysqldump --user=$db_user --password=$db_password $db_name > $2
        ;;
    'import')
        mysql --user=$db_user --password=$db_password $db_name < $2
        ;;
    'init')
        [ ! -f "$2" ] && touch "$2"
        tee "$2"<<EOF
db_name=my_database
db_user=root
db_password=my_password
EOF
        [ ! -f ~/.dbhelper_use ] && touch ~/.dbhelper_use
        echo "using: $2"
        echo "$2">~/.dbhelper_use
        ;;
    *)
        query "$1"
        ;;
esac
[ -n "$debug" ] && { set +o xtrace; }
