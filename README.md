#DB Helper

For when you need to shell into `mysql` frequently. To avoid having to type
the credentials every time, this script reads them from a file and runs the
query passed as a parameter.

To start using it:

`dbhelper.bash init ~/my_database_config`

That will create `~/my_database_config`:

```
db_name=my_database
db_user=root
db_password=my_password
```

Then, the file needs to be selected:

`dbhelper.bash use ~/my_database_config`

Once this is done, it should be ready to use:

`dbhelper.bash "delete from Users where id=1;"`

All subsequent queries will be run with the last selected file. Of course,
multiple config files can be created, and with `use` it is possible to
alternate between them.

```
alias dbh=./dbhelper.bash
```

Then, the following commands can be run:

````
dbh ls - show all tables
dbh reset - will drop the database and then create it
dbh rm <table> - drop table
dbh desc <table> - describe table
dbh cat <table> - show all rows in table
dbh count <table> - count all rows in table
dbh tree - show all tables and all rows
````

There's also a bash completion script which will auto-complete table names. Note
that it assumes `dbhelper.bash` as aliased as `dbh`. Also, completed table names are case-sensitive, unfortunatelly. To enable auto-completion:

```
source complete-dbhelper.bash
```
