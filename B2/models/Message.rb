class Message < ActiveRecord::Base
  def self.home
    find_by_sql('select * from messages order by id desc') # 读取所有留言，并返回
  end

  def self.add(content, user_id)
    create(content: content, user_id: user_id) # 添加
  end

  def delete(id)
    delete(id: id) # 删除留言id为该id的留言
  end

  def self.print(user_id)
    find_by_sql("select * from messages where user_id=#{user_id} order by id desc") # 读取所有留言，并返回
  end
end
