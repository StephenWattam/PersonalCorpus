#!/usr/bin/env ruby
#
# Normalises the format of extracted URLs to match the coding formats of the other things
#
#
require 'csv'#
require 'net/http'
require 'uri'
require 'timeout'
require 'cgi'
require 'json'
require 'nokogiri'

headers = "source	source2	day	mode	circ status	portion read	Informal genre/purpose	medium	domain	genre	age	title	author	author age	author sex	author type	produced/consumed	words	duration	participants	notes".split("\t")


#
#
# Lastfm details:
# API Key: c3ead23c0e496e1f62cf30f858e9dcae
# Secret: is dce79630401c3b7e1245d9ffc8955d2a
#
#


# 
# http://www.lyricsnmusic.com/api
#
# 985bb176401b2528b7ec3e7f08137e
#
#
API_KEY = "985bb176401b2528b7ec3e7f08137e"
def word_count_song(title, artist)


  url = "http://api.lyricsnmusic.com/songs?api_key=#{API_KEY}&title=#{CGI::escape(title)}&artist=#{CGI::escape(artist)}"

  str = ""
  Timeout::timeout(5){
   
    # Download URL
    str = Net::HTTP.get_response(URI(url))

  }

  song = JSON.parse(str.body)
  song = song[0]

  if song && song["url"] then
    
    Timeout::timeout(5){
      # Sanitise input somewhat
      url = url.to_s

      # Download URL
      str = Net::HTTP.get_response(URI(song["url"]))

      doc  = Nokogiri::HTML(str.body)
      return doc.xpath("//pre[@itemprop]").text.to_s.split.count
    }

  end

  return 0
rescue StandardError => e
  # puts "=--> #{e} #{e.backtrace.join("\n")}"
  return 0
end




csv_out = CSV.generate do |csv|
  
  #
  # Write headers
  csv << headers



  # Read a line from ARGV[0]
  count = 0
  CSV.foreach(ARGV[0]) do |fields|

    # Construct fields
    day = Time.at(fields[0].to_i).day
    source = "music"
    source2 = ''
    mode = 's'
    circ_status = ''    # TODO: logic
    portion_read = 1 
    informal_genre = '' # TODO: logic
    medium = 'music'      # TODO: logic
    domain = ''
    genre = ''        # TODO: lookup 
    age = ''
    title = "#{fields[2]}"
    author = fields[3]
    words = word_count_song(fields[2], fields[3])          # TODO: download and get word count


    # sleep(0.5)

    $stderr.puts "#{count+=1} #{title} --> #{words}"

    # Write to csv
    csv << [source,
            source2,
            day,
            mode,
            circ_status,
            portion_read,
            informal_genre,
            medium,
            domain,
            genre,
            age,
            title,
            author,
            '',
            '',
            '',
            'c',
            words,
            '',
            '',
            '']


    
  end
  


end


puts csv_out
