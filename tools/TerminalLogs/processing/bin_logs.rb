#!/usr/bin/env ruby
#
# Processing script for 'script' terminal logs.
#
# Reads a series of logs and bins their outputs into daily text use.
#


# TODO: write readme file documenting the decisions in what is seen and what is not
#       (see human interest model text below)

INTEREST_TIMEOUT    = 60 
INTEREST_SCROLLBACK = 40 #in lines
MIN_SIZE            = 5


if ARGV.length < 1
  $stderr.puts "USAGE: #{$0} path/to/logs /path/2 /path3"
  exit(1)
end


log_dirs = ARGV[0..-1]


# Go through and find all logs with corresponding time 
# files and load them into a hash
logs = {}
log_dirs.each do |log_dir|
  term_logs = Dir.glob(File.join(log_dir, "term_keys*.log"))
  term_logs.each do |f|

    # Find matching term time
    time_basename = File.basename(f).to_s.gsub("term_keys", "term_time")
    time_filename = File.join( File.dirname(f), time_basename)
    if File.exist?(time_filename)
      $stderr.puts File.basename(f)
      logs[f] = time_filename
    end

  end
end


require 'timeout'
def clean_str(str)

  clean_str = ''
  Timeout::timeout(5){

    # clean terminal chars from str using a perl script
    # hackgasmic.
    Open3.popen2('./remove_control_chars.pl') do |stdin, stdout|
      stdin.write(str.to_s)
      stdin.close
      clean_str += stdout.read
      stdout.close
    end

  }
  return clean_str

rescue Timeout::Error
  return ''

end


# Loop over each one and use time data to sort the strings into bins 
days = {}
scrollback = []
require 'time'
require 'open3'
terminal_events = 0
reading_events = 0
logs.each do |log, times|
begin
  $stderr.puts "Loading from #{log}"
  
  # Load both files
  l = File.open(log, 'r')
  t = File.open(times, 'r')

  # Find the start time for these logs from the header
  time = l.readline.gsub('Script started on ', '')
  time = Time.parse(time)
  $stderr.puts "-> #{time}"

  # Load header
  t.each_line do |timeline|

    terminal_events += 1
    
    # Read fields from the time file
    delay, chars = timeline.split
    delay = delay.to_f
    chars = chars.to_i

    # Add delay to time
    time += delay

    # Read chars from the original logs and append to the virtual scrollback
    scrollback << l.read(chars)

    # Tell people what we be do
    $stderr.print " [#{reading_events}/#{terminal_events}] #{time}...\r"

    # sleep([1, delay].min)
    if delay > INTEREST_TIMEOUT and scrollback.length > 0 then 
     
      # Compute the last n lines of the string
      visible_screen = (scrollback.last(INTEREST_SCROLLBACK)[0..-2] || []).join()
   
      # Remove control chars from the string
      clean_str(visible_screen)

      # Add the last line only if it has a newline at the end
      # puts "LEFT: '#{scrollback.last}'"
      last_line = clean_str(scrollback.last.to_s)
      if last_line[-1] == '\n'
        visible_screen += "#{last_line}"
        scrollback = []
      else
        scrollback = [scrollback.last]
      end



      #or []).join
        # (scrollback.join.split("\n")[-1 * INTEREST_SCROLLBACK..-1] || []).join("\n")

      # Put str onto the end of the days array
      # these will later be concatenated into a string,
      # a strategy that has proven faster than string ops.
      days[time.month] = {} unless days[time.month]
      days[time.month][time.day] = [] unless days[time.month][time.day]
      days[time.month][time.day] << visible_screen

      # print scrollback as debug
      # puts "\n-> #{delay} : #{visible_screen.length} : #{visible_screen}"
      reading_events += 1

    end
  end

rescue EOFError
  $stderr.puts "*** EOF"
end
end


$stderr.puts "Joining day data together"
# Join all the day strings together
# days.each{|k1, v1| v1.each{|k2, v2| days[k1][k2] = v2.join(' ') }}



headers = "source	source2	day	mode	circ status	portion read	Informal genre/purpose	medium	domain	genre	age	title	author	author age	author sex	author type	produced/consumed	words	duration	participants	notes".split("\t")

count = 0
require 'csv'
csv_out = CSV.generate do |out|


  out << headers


  # Create output dir and output
  $stderr.puts "Writing output..."
  days.each do |month, days|
    
    # Put files in it
    days.each do |day, events|

      events.each{|text|
       
        if text.length > MIN_SIZE then

          # Construct fields
          day = day
          source = "terminal"
          source2 = ''      # TODO: detect command?
          mode = 'w'
          circ_status = 1    # TODO: logic
          portion_read = 0.2 
          informal_genre = '' # TODO: logic
          medium = 'display'      
          domain = ''
          genre = ''        # TODO: lookup 
          age = 0
          title = "#{text.to_s[0..20].gsub(/[^\w\[\]\<\>-_.;:><]/, '')}..."
          author = ''
          produceconsume = 'c'
          words = text.split.length


          # sleep(0.5)

          $stderr.puts "#{count+=1} #{title} --> #{words}"

          # Write to csv
          out << [source,
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
    
      }
    
    end

  end

end

puts csv_out


$stderr.puts "Reading events counted #{reading_events}"


# --------------------------
# For each pair of files:
#  Read term_log and corresponding term_time
#  Step through text until the day ticks over
#  place in a big-ass hash structure
# Escape terminal escape sequences
# TODO: Apply "human interest model" by cropping the last bit of very fast output
# Once all are read, output to a directory with a simple daily structure: /year/month/day.txt


