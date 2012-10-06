#!/home/spartan/.rvm/rubies/ruby-1.9.3-p194/bin/ruby 
require 'sinatra'
require './lyrical.rb'

get '/' do
  lyrics = getLyrics
  if lyrics.has_key?(:error) 
    erb :lyrics, :layout => :"layouts/layout", :locals => {:title => lyrics[:meta_data][:name], 
                                                           :lyrics => '', 
                                                           :meta_data => lyrics[:meta_data]}
  else
    erb :lyrics, :layout => :"layouts/layout", :locals => {:title => lyrics[:meta_data][:name], 
                                                                            :lyrics => lyrics[:lyrics], 
                                                                            :meta_data => lyrics[:meta_data]}
  end
end

get '/about' do 
  erb :about
end

not_found do 
  status 404
  'This is not the page you are looking for'
end