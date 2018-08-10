require 'digest/sha1'

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
