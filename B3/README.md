### 前台controller
|前台动作    |
|:--------:|
|register  |
|login     |
|文章       |
|留言       |
|意见反馈   |
|logout    |

### 后台controller
|后台动作    |
|:--------:|
|login  |
|文章管理     |
|意见反馈管理       |
|账户管理       |
|logout    |

#### 用户表users

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |用户ID|
|username  |string|用户名|
|password  |string|密码|

#### 文章表posts

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |文章ID|
|title  |string|文章标题|
|content  |text|文章内容|
|kinds  |string|分类|
|author  |string|作者|
|created_at  |timestampes|创作时间|

#### 留言表comments

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |留言ID|
|commenter  |string|留言|
|author  |string|作者|
|created_at  |timestampes|留言时间|

#### 反馈表feedbacks

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |反馈ID|
|content  |string|反馈内容|
|author  |string|作者|
|created_at  |timestampes|反馈时间|

#### 管理员账户表admins

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |管理员ID|
|adminname  |string|管理员用户名|
|password  |string|管理员密码|

### 关联
user has_many comments

user has_many feedbacks

comment belongs_to user

feedback belongs_to user

post has_many comments

comment belongs_to post
