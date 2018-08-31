class FrontController < ApplicationController
  def register; end

  def register_result
    @return
    if User.find_by_username(params[:username])
      @return = '对不起，该用户已经存在'
    else
      @new_user = User.new(username: params[:username], password: params[:password1])
      @new_user.save
      @return = '注册成功！'
    end
  end

  def login; end

  def login_result
    @return
    session[:username]
    session[:adminname] = nil
    @user = User.find_by_username(params[:username])
    if !@user.nil?
      if @user.password == params[:password]
        session[:username] = params[:username]
        redirect_to '/front/home'
      else
        @return = 'password error!'
      end
    else
      @return = "user: \'#{params[:username]}\' does not exist!"
    end
  end

  def home
    # @articles = Post.find_by_sql("select * from posts where pass='T' order by id desc")
    @articles = Post.where(pass: 'T')
    @articles = @articles.reverse
  end

  # ***********************这里文章暂时设置成不需要审核
  def write_article; end

  def write_article_result
    @new_article = Post.new(title: params[:title2], content: params[:content], kinds: params[:kinds], author: session[:username], pass: '-')
    @new_article.save
    @return = '成功添加一篇文章，待管理员审核通过后可显示到网站主页'
  end

  def search_article; end

  def search_article_result
    @articles
    @articles = if params[:author].empty? # 说明是按分类查询
                  Post.where(kinds: params[:kinds])
                else
                  Post.where(author: params[:author])
                end
    @articles = @articles.reverse
  end

  def write_feedback; end

  def write_feedback_result
    @new_feedback = Feedback.new(content: params[:content], author: session[:username])
    @new_feedback.save
    @return = '成功提交反馈'
  end

  def personal_center
    @articles = Post.where(author: session[:username])
    @articles = @articles.reverse
  end

  def logout
    session[:username] = nil
    session[:adminname] = nil
    redirect_to '/front/login'
  end

  def my_comments
    @comments = Comment.where(author: session[:username])
    @comments = @comments.reverse
  end

  def my_feedbacks
    @feedbacks = Feedback.where(author: session[:username])
    @feedbacks = @feedbacks.reverse
  end

  def article
    @article = Post.find(params[:id])
    session[:article_id] = params[:id]
    @comments = Comment.where(article_id: session[:article_id])
  end

  def write_comment
    @new_comment = Comment.new(commenter: params[:commenter], author: session[:username], article_id: session[:article_id])
    @new_comment.save
    redirect_to "/front/article/#{session[:article_id]}"
  end

  def change_password; end

  def change_password_result
    @user = User.find_by_username(session[:username])
    @return
    if @user.password == params[:old_password]
      @user.update(password: params[:new_password1])
      @return = '密码修改成功！请重新登录！'
    else
      @return = '对不起，原密码错误！'
    end
  end

  def delete_article
    @article = Post.find(params[:id])
    @article.destroy

    @comments = Comment.where(article_id: session[:article_id])

    @comments.each(&:destroy)
    redirect_to '/front/personal_center'
  end

  def delete_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
    if session[:adminname].nil?
      redirect_to '/front/my_comments'
    else
      redirect_to '/back/comments_admin'
    end
  end
end
