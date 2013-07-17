#!/usr/bin/env ruby
#
# Converts mbox to CSV and raw text forms
# 
require 'csv'
require 'time'


input_file = ARGV[0]
output_csv = ARGV[1] || input_file + ".csv"
output_raw = ARGV[1] || input_file + ".text"

if File.exist?(output_csv) || File.exist?(output_raw) then
  $stderr.puts "Output file exists.  bailing."
  exit(1)
end


# Open input file
in_file = File.open(input_file, 'r')

# open handles
out_csv = CSV.open(output_csv, 'w')
out_raw = File.open(output_raw, 'w+')


# Write headers
out_csv << %w{date datestr from msg subject}


# Step through mbox format and aggregate into messages
msg           = {}
msg[:headers] = {}
continue_header = nil # set when semicolons cause multi-line values
in_file.each_line do |line|

  # Force utf-8
  line.encode!("UTF-8", :invalid=>:replace, :replace=>"?", :undef=>:replace)

  begin
    # "new message header"
    if m = line.match(/^From (?<from>[a-zA-Z0-9\-_@.]+)\s+(?<time>\w{3}\s+\w{3}\s+\d+\s+\d{2}:\d{2}:\d{2}\s+\d{4})/)
      puts "[N]--> #{m}"

      from = m['from']
      time = Time.strptime(m['time'], '%a %b %d %H:%M:%S %Y')

      # Write existing message if one exists
      if msg && msg[:body]
        puts "[O]--> writing #{msg[:body].to_s.length}b..."

        puts msg[:headers]

        # TODO: more header fields if useful
        out_csv << [msg[:time].to_i, msg[:time].to_s, msg[:from], msg[:body], msg[:headers]['Subject']]

        # And write raw too
        out_raw.puts(msg[:body])
      end

      # Reset the current message
      msg             = {}
      msg[:from]      = from
      msg[:time]      = time
      msg[:headers]   = {}
      continue_header = false


    # If the header is continuing, add it on
    elsif !msg[:body] && line.match(/^\s+/) 
      msg[:headers][continue_header] = msg[:headers][continue_header].to_s + line
    # header
    elsif !msg[:body] && (m = line.match(/^(?<header>[a-zA-Z\-0-9+]+):\s*(?<value>.+)/))
      puts "[h]--> #{m['header']} = #{m['value']}"
      
      
      msg[:headers][m['header']] = m['value']

      # If a semicolon, the header continures on the next line
      continue_header = m['header']

    # Empty line says body begins
    elsif !msg[:body] && line.match(/^$/)

      msg[:body] = ''

    #body
    else
      msg[:body] = msg[:body].to_s + line
    end

  rescue ArgumentError => e
    puts "[E]--> #{e}"
  end

end




#cl;ose handles
out_raw.close
out_csv.close
