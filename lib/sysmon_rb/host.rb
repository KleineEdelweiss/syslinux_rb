# lib/sysmon_rb/host.rb
require './gen.rb'

# Functionality to access
# general host data (software,
# configurations, time, etc.)
module Host
  # Class to store system readers
  # and update methods
  class System
    # Basic host system configurations
    @@os = nil
    @@kernel = nil
    @@arch = nil
    @@hostname = nil
    
    # Take the os and kernel string,
    # as these will not change between
    # reboots. Generates the rest.
    def initialize
      os
      kernel
      hostname
    end
    
    # Return the system information
    # as a hash
    def all
      {
        os: os,
        kernel: kernel,
        arch: arch,
        hostname: hostname
      }
    end
    
    # Return JUST the OS
    def os() @@os ||= `uname -o`.strip end
      
    # Return JUST the kernel
    def kernel
      @@kernel ||= {
        name: `uname -s`.strip,
        release: `uname -r`.strip
      }
    end
      
    # Return JUST the architecture
    def arch() @@arch ||= `uname -m`.strip end
    
    # Return JUST the hostname
    def hostname() @@hostname = `uname -n`.strip end
  end
  
  # Return the uptime of the machine
  # as a hash of the different time
  # components
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
  
  # Get the system time
  def self.time
    t = Time.now 
    {
      y: t.year,
      mo: t.mon,
      d: t.day,
      h: t.hour,
      min: t.min,
      s: t.sec,
      z: t.zone
    }
  end
end