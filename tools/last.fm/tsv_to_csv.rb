#!/usr/bin/env ruby
#
# Removes superfluous items from the last.fm dump and 
# converts to a CSV
#
#


FIRST_INTERESTING_DATE = 1365033600 # 04/04/13
LAST_INTERESTING_DATE = 1367280000 # 30/04/13

require 'csv'

cout = CSV.open("lastfm.csv", 'w')


cout << %w{date datestr title artist} # id1 id2}

count = 0
File.open(ARGV[0], 'r').each_line do |line|

  # Split by tab
  parts = line.split("\t")

  # Load into csv
  if parts && parts.length == 7

    if parts[0].to_i >= FIRST_INTERESTING_DATE && parts[0].to_i <= LAST_INTERESTING_DATE 
      print "\r #{count+=1}..." 
      cout << [parts[0], Time.at(parts[0].to_i).to_s, parts[1], parts[2]]
    end
  end


end


cout.close
