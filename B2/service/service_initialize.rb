require 'mysql2'

# 以下到空行为初始化数据库
client = Mysql2::Client.new
# 如果数据库:web_tasks不存在就创建该数据库
client.query('CREATE DATABASE IF NOT EXISTS web_tasks')
client = Mysql2::Client.new(
  host: 'localhost', # 主机
  username: 'root', # 用户名
  password: '', # 密码
  database: 'web_tasks', # 数据库
  encoding: 'utf8' # 编码
)
# 如果不存在users表，则创建用户表users，并设置id为主键
client.query('CREATE table IF NOT EXISTS users (id int primary key auto_increment not null, username char(20), password char(40), INDEX(username))')
# 如果不存在messages表，则创建留言表messages，并设置user_id为主键
client.query('CREATE table IF NOT EXISTS messages (id int primary key auto_increment, content char(200), user_id int, created_at TIMESTAMP, INDEX(user_id))')
