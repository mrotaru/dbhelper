#DB Helper

For when you need to shell into `mysql` frequently. To avoid having to type
the credentials every time, this script reads them from a file and runs the
query passed as a parameter.

Install in current directory:

```
curl http://goo.gl/ZZqD91 -L -o - | bash 
sudo chmod +x dbhelper.bash
```

Setup credentials for a database:

`dbhelper.bash init ~/my_database_config`

That will create `~/my_database_config`:

```
db_name=my_database
db_user=root
db_password=my_password
```

This file needs to be updated with the correct credentials. Mutliple such files can
be created with `init`; the last created one will be automatically used. To use a different
one: `dbheper.bash use ~/another_db_config` (this will simply write `~/another_db_config` to
`~/.dbhelper_use`, which is read by `dbheper` every time it runs).

Usage:

```
dbhelper.bash ls - show all tables
dbhelper.bash reset - will drop the database and then create it
dbhelper.bash rm <table> - drop table
dbhelper.bash desc <table> - describe table
dbhelper.bash cat <table> - show all rows in table
dbhelper.bash count <table> - count all rows in table
dbhelper.bash tree - show all tables and all rows
`dbhelper.bash "delete from Users where id=1;"`
```

There's also a bash completion script which will auto-complete table names.
Note that it assumes `dbhelper.bash` as aliased as `dbh`. Also, completed table
names are case-sensitive, unfortunatelly. To enable auto-completion:

```
alias dbh=./dbhelper.bash
source complete-dbhelper.bash
```
