#!/usr/bin/ruby
class Student
  # initialize
  def initialize
    opfile = File.new('Student', 'a+')
    if File.zero?('Student')    # 如果是空文件，则写入随机数据
      i = 0
      num_of_students = 0       # 第几个学生
      while i < 100
        i += 1
        num_of_students += 1    # 学生总数加一
        id = num_of_students    # 学生的id就是第几个学生
        name = newpass(5)
        n = rand(1..2)         # 用于随即生成性别
        gender = if n == 1     # 如果是1@gender赋值man
                   'man'
                 else          # 否则赋值woman
                   'woman'
                  end
        age = rand(15..20)     # 随机年龄
        # 写入文件
        opfile.syswrite("#{id}\n")
        opfile.syswrite("#{name}\n")
        opfile.syswrite("#{gender}\n")
        opfile.syswrite("#{age}\n")
      end
    end
    function_select # 进入功能选择界面
  end

  # 功能选择
  def function_select
    puts '********************学生信息管理系统********************'
    puts '**功能选择**'
    puts "增加学生信息输入：\t1\n"
    puts "删除学生信息输入：\t2\n"
    puts "更改学生信息请输入:\t3\n"
    puts "查询学生信息输入：\t4\n"
    puts "打印所有学生信息输入：\t5\n"
    puts "退出输入：\t\t0(或其他)\n"
    puts '请输入：'
    n = gets    # 接受输入
    n = n.to_i  # 更改数据类型
    if n == 1
      add       # 进入学生添加界面
    elsif n == 2
      delete    # 进入学生删除界面
    elsif n == 3
      change    # 进入学生信息更改界面
    elsif n == 4
      search    # 进入学生查询界面
    elsif n == 5
      print_info # 进入信息打印界面
    else
      exit # 结束程序
    end
  end

  # add
  def add
    # 写入文件
    puts "**学生添加**\n"
    id = nil
    name = nil
    gender = nil
    age = nil
    # 添加id
    for i in 1..1
      puts '清输入要添加的学生的id：'
      id = gets
      arr = IO.readlines('Student')
      flag = false
      j = 0
      while j < arr.size
        flag = true if arr[j].chomp == id.chomp
        j += 4
      end
      if flag
        puts '该id已经存在，清重新输入！'
        redo
      end
    end
    # 添加name
    puts '请输入要添加的学生的name：'
    name = gets
    # 添加gender
    for i in 1..1
      puts '请输入要添加的学生的gender（man or woman）:'
      gender = gets
      if (gender.chomp != 'man') && (gender.chomp != 'woman')
        puts '输入错误！请重新输入！'
        redo
      end
    end
    # 添加age
    for i in 1..1
      puts '请输入要添加的学生的age：'
      age = gets
      if age.chomp.to_i < 15 || age.chomp.to_i > 20
        puts '清输入15～20'
        redo
      end
    end
    # 添加完成
    ofile = File.new('Student', 'a+')
    ofile.syswrite(id)
    ofile.syswrite(name)
    ofile.syswrite(gender.to_s)
    ofile.syswrite(age.to_s)
    ofile.close
    puts '成功添加！'
    puts "\n是否继续添加？继续请输入1，停止请输入2(或其他)\n"
    n = gets
    n = n.to_i
    if n == 1
      add # 进入学生添加界面
    else
      function_select # 进入功能选择界面
    end
  end

  # delete
  def delete
    puts '**删除学生**'
    arr = IO.readlines('Student')
    puts '请输入要删除的学生的id：'
    id_to_delete = gets
    id_to_delete = id_to_delete.to_i
    i = 0
    index = -4 # 用于记录id的下标
    while i < arr.size # 寻找该id
      if arr[i].to_i == id_to_delete
        index = i
        break
      end
      i += 4
    end
    # 写回到文件中
    if index != -4 # 如果找到了该id
      ofile = File.new('Student', 'w+')
      i = 0
      while i < arr.size
        ofile.syswrite(arr[i]) if i < index || i > index + 3
        i += 1
      end
      ofile.close
      puts '成功删除!'
    else # 如果没有找到
      puts '不存在该学生的信息，所以无需删除'
    end
    puts "\n是否继续删除？继续请输入1，停止请输入2(或其他)\n"
    n = gets
    n = n.to_i
    if n == 1
      delete # 进入学生删除界面
    else
      function_select # 进入功能选择界面
    end
  end

  # change
  def change
    puts '**信息更改**'
    arr = IO.readlines('Student')
    puts '请输入学生的id：'
    id_to_change = gets
    id_to_change = id_to_change.to_i
    i = 0
    flag0 = false # 是否找到了这个id
    while i < arr.size                # 寻找那个id
      if arr[i].to_i == id_to_change  # 如果找到了就更改
        flag0 = true
        # 更改id
        for k in 1..1
          puts '请输入更改后的id：'
          arr[i] = gets
          flag = false # 是否已经存在？
          j = 0
          while j < arr.size
            flag = true if arr[j].chomp == arr[i].chomp && j != i
            j += 4
          end
          if flag
            puts '该id已经存在，清重新输入！'
            redo
          end
        end
        # 更改name
        puts '请输入更改后的name：'
        arr[i + 1] = gets
        # 更改gender
        for i in 1..1
          puts '请输入更改后的gender：'
          arr[i + 2] = gets
          if (arr[i + 2].chomp != 'man') && (arr[i + 2].chomp != 'woman')
            puts '输入错误！请重新输入！'
            redo
          end
        end
        # 更改age
        for i in 1..1
          puts '请输入更改后的age：'
          arr[i + 3] = gets
          if arr[i + 3].chomp.to_i < 15 || arr[i + 3].chomp.to_i > 20
            puts '清输入15～20'
            redo
          end
        end
        break
      end
      i += 4
    end

    if flag0 # 如果找到了该id
      # 写回到文件
      ofile = File.new('Student', 'w+')
      i = 0
      while i < arr.size
        ofile.syswrite(arr[i])
        i += 1
      end
      ofile.close
      puts '成功更改!'
    else # 如果没有找到
      puts '不存在该学生的信息，所以无法更改'
    end

    puts "\n是否继续更改？继续请输入1，停止请输入2(或其他)\n"
    n = gets
    n = n.to_i
    if n == 1
      change # 进入学生信息更改界面
    else
      function_select # 进入功能选择界面
    end
  end

  # search
  def search
    puts '**信息查询**'
    arr = IO.readlines('Student')
    puts '请输入学生的id：'
    id_to_search = gets
    id_to_search = id_to_search.to_i
    i = 0
    flag = false
    while i < arr.size                # 寻找那个id
      if arr[i].to_i == id_to_search  # 如果找到了就打印信息
        flag = true
        puts "学生信息如下：\n"
        puts "id:\t#{arr[i]}"
        puts "name:\t#{arr[i + 1]}"
        puts "gender:\t#{arr[i + 2]}"
        puts "age:\t#{arr[i + 3]}"
        break
      end
      i += 4
    end

    puts '抱歉，该id不存在' unless flag # 如果没有找到该id

    puts "\n是否继续查询？继续请输入1，停止请输入2(或其他)\n"
    n = gets
    n = n.to_i
    if n == 1
      search # 进入学生信息查询界面
    else
      function_select # 进入功能选择界面
    end
  end

  # print
  def print_info
    puts '**信息打印**'
    arr = IO.readlines('Student')

    # 排序
    puts "下面将会对数据排序，清选择排序方式：\n"
    puts "1.按id排序\t2.按name排序\t3.按age排序\n"
    n = nil
    for i in 1..1
      n = gets
      n = n.to_i
      if n != 1 && n != 2 && n != 3
        puts '请输入1或2或3：'
        redo
      end
    end
    puts "升序还是降序？\n"
    puts "升序输入1，降序输入-1\n"
    a = nil
    for i in 1..1
      a = gets
      a = a.to_i
      if a != 1 && a != -1
        puts '请输入1或-1：'
        redo
      end
    end
    if n == 1
      id_sort(arr, a)
    elsif n == 2
      name_sort(arr, a)
    elsif n == 3
      age_sort
    end

    puts "学生信息如下：\n"
    puts "id\tname\tgender\tage\n\n"
    i = 0
    while i < arr.size # 打印所有信息
      print arr[i].chomp # chomp去处换行符
      print "\t"
      print arr[i + 1].chomp
      print "\t"
      print arr[i + 2].chomp
      print "\t"
      print arr[i + 3].chomp
      print "\n"
      i += 4
    end
    puts "信息已经打印，如上\n\n"
    function_select # 进入功能选择界面
  end

  # 随机生成姓名的方法
  def newpass(len)
    chars = ('a'..'z').to_a
    newpass = ''
    1.upto(len) { |_i| newpass << chars[rand(0..25)] }
    newpass
  end

  # sort  按id大小排序
  def id_sort(arr, a)
    i = 0
    while i < arr.size - 4
      j = i + 4
      while j < arr.size
        if a == -1
          if arr[i].to_i < arr[j].to_i
            arr[i + 3], arr[j + 3] = arr[j + 3], arr[i + 3]
            arr[i + 2], arr[j + 2] = arr[j + 2], arr[i + 2]
            arr[i + 1], arr[j + 1] = arr[j + 1], arr[i + 1]
            arr[i], arr[j] = arr[j], arr[i]
          end
        else
          if arr[i].to_i > arr[j].to_i
            arr[i + 3], arr[j + 3] = arr[j + 3], arr[i + 3]
            arr[i + 2], arr[j + 2] = arr[j + 2], arr[i + 2]
            arr[i + 1], arr[j + 1] = arr[j + 1], arr[i + 1]
            arr[i], arr[j] = arr[j], arr[i]
          end
      end
        j += 4
      end
      i += 4
    end
    arr
  end

  # sort  按姓名大小排序
  def name_sort(arr, a)
    i = 1
    while i < arr.size - 4
      j = i + 4
      while j < arr.size
        if arr[i].casecmp(arr[j]) == a
          arr[i + 2], arr[j + 2] = arr[j + 2], arr[i + 2]
          arr[i + 1], arr[j + 1] = arr[j + 1], arr[i + 1]
          arr[i - 1], arr[j - 1] = arr[j - 1], arr[i - 1]
          arr[i], arr[j] = arr[j], arr[i]
        end
        j += 4
      end
      i += 4
    end
    arr
  end

  # sort  按年龄大小排序
  def age_sort(arr, a)
    i = 3
    while i < arr.size - 4
      j = i + 4
      while j < arr.size
        if arr[i].casecmp(arr[j]) == a
          arr[i - 3], arr[j - 3] = arr[j - 3], arr[i - 3]
          arr[i - 2], arr[j - 2] = arr[j - 2], arr[i - 2]
          arr[i - 1], arr[j - 1] = arr[j - 1], arr[i - 1]
          arr[i], arr[j] = arr[j], arr[i]
        end
        j += 4
      end
      i += 4
    end
    arr
  end
end

alex = Student.new
