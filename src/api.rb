require 'sinatra'

before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'PUT']
end

get '/q/:query' do
  q = "q:#{params['query']}"
  `hpocket #{q}`
end

put '/i' do
  # /i?l=https://google.com
  i = "i:#{params['l']}"
  `hpocket #{i}`
end
