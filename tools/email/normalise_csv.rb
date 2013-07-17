#!/usr/bin/env ruby
#
# Normalises the format of extracted URLs to match the coding formats of the other things
#
#
require 'csv'#

headers = "source	source2	day	mode	circ status	portion read	Informal genre/purpose	medium	domain	genre	age	title	author	author age	author sex	author type	produced/consumed	words	duration	participants	notes".split("\t")




csv_out = CSV.generate do |csv|
  
  #
  # Write headers
  csv << headers


  # Read a line from ARGV[0]
  count = 0
  CSV.foreach(ARGV[0]) do |fields|

    # Construct fields
    day = Time.at(fields[0].to_i).day
    source = "email"
    source2 = ''
    mode = 'w'
    circ_status = ''    # TODO: logic
    portion_read = 1 
    informal_genre = '' # TODO: logic
    medium = 'email'      # TODO: logic
    domain = ''
    genre = ''        # TODO: lookup 
    age = ''
    title = "#{fields[4].chomp}"
    author = fields[2]
    words = fields[3].to_s.split.length


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
