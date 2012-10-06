#!/home/spartan/.rvm/rubies/ruby-1.9.3-p194/bin/ruby 
require 'net/http'
require 'json'
require 'pp'
require 'open-uri'
require 'hpricot'

#LYRICSnMUSIC                            http://www.lyricsnmusic.com/api
#Last.FM + Scrobbling with Spotify       http://www.last.fm/home 

module Lyrics
  
  def getLyrics
    api_key = 'f5d61ca601bcc9956237b6377f70abf6'

    lastFM = URI('http://ws.audioscrobbler.com/2.0/')
    options = {:method => 'user.getrecenttracks', :limit => 2, :user => "meflower27", :api_key => api_key, :format => 'json'}
    lastFM.query = URI.encode_www_form(options)

    res = Net::HTTP.get_response(lastFM)
    results = JSON.parse(res.body, {:symbolize_names => true})

    #pp results
    first_track = results[:recenttracks][:track].first
    track = first_track[:name]
    artist = first_track[:artist][:"#text"]
    album = first_track[:album][:"#text"]
    picture_url = first_track[:image].last[:"#text"]
    meta_data = {:name => track, :artist => artist, :album => album, :pic_url => picture_url}
    puts track + " | " + artist + " | " + album



    lyricsNMusic = URI('http://api.lyricsnmusic.com/songs')
    options = {:artist => artist, :track => track}
    lyricsNMusic.query = URI.encode_www_form(options)
    res = Net::HTTP.get_response(lyricsNMusic)
    results = JSON.parse(res.body, {:symbolize_names => true})

    if results.first.nil? then return {:error => 1, :meta_data => meta_data} end

    lyrics_url = URI(results.first[:url])
    lyrics_page = open(results.first[:url]){ |f| Hpricot(f)}
    lyrics = lyrics_page.search("pre").first.inner_html
    {:meta_data => meta_data, :lyrics => lyrics}
  end

end

helpers Lyrics