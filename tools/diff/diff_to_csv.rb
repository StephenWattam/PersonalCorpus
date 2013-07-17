#!/usr/bin/env ruby
#
# Counts file edits from git patches.
#



if ARGV.length < 3
  $stderr.puts "USAGGE: #{$0} DAY PROJECT FILE FILE FILE..."
  exit(1)
end



files = []
current_file = {content: [], file: nil}
ARGV[2..-1].each do |file|

  $stderr.puts "-> #{file}"

  # Keep track of the current file


  File.read(file).lines do |line|

    # $stderr.puts line

    # Check for the new file thingy
    if m = line.match(/^(\+\+\+|---)\s+(?<file>.*)/)
      $stderr.puts "New file/old file: #{m['file']}"


      # Add last file and create new current one
      if current_file[:file] and current_file[:content].length > 0 
        files << current_file
        current_file = {content: [], file: nil}
      end


      current_file[:file] = m['file']

    # Check for edited lines
    elsif m = line.match(/^[+\-](?<text>.*)/)
      # $stderr.puts "Line of content"
      current_file[:content] << m['text']
    end

  end
end

# Write last one if necessary
files << current_file if current_file[:file]



# ------------------------------------------------------------------------------

require 'csv'#

headers = "source	source2	day	mode	circ status	portion read	Informal genre/purpose	medium	domain	genre	age	title	author	author age	author sex	author type	produced/consumed	words	duration	participants	notes".split("\t")


csv_out = CSV.generate do |csv|
  
  #
  # Write headers
  csv << headers


  # Read a line from ARGV[0]
  count = 0

  files.each do |file|


    # Construct fields
    day = ARGV[0].to_i
    source = "file"
    source2 = ARGV[1]
    mode = 'w'
    circ_status = 5    # TODO: logic
    portion_read = 1 
    informal_genre = '' # TODO: logic
    medium = 'file'      
    domain = ''
    genre = ''        # TODO: lookup 
    age = 0
    title = file[:file] 
    author = "Me"
    produceconsume = 'pc'
    words = file[:content].join(" ").split.length


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


puts csv_out

