# create db
if ! test -f pocket.db; then
    sqlite3 pocket.db "CREATE VIRTUAL TABLE links USING FTS5(link, title, content);"
else
    echo "pocket.db existed. Cancel."
fi
