# LifeLogging service
require 'csv'

class Log

  HEADERS = %w(time year month day hour min sec cmd to from host server channel msg)

  def initialize(fn, timeout)
    @timeout = timeout

    # get filename and open handle
    $log.debug "Opening log at #{fn}..."
    @csv = CSV.open(fn, 'w')

    # write headers
    @csv << HEADERS
  end

  # Add to the log
  def add(channel, cmd, to, from, host, server, message)
    # write to log
    t = Time.now
    @csv << [t, t.year, t.month, t.day, t.hour, t.min, t.sec, cmd, to, from, host, server, channel, message]

    # update timeout
    @last_log = Time.now
  end

  # is the bot currently logging?
  def active?
    compute_timeout < @timeout
  end

  # get time since last msg
  def compute_timeout
    return 0 if not @last_log
    Time.now - @last_log
  end

  def close
    $log.debug "Closing log."
    @csv.close if @csv
    @csv = nil
  end
end


# Manages channel membership for the bot in a stateless manner
class LifeLog < HookService



  def initialize(bot, config)
    super(bot, config, false) # NOT thread safe!
    @logs = {}
  end

  # Describe ones'self!
  def help
    "Steve's Life Log." 
  end

  # Add something to a log.  Automagically creates logs based on the timeout.
  def add_to_log(channel, cmd, to, from, host, server, message)
    # close if log is inactive
    if @logs[channel] and not @logs[channel].active? then
        @logs[channel].close 
        @logs[channel] = nil
    end

    # Create a log if not currently logging
    @logs[channel] = Log.new(get_log_filename(channel), @config[:timeout]) if not @logs[channel]

    # Add log entry
    @logs[channel].add(channel, cmd, to, from, host, server, message)
  end

  # Is the bot currently logging? tell people
  def report_active(bot, channel)
    bot.say("#{(logging?(channel))? 'C' : 'Not c'}urrently logging in this channel.")
  end

  # Sets up initial connect hooks
  def hook_thyself
    me    = self

    # Say if I'm logging
    register_command(:lifelog_active, /^[lL]ife[Ll]og$/, [/channel/, /private/]){
      me.report_active(bot, channel)
    }

    # Ordinary channel messages
    register_hook(:lifelog_listener, nil, [/channel/, /private/]){
      m     = raw_msg 
      to    = m.recipient
      from  = nick
    
      me.add_to_log(channel, m.command, to, from, m.host, m.message, server)
    }

  end

  def close
    super()
    @logs.each{|chan, log|
      log.close
    }
  end

private

  # is logging?
  def logging?(channel)
    !!@logs[channel] and @logs[channel].active?
  end

  # make the filename for a new log
  def get_log_filename(channel)
    File.join(@config[:logdir], "irc " + channel.to_s + " " + Time.now.to_s + ".log")
  end
end


