#!/usr/bin/env

# Uses mtime and atime to select files modified in the last n seconds, or since the last point
#



# read config locally or from etc
SETTINGS = ["./file_age_rc.yml", "/etc/file_age_rc.yml"]

conf = {}

# check for configs
SETTINGS.each{|s|
  if File.exist?(s) then
    conf.merge!(YAML.load_file(s))
  end
}

# TODO: loop over directory recursively, find files that have an mtime and/or atime in the last timeout.
