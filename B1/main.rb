require 'sinatra'
require 'slim'

get '/' do
  slim :home # 主页
end
post '/' do
  message = Message.new
  message.start # 打印所有留言
end

get '/add' do
  slim :add # 留言添加界面
end
post '/add' do
  @add_message = params[:message]
  @add_author = params[:author]
  message = Message.new
  @id, @message, @author, @created_at = message.add(@add_author, Time.now, @add_message) # 进行添加并return一些数据
  slim :add_post # 显示已经添加的信息
end

get '/delete/:id' do |id|
  message = Message.new
  message.delete(id) # 删除某个指定的id
  message.start # 再打印所有的留言（也就是刷新页面）
end

get '/delete' do
  slim :delete  # 留言删除界面
end
post '/delete' do
  id_to_delete = params[:ids]
  message = Message.new
  @arr, @flag = message.delete(id_to_delete) # 删除留言（1或多个）并return一些数据
  slim :delete_post # 显示删除的结果
end

get '/search' do
  slim :search # 留言查找界面（所有留言）
end
post '/search' do
  message = Message.new
  message.start # 显示所有留言，按时间/id倒序输出
end

get '/search/id' do
  slim :search_id # 查找某个指定id的留言
end
post '/search/id' do
  message = Message.new
  @id, @arr, @mes = message.search_id(params[:id]) # 查找并return一些数据给模板使用
  slim :search_id_post # 显示查找结果
end

get '/search/author' do
  slim :search_author # 查找某个指定author界面
end
post '/search/author' do
  message = Message.new
  message.search_author(params[:author]) # 查找并显示查找结果
end

class Message
  def initialize
    Dir.mkdir('author') unless File.directory? 'author' # 创建目录author，存放以author命名的文件
    Dir.mkdir('id') unless File.directory? 'id' # 创建目录id，存放以id命名的文件
    num_of_id = File.new('num', 'a+') # 创建num文件用于保存有多少条message
    num_of_id.syswrite('0') if File.zero?('num') # 如果是第一次创建num文件
    num_of_id.close
  end

  def start
    arr = IO.readlines('num') # 读取num文件中的数据
    n = arr[0].to_i # 有多少条留言，准确来说是当前最大的留言id
    str =
      "
      <center>
        <h1> All Message <br>
      </center>
      <center>
        <button type='button' onclick='location.href=&quot;/search/id&quot;'>search by id</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <button type='button' onclick='location.href=&quot;/search/author&quot;'>search by author</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <button type='button' onclick='location.href=&quot;/&quot;'>Back to the Home</button><br><br>
      </center>
      <center>
        <table border='1' width='96%'>
          <tr>
            <td width='3%' align='center'>id</td>
            <td width='31%' align='center'>created_at</td>
            <td width='10%' align='center'>author</td>
            <td width='45%' align='center''>message</td>
            <td width='7%' align='center'>del</td>
          </tr>
        </table>
      </center>"
    while n != 0 # 从最大留言开始，如果该留言还存在，就打印
      if File.exist?("id/#{n}") # 是否存在该id
        arr = IO.readlines("id/#{n}")
        i = 2
        mes = '' # 留言
        while i < arr.size
          mes += arr[i]
          i += 1
        end
        str += "
        <div style='display:block;'>
          <center>
            <table border='1' width='96%'>
              <tr>
                <td width='3%' align='center'>#{n}</td>
                <td width='31%' align='center'>#{arr[1]}</td>
                <td width='10%' align='center'>#{arr[0]}</td>
                <td width='45%'>#{mes}</td>
                <td width='7%' align='center'><button type='button' id='#{n}' onclick='location.href=&quot;/delete/#{n}&quot;'>del</button></td>
              </tr>
            </table>
          </center>
        </div>
        "
      end
      n -= 1
    end
    str += "<br><center><button type='button' onclick='location.href=&quot;/&quot;'>Back to the Home</button></center>"
    str
  end

  def add(add_author, add_time, add_message)
    @author = add_author # 作者
    @created_at = add_time  # 添加时间
    @message = add_message  # 留言
    num_of_id = File.new('num', 'r+') # 当前最大留言id
    arr = IO.readlines('num')

    @id = arr[0].to_i + 1 # 新增的留言id为当前最大留言id+1
    num_of_id.syswrite(@id) # 更新num文件
    num_of_id.close
    # 在id目录下，创建文件并保存如下信息
    save = File.new("id/#{@id}", 'a+')
    save.syswrite("#{@author}\n")
    save.syswrite("#{@created_at}\n")
    save.syswrite("#{@message}\n")
    save.close
    # 在author目录下，创建文件/保存该读者新创建的留言id
    save = File.new("author/#{@author}", 'a+')
    save.syswrite("#{@id}\n")
    save.close
    [@id, @message, @author, @created_at]
  end

  def delete(delete_id)
    arr = delete_id.split(' ')  # 分割字符（分割id）
    flag = Array.new(arr.size)  # 用于保存arr里对应的id是否存在（true/false）
    k = 0
    arr.each do |id|
      if File.exist?("id/#{id}") # 是否存在该id？
        File.delete("id/#{id}") # 删除
        flag[k] = true  # 在flag对应的位置保存该id是否存在的信息
      else
        flag[k] = false # 在flag对应的位置保存该id是否存在的信息
      end
      k += 1
    end
    [arr, flag]
  end

  def search_id(id)
    if File.exist?("id/#{id}") # 如果存在该id
      arr = IO.readlines("id/#{id}") # 读取文件的数据

      mes = '' # 留言
      i = 2
      while i < arr.size
        mes += arr[i]
        i += 1
      end

    end
    [id, arr, mes]
  end

  def search_author(author)
    str = "
          <center>
            <h1> Search Results <br>
          </center>"
    if File.exist?("author/#{author}") # 如果存在该作者
      num = IO.readlines("author/#{author}") # 读取该作者已经创建的所有留言id
      num.each do |id|
        next unless File.exist?("id/#{id.chomp}") # 对每一个id，如果还存在，就读取对应的文件并显示相关的留言信息
        arr = IO.readlines("id/#{id.chomp}")

        mes = '' # 留言
        i = 2
        while i < arr.size
          mes += arr[i]
          i += 1
        end

        str += "
              <center>
                <table border='1' width='95%'>
                  <tr> <td>id:</td> <td>#{id.chomp}</td> </tr>
                  <tr> <td>author:</td> <td>#{arr[0]}</td> </tr>
                  <tr> <td>created_at:</td> <td>#{arr[1]}</td> </tr>
                  <tr> <td>message:</td> <td>#{mes}</td> </tr>
                  </table>
              </center>
              <br>
              "
      end
      str += "
          <center>
            <br>
            <button type='button' onclick='location.href=&quot;/&quot;'>Back to the HOme</button>
          </center>"
    else
      str += "
          <center>
            <text>抱歉，不存在该读者的信息</text>
            <br><br>
            <button type='button' onclick='location.href=&quot;/&quot;'>Back to the HOme</button>
          </center>"
    end
    str
  end
end
