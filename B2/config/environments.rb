ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'web_tasks',
  username: 'root',
  password: '',
  host: 'localhost',
  encoding: 'utf8'
)
