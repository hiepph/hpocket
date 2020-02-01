desc "Initialize database"
task :db do
  sh "sqlite3 ~/pocket.db 'CREATE VIRTUAL TABLE links USING FTS5(link, title, content);'"
end
