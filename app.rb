require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, {:format => :html5, :attr_wrapper => '"'}

get '/' do
  haml :index
end
