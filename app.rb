require 'rubygems'
require 'sinatra'
require 'haml'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'base62'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/#{Sinatra::Application.environment}.sqlite")

class Link
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :length => 255, :required => true, :index => true
  timestamps :at

  validates_format :url, :as => :url
end

helpers do
  include Rack::Utils

  alias :h :escape_html

  def link_url(link)
    "http://#{request.host}/#{link.id.base62_encode}"
  end
end

set :haml, {:format => :html5, :attr_wrapper => '"'}

get '/' do
  @link = Link.new
  haml :index
end

post '/' do
  @link = Link.first_or_create(:url => params[:url])
  haml :index
end

get %r{/(\w+)} do
  @link = Link.get(params[:captures].first.base62_decode)
  throw :halt, [404, "Not found"] unless @link
  redirect @link.url
end
