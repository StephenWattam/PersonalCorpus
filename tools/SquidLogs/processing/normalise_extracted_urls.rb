#!/usr/bin/env ruby
#
# Normalises the format of extracted URLs to match the coding formats of the other things
#
#
require 'csv'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'timeout'

headers = "source	source2	day	mode	circ status	portion read	Informal genre/purpose	medium	domain	genre	age	title	author	author age	author sex	author type	produced/consumed	words	duration	participants	notes".split("\t")





def estimate_proportion_read(url)
  url = url.to_s
  return 0.05 if url =~ /imgur/
  return 0.1 if url =~ /amazon/
  return 0.1
end


def word_count_html(url)
  Timeout::timeout(5){
    # Sanitise input somewhat
    url = url.to_s
   

    # Download URL
    str = Net::HTTP.get_response(URI(url))


    # Load into nokogiri and strip tags
    doc  = Nokogiri::HTML(str.body)
    body = doc.xpath("//body")
    str = []
    body.each{|n| str << n.xpath("//text()").remove }


    # Then count words
    return str.join(' ').split.size
  }
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
  File.open(ARGV[0], 'r').each_line do |line|
    fields = line.split

    # Construct fields
    day = fields[2].split('-')[2]
    source = "squid"
    source2 = fields[5]
    mode = 'w'
    circ_status = ''    # TODO: logic
    portion_read = estimate_proportion_read(fields[6])  # TODO: logic
    informal_genre = '' # TODO: logic
    medium = 'web'      # TODO: logic
    domain = ''
    genre = '' 
    age = ''
    title = "#{fields[6]}"
    words = word_count_html(fields[6])          # TODO: download and get word count

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
            '',
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
