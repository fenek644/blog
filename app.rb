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
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
	erb :new
end

post '/method' do
  @post = params['post']

  if @post.strip.length == 0
    @error = "Ваше сообщение пусто. Введите какойнибуть текст."
    erb :new
  else
		@db.execute 'insert into Posts (content, create_date) values (?, datetime())', [@post]

		erb " #{@post}"
  end

end