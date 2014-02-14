_dbh() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="ls rm reset cat desc"

    # read config - from: http://stackoverflow.com/a/4434930/447661
    configfile=".dbhelperrrc"
    shopt -s extglob
    while IFS='= ' read lhs rhs
    do
        if [[ $lhs != *( )#* ]]
        then
            declare $lhs=$rhs
        fi
    done < "$configfile"

    case "${prev}" in
        "rm" | "cat" | "ls" | "desc" )
            # get table names
            local table_names=$(mysql --user=$db_user --password=$db_password -ss -e'show tables' $db_name)

            # complete
            COMPREPLY=( $(compgen -W "${table_names}" -- ${cur}) )
            return 0
            ;;
    esac

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  
    return 0
}
complete -F _dbh dbh
