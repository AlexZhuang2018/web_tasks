class BackController < ApplicationController
  def register; end

  def register_result
    @return
    if params[:key] == 'secret'
      if Admin.find_by_adminname(params[:adminname])
        @return = '对不起，该用户已经存在'
      else
        @new_admin = Admin.new(adminname: params[:adminname], password: params[:password1])
        @new_admin.save
        @return = '注册成功！'
      end
    else
      @return = '管理员注册密钥错误'
    end
  end

  def login; end

  def login_result
    @return
    session[:adminname]
    session[:username] = 'admin'
    @admin = Admin.find_by_adminname(params[:adminname])
    if !@admin.nil?
      if @admin.password == params[:password]
        session[:adminname] = params[:adminname]
        redirect_to '/back/function_select'
      else
        @return = 'password error!'
      end
    else
      @return = "admin: \'#{params[:adminname]}\' does not exist!"
    end
  end

  def function_select; end

  def articles_admin
    @articles = Post.where(pass: '-')
  end

  def pass
    @article = Post.find(params[:id])
    @article.update(pass: 'T')
    redirect_to '/back/articles_admin'
  end

  def fail
    @article = Post.find(params[:id])
    @article.update(pass: 'F')
    redirect_to '/back/articles_admin'
  end

  def comments_admin
    @comments = Comment.all
  end

  def feedbacks_admin
    @feedbacks = Feedback.all
  end
end
