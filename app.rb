require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require './lib/bookmark'
require './lib/comment'
require './lib/database_connection'
require './database_connection_setup'
require 'uri'

class MyApp < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :'index'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb :'bookmarks/index'
  end

  get '/bookmarks/new' do
    erb :'bookmarks/new'
  end

  post '/bookmarks' do
    flash[:notice] = "You must submit a valid URL." unless Bookmark.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id])
    erb :'bookmarks/edit'
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params[:id], title: params[:title], url: params[:url])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb :'/bookmarks/comments/new'
  end

  post '/bookmarks/:id/comments' do 
    Comment.create(text: params[:comment], bookmark_id: params[:id])
    redirect '/bookmarks'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
