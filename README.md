#DB Helper
A wrapper around `mysql`. It requires a `.dbheperrc` file in the current directory which contains the credentials needed to connect to a database. The format is:

```
db_name=sequelize
db_user=root
db_password=asdasd
```

Once this is done, it can be aliased to something easier to type:

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