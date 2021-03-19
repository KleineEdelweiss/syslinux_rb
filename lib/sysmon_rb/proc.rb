# lib/sysmon_rb/proc.rb

# Functionality for reading data
# about active processes on the
# host system.
module Processes
  # Count the total number of processes running
  # on the host system
  def self.count
    list.length
  end
  
  # List the numbers of processes running
  def self.list
    Dir.entries("/proc").reject {|e| !e.match?(/^\d+$/)}
  end
  
  # Possible addition, later
  # 
  # Class that handle functions associated with
  # individual processes, such as kill, name, etc.
  class Proc
    
  end
end