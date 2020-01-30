# create db
if ! test -f pocket.db; then
    sqlite3 pocket.db "CREATE VIRTUAL TABLE pocket USING FTS5(title, content);"
fi
