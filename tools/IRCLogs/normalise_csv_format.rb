#!/usr/bin/env ruby
#
# Reads IRC conversations and turns them into one-line-per-conversation CSV files
#

require 'csv'#


conversations = {}
ARGV.each do |file|

  $stderr.puts "-0> #{file}"
  
  # Find day from filename
  day = file.to_s.split(/[\- ]/)[4]
  conversations[day] = [] if !conversations[day]

  conv = {:users => [], :msgs => []}
  CSV.foreach(file, :headers => true) do |fields|
    
    # Record from each line
    conv[:users] << fields[9]
    conv[:msgs] << fields[11]

  end

  # merge user list
  conv[:users].uniq!

  # Add to daily list
  conversations[day] << conv

end











#
#
# output
#

headers = "source	source2	day	mode	circ status	portion read	Informal genre/purpose	medium	domain	genre	age	title	author	author age	author sex	author type	produced/consumed	words	duration	participants	notes".split("\t")



count = 0
csv_out = CSV.generate do |csv|
  
  #
  # Write headers
  csv << headers

  conversations.each do |day, cs| 

    cs.each do |conv|

      str = conv[:msgs].join(" ")

      # Construct fields
      day = day
      source = "irc"
      source2 = ''
      mode = 'w'
      circ_status = conv[:users].length    # TODO: logic
      portion_read = 1 
      informal_genre = '' # TODO: logic
      medium = 'irc'      
      domain = ''
      genre = ''        # TODO: lookup 
      age = 0
      title = "#{str[0..20]}..."
      author = ''
      produceconsume = 'pc' 
      words = str.to_s.split.count


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
        produceconsume,
        words,
        '',
        '',
        '']

    end


  end


end


puts csv_out










#
# Old one-line-per-msg code
# 
#   # Read a line from ARGV[0]
#   count = 0
#   CSV.foreach(ARGV[0]) do |fields|
# 
#     # Construct fields
#     day = fields[3]
#     source = "irc"
#     source2 = ''
#     mode = 'w'
#     circ_status = 5    # TODO: logic
#     portion_read = 1 
#     informal_genre = '' # TODO: logic
#     medium = 'irc'      
#     domain = ''
#     genre = ''        # TODO: lookup 
#     age = 0
#     title = "#{fields[11].to_s[0..20]}..."
#     author = fields[9]
#     produceconsume = ((fields[9] == 'Steve-W') ? 'p' : 'c') 
#     words = fields[11].to_s.split.count
# 
# 
#     # sleep(0.5)
# 
#     $stderr.puts "#{count+=1} #{title} --> #{words}   #{fields[11]}"
# 
#     # Write to csv
#     csv << [source,
#             source2,
#             day,
#             mode,
#             circ_status,
#             portion_read,
#             informal_genre,
#             medium,
#             domain,
#             genre,
#             age,
#             title,
#             author,
#             '',
#             '',
#             '',
#             produceconsume,
#             words,
#             '',
#             '',
#             '']
# 
# 
#     
#   end
# 
