Rails.application.routes.draw do
  root 'front#login'

  get 'front/register'
  get 'front/register_result'
  get 'front/login'
  get 'front/login_result'
  get 'front/home'

  get 'front/search_article'
  get 'front/search_article_result'

  get 'front/write_article'
  get 'front/write_article_result'

  get 'front/write_feedback'
  get 'front/write_feedback_result'

  get 'front/personal_center'

  get 'front/my_comments'
  get 'front/my_feedbacks'

  get 'front/logout'

  get '/front/article/:id' => 'front#article'
  get 'front/write_comment'

  get 'front/change_password'
  get 'front/change_password_result'

  get '/front/delete_article/:id' => 'front#delete_article'
  get '/front/delete_comment/:id' => 'front#delete_comment'

  # 后台
  get 'back/login'
  get 'back/login_result'

  get 'back/register'
  get 'back/register_result'

  get 'back/function_select'

  get 'back/articles_admin'
  get 'back/pass'
  get 'back/fail'

  get 'back/comments_admin'

  get 'back/feedbacks_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :posts
  resources :comments
  resources :feedbacks
  resources :admins
end
