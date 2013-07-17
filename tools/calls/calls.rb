#!/usr/bin/env ruby
#
# Processes call logs into a more usable CSV + plaintext format.
#

OUT_CSV = 'calls.csv'

xml_fp = ARGV[0]

require 'rexml/document'
require 'csv'

puts "Opening file #{xml_fp}"
doc = REXML::Document.new(File.read(xml_fp))

count = 0
out_csv = CSV.open(OUT_CSV, 'w')

# Write headers
out_csv << %w{sent address name date datestr duration}

doc.elements.each('calls/call') do |el|

  puts "#{count += 1}..."

  # Write to CSV
  sent_by_me  = (el.attributes['type'] == '2')
  address     = el.attributes['number']
  name        = el.attributes['contact_name']
  date        = el.attributes['date']
  datestr     = el.attributes['readable_date']
  duration    = el.attributes['duration'].to_s
  out_csv << [sent_by_me, address, name, date, datestr, duration]

end
out_csv.close

