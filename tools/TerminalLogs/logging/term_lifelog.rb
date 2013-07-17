#!/usr/bin/env ruby

# 
# Reads a global YAML file and applies settings to script
#
# This tool returns a shell command.  To use:

require 'yaml'
require 'fileutils'
require 'shellwords'

# read config locally or from etc
SETTINGS = ["./term_lifelog.yml", "/etc/term_lifelog.yml"]
SCRIPT = "/usr/bin/script"

settings = {}

# check for configs
SETTINGS.each{|s|
  if File.exist?(s) then
    settings.merge!(YAML.load_file(s))
  end
}

# echo if cannot script
def fatal(str)
  puts "echo #{Shellwords::encode("FATAL: " + str.to_s)}"
  exit(1)
end


if settings[:logroot] and settings[:keylog] then
  log_filename  = settings[:keylog] % Time.now.to_s
  time_filename = settings[:timelog] % Time.now.to_s if settings[:timelog]

  if File.exist?(settings[:logroot]) and not File.directory?(settings[:logroot]) then
    fatal("log root exists and is not a directory.")
  else
    if not File.exist?(settings[:logroot]) then
      FileUtils.mkdir_p(settings[:logroot])
    end
    
    log_filename = File.join(settings[:logroot], log_filename)
    time_filename = File.join(settings[:logroot], time_filename)

    if time_filename then
      puts "#{SCRIPT} #{settings[:flags]} --timing=#{Shellwords::escape(time_filename)} #{Shellwords::escape(log_filename)}"
    else
      puts "#{SCRIPT} #{settings[:flags]} #{Shellwords::escape(log_filename)}"
    end
    
  end
else
  puts "#{SCRIPT} #{settings[:flags]}"
end
