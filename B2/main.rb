require 'sinatra'
require 'slim'

require 'sinatra/activerecord'
require './config/environments'
# require './service/service_initialize'
require './models/Message'
require './models/User'

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
  if @return == 'password error!' || @return == "user: #{username} does not exists!" # 如果返回值是错误信息
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
