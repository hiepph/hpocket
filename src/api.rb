require 'sinatra'

get '/q/:query' do
  params['query']
end
