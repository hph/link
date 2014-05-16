if File.exists?('./config/database.yml')
  db = YAML.load_file('./config/database.yml')
  ActiveRecord::Base.establish_connection(
    adapter:  db['adapter'],
    host:     db['host'],
    username: db['username'],
    password: db['password'],
    database: db['database'],
    encoding: 'utf8'
  )
else
  abort 'Fatal error - no database configuration specified.'
end
