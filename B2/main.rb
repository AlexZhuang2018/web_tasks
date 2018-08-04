require 'sinatra'
require 'slim'
require 'mysql2'
require 'active_record'
require 'rubygems'
require 'digest/sha1'

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
client.query('CREATE table IF NOT EXISTS users (id int primary key auto_increment, username char(20), password char(40))')
# 如果不存在messages表，则创建留言表messages，并设置user_id为主键
client.query('CREATE table IF NOT EXISTS messages (id int primary key auto_increment, content char(200), user_id int, created_at TIMESTAMP)')

configure do
  enable :sessions
  set :session_secret, '123' # 设置session密码为：123
end

after do
  ActiveRecord::Base.connection.close # 每次处理完请求之后断开
end

get '/' do
  slim :start # 显示登录和注册按钮
end

get '/login' do
  slim :login
end
post '/login' do
  username = params[:username]
  password = params[:password]
  @return = User.login(username, password) # 调用登录函数，并接受登录结果信息
  if @return == 'password error!' || @return == "user: #{username} do not exists!" # 如果返回值是错误信息
    slim :login_result # 显示错误信息
  else # 如果返回值是用户id
    session[:id] = @return # 存入session
    redirect '/home'
  end
end

get '/register' do
  slim :register
end
post '/register' do
  username = params[:username]
  password = params[:password1]
  @return = User.register(username, password) # 调用注册函数，并接受注册结果信息
  slim :register_result # 显示注册结果
end

get '/logout' do
  session.clear # 清空session
  redirect '/' # 重定向至登录界面
end

get '/home' do
  @result = Message.home
  slim :home
end

get '/add' do
  slim :add # 留言添加界面
end
post '/add' do
  @content = params[:message]
  @user_id = session[:id]
  Message.add(@content, @user_id) # 进行添加并return一些数据
  slim :add_post # 显示已经添加的信息
end

get '/search' do
  slim :search
end
post '/search' do
  @username = params[:author]
  user_id = User.where(username: @username)[0]['id']
  @return = Message.print(user_id) # 读取该用户所有的留言，并接受返回信息
  slim :search_result
end

get '/delete/:id' do
  Message.delete(params[:id]) # 删除该留言
  redirect '/my_home' # 重定向（即刷新‘/print’）
end

get '/my_home' do
  @return = Message.print(session[:id]) # 读取该用户所有的留言，并接受返回信息
  slim :my_home # 显示该用户的所有留言信息
end

get '/change_password' do
  slim :change_password
end
post '/change_password' do
  old_password = params[:old_password]
  new_password = params[:new_password1]
  @return = User.change_password(session[:id], old_password, new_password) # 更改密码，并接受更改结果
  slim :change_password_result # 显示更改结果
end

ActiveRecord::Base.establish_connection(adapter: 'mysql2',
                                        host: 'localhost',
                                        database: 'web_tasks',
                                        username: 'root',
                                        password: '')
class User < ActiveRecord::Base
  def self.login(username, password)
    result = where(username: username)
    if !result.empty?
      if result[0]['password'] == Digest::SHA1.hexdigest(password)
        return result[0]['id']
      else
        return 'password error!'
      end
    else
      return "user: #{username} does not exists!"
    end
  end

  def self.register(username, password)
    # 是否已经存在该用户名？
    result = where(username: username)
    if result.empty? # 不存在则插入数据，并返回注册结果
      create(username: username, password: Digest::SHA1.hexdigest(password))
      return '注册成功！'
    else # 存在则返回错误信息
      return '该用户名已经存在！'
    end
  end

  def self.change_password(id, old_password, new_password)
    result = where(id: id)[0]
    if result['password'] == Digest::SHA1.hexdigest(old_password)
      user = User.find(id)
      user.update_attribute(:password, Digest::SHA1.hexdigest(new_password)) # 更改密码
      return '密码修改成功！'
    else
      return '原密码错误！'
    end
  end
end

class Message < ActiveRecord::Base
  def self.home
    result = find_by_sql('select * from messages') # 读取所有留言
    result = result.reverse
    result # 返回
  end

  def self.add(content, user_id)
    create(content: content, user_id: user_id) # 添加
  end

  def delete(id)
    delete(id: id) # 删除留言id为该id的留言
  end

  def self.print(user_id)
    result = where(user_id: user_id) # 寻找user_id为该用户的有关留言
    result = result.reverse
    result # 返回
  end
end
