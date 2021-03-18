# lib/syslinux/host.rb
require './gen.rb'

# Functionality to access
# general host data (software,
# configurations, time, etc.)
module Host
  def self.uptime
    # First value is the uptime; second
    # value is idle processor time ACROSS
    # ALL CORES (which can lead much
    # higher numbers, if many cores)
    secs = File.read("/proc/uptime")
      .split
      .first
      .to_i
    sec_to_time(secs)
  end
  
  # Convert an int number of seconds
  # to a time
  def self.sec_to_time(seconds)
    whole = seconds
    
    mins, s = whole.divmod 60
    hours, m = mins.divmod 60
    days, h = hours.divmod 24
    w, d = days.divmod 7
    
    {weeks: w, days: d, hours: h, minutes: m, seconds: s}
  end
end