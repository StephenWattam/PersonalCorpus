#!/usr/bin/env ruby
#
# Processes SMS logs into a more usable CSV + plaintext format.
#

OUT_CSV = 'sms.csv'
OUT_RAW = 'sms.text'

xml_fp = ARGV[0]

require 'rexml/document'
require 'csv'

puts "Opening file #{xml_fp}"
doc = REXML::Document.new(File.read(xml_fp))


count = 0
out_raw = File.open(OUT_RAW, 'w+')
out_csv = CSV.open(OUT_CSV, 'w')

# Write headers
out_csv << %w{sent address name date datestr words msg}

doc.elements.each('smses/sms') do |el|

  puts "#{count += 1}..."

  # Write to CSV
  sent_by_me  = (el.attributes['type'] == '2')
  address     = el.attributes['address']
  name        = el.attributes['contact_name']
  date        = el.attributes['date']
  datestr     = el.attributes['readable_date']
  words       = el.attributes['body'].to_s.split.length
  msg         = el.attributes['body'].to_s
  out_csv << [sent_by_me, address, name, date, datestr, words, msg]


  # Write to one-line-per-msg raw output
  out_raw.puts el.attributes['body'].gsub("\n", '\n')


end
out_raw.close
out_csv.close

