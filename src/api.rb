require 'sinatra'

get '/q/:query' do
  q = "q:#{params['query']}"
  `hpocket #{q}`
end
