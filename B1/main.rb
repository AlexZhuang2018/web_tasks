require 'sinatra'
require 'slim'

get '/' do
  slim :start
end
post '/' do
  message = Message.new
  message.start
end

get '/add' do
  slim :add
end
post '/add' do
  @add_message = params[:message]
  @add_author = params[:author]
  message = Message.new
  message.add(@add_author, Time.now, @add_message)
end

get '/delete/:id' do |id|
  message = Message.new
  message.delete(id)
  message.start
end

get '/delete' do
  slim :delete
end
post '/delete' do
  id_to_delete = params[:ids]
  message = Message.new
  message.delete(id_to_delete)
end

get '/search' do
  slim :search
end
post '/search' do
  message = Message.new
  message.start
end

get '/search/id' do
  slim :search_id
end
post '/search/id' do
  message = Message.new
  message.search_id(params[:id])
end

get '/search/author' do
  slim :search_author
end
post '/search/author' do
  message = Message.new
  message.search_author(params[:author])
end

class Message
  def initialize
    Dir.mkdir('author') unless File.directory? 'author' # 创建目录author，存放以author命名的文件
    Dir.mkdir('id') unless File.directory? 'id' # 创建目录id，存放以id命名的文件
    num_of_id = File.new('num', 'a+') # 创建num文件用于保存有多少条message
    num_of_id.syswrite('0') if File.zero?('num')
    num_of_id.close
  end

  def start
    file = File.new('num', 'a+')
    arr = IO.readlines('num')
    n = arr[0].to_i
    file.close
    str =
      "
      <center>
        <h1> All Message <br>
      </center>
      <center>
        <button type='button' onclick='location.href=&quot;/search/id&quot;'>search by id</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <button type='button' onclick='location.href=&quot;/search/author&quot;'>search by author</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <button type='button' onclick='location.href=&quot;/&quot;'>Back to the Home</button><br><br>
      </center>"
    str += "<center>
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
    while n != 0
      if File.exist?("id/#{n}")
        arr = IO.readlines("id/#{n}")
        i = 2
        mes = ''
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
        n -= 1
      else
        n -= 1
      end
    end
    str += "<br><center><button type='button' onclick='location.href=&quot;/&quot;'>Back to the Home</button></center>"
    str
  end

  def add(add_author, add_time, add_message)
    add_author = 'NULL' if add_author.empty?
    add_message = 'NULL' if add_message.empty?
    @author = add_author
    @created_at = add_time
    @message = add_message
    num_of_id = File.new('num', 'r+')
    arr = IO.readlines('num')
    puts arr[0].to_i
    @id = arr[0].to_i + 1
    num_of_id.syswrite(@id)
    num_of_id.close
    # 存入文件
    save = File.new("id/#{@id}", 'a+')
    save.syswrite("#{@author}\n")
    save.syswrite("#{@created_at}\n")
    save.syswrite("#{@message}\n")
    save.close

    save = File.new("author/#{@author}", 'a+')
    save.syswrite("#{@id}\n")
    save.close

    "<center>
    <table border='1'>
      <tr><td>Your id is:</td><td>#{@id}</td></tr>
      <tr><td>Your message is:</td><td>#{@message}</td></tr>
      <tr><td>Your name is:</td><td>#{@author}</td></tr>
      <tr><td>You creat it at:</td><td>#{@created_at}</td></tr>
    </table>
    <br>
    <button type='button' onclick=\"location.href='/'\">
    OK>>
    </button>
    </center>
    "
  end

  def delete(delete_id)
    arr = delete_id.split(' ')
    str = ''
    arr.each do |id|
      if File.exist?("id/#{id}")
        File.delete("id/#{id}")
        str += "<center>成功删除id为#{id}的留言<br></center>"
      else
        str += "<center>id为\'#{id}\'的留言已经删除或还未添加或您的输入格式有误<br></center>"
      end
    end
    str += "<center><button type='button' onclick='location.href=&quot;/&quot;'>  Back to the Home  </button></center>"
    str
  end

  def search_id(id)
    str = ''
    if File.exist?("id/#{id}")
      arr = IO.readlines("id/#{id}")
      mes = ''
      i = 2
      while i < arr.size
        mes += arr[i]
        i += 1
      end
      str = "
          <center>
            <h1> Search Results <br>
          </center>
          <center>
            <table border='1' width='95%'>
              <tr> <td>id:</td> <td>#{id}</td> </tr>
              <tr> <td>author:</td> <td>#{arr[0]}</td> </tr>
              <tr> <td>created_at:</td> <td>#{arr[1]}</td> </tr>
              <tr> <td>message:</td> <td>#{mes}</td> </tr>
            </table>
            <br>
            <button type='button' onclick='location.href=&quot;/&quot;'>Back to the HOme</button>
          </center>"
    else
      str = "
          <center>
            <h1> Search Results <br>
          </center>
          <center>
          <text>抱歉，该id已经删除或还未添加</text>
          <br><br>
          <button type='button' onclick='location.href=&quot;/&quot;'>Back to the HOme</button>
          </center>"
    end
    str
  end

  def search_author(author)
    str = "
          <center>
            <h1> Search Results <br>
          </center>"
    if File.exist?("author/#{author}")
      num = IO.readlines("author/#{author}")
      num.each do |id|
        next unless File.exist?("id/#{id.chomp}")
        arr = IO.readlines("id/#{id.chomp}")
        mes = ''
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
