#### 用户表users

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |用户ID--主键|
|username  |string|用户名（唯一）--外键|
|password  |string|密码|

#### 文章表posts

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |文章ID--主键|
|title  |string|文章标题--index|
|content  |text|文章内容|
|kinds  |string|分类--index|
|author  |string|作者--index|
|created_at  |timestampes|创作时间--index|
|pass?  |string|是否过审核（T/F）--index|

#### 留言表comments

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |留言ID--主键|
|commenter  |string|留言|
|author  |string|作者--index|
|author_id  |int|对应文章的id--index|
|created_at  |timestampes|留言时间|

#### 反馈表feedbacks

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |反馈ID--主键|
|content  |string|反馈内容|
|author  |string|作者--index|
|created_at  |timestampes|反馈时间|

#### 管理员账户表admins

|字段名    |类型  |描述|
|:--------:|:----:|----|
|id        |int   |管理员ID--主键|
|adminname  |string|管理员用户名|
|password  |string|管理员密码|

