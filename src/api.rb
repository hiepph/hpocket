require 'sinatra'

get '/q/:query' do
  q = "q:#{params['query']}"
  `hpocket #{q}`
end

put '/i' do
  # /i?l=https://google.com
  i = "i:#{params['l']}"
  `hpocket #{i}`
end
