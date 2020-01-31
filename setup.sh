# create db
db_path=$HOME/db/pocket.db
if ! test -f $db_path; then
    sqlite3 $db_path "CREATE VIRTUAL TABLE links USING FTS5(link, title, content);"
else
    echo "$db_path existed. Cancel."
fi
