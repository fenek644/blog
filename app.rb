#encoding: utf-8
require 'rubygems'
require 'sinatra'
# require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.sql'
	@db.results_as_hash = true
end

before do
  #  инициализация БД;
   init_db
end

#  создается каждый раз при иконфигурации (составлении) приложения
# когда изменяется код программы или перезагружается страница
configure do
  init_db
  # создает таблицу, если таблица не существует, в противном случае с существующей таблицей ничего не происходит.
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
  (
		id	INTEGER PRIMARY KEY AUTOINCREMENT,
		create_date	DATE,
		content	TEXT
	)'
end

get '/' do
	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
  @post = params['post']

  if @post.strip.length == 0
    @error = "Ваше сообщение пусто. Введите какойнибуть текст."
    erb :new
  else
		@db.execute 'insert into Posts (content, create_date) values (?, datetime())', [@post]

		erb :index
  end

end

get "/details/:post_id" do
  # получаем параметр из URL
  post_id = params[:post_id]

  # аолучаем массив срочек из базы с данныи идентификатором
  #  он будет состаять из одной хеша
  result = @db.execute "select * from Posts where id = (?)", [post_id]
  # берем эту строчку
  @row = result[0]
  #возвращаем представление details.erb
  erb :details
end