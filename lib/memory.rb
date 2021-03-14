# lib/memory.rb
require './gen.rb'

module Memory
  # Memory spec access requires
  # the `dmidecode --type 17` call -- this
  # call is in `/usr/sbin` and can
  # only be run as `root` / ID: 0.
  # This above is handled by the module.
  # 
  # If spec access is available, each
  # memory module is initialized as a
  # Dimm class object for individual
  # analysis of the stick.
  # 
  # NOTE: Frequency (MT/s -- megatransfers, often
  # [incorrectly] called megahertz) is part of each
  # DIMM, and this data can NOT be accessed by
  # unprivileged users (non-root).
  # 
  # Basic usage info can still be done by
  # a normal user, and this is handled
  # by the SimpleMem class
  
  # Is `dmidecode` present on system?
  @@specs = false
  # Is the running user `root`?
  @@root = false
  # DIMMs for the whole system
  @@dimms = []
  
  # Validate authorization and tools for
  # RAM information access
  def self.init
    @@specs = File.exist?("/usr/sbin/dmidecode")
    @@root = Generics::root
  end
  
  # Load in each of the DIMM slots
  # and their corresponding chip info
  def self.load
    if @@specs && @@root then
      @@dimms = `dmidecode --type 17`.split(/^\s*$/).reject! do |item|
        item.start_with?('#')
      end.collect do |data|
        dimm = Dimm.new data
      end
    end
  end
  def self.read
    self.load
  end
  
  # Return a count of all the DIMMs
  # in the system
  def self.length
    @@dimms.length
  end
  def self.count
    self.length
  end
  
  # Get data from a specific stick
  def self.fetch(num)
    if self.length > num then
      @@dimms[num]
    else
      STDERR.puts "\nRequested DIMM slot out of range!\n"
      nil
    end
  end
  
  # Get the system-wide RAM usage
  # (NOT `root`-only).
  # This information is handled with
  # the `/proc` directory and requires
  # no additional programs or access.
  class SimpleMem
    # Total memory and free memory,
    # measured in kB, will be stored
    # as private instance variables,
    # as they should only ever be
    # seen from stat()
    
    # Constructor
    def initialize
      update
    end
    
    # Return the 3 numeric stats
    # and the 2 percentages
    def stat
      update
      {'total' => @total, 'free' => @free, 'used' => used}.merge!percs
    end
    
    # These methods should not be accessed directly
    private
    # Update the memory
    def update
      raw = read
      @total = Generics.parse_nums(raw['memtotal']).to_f
      @free = Generics.parse_nums(raw['memavailable']).to_f
    end
    
    # Read the simple memory data
    def read
      data = File.read("/proc/meminfo")
      Generics.rm_unhashable(data).map do |row|
        Generics.fields(row)
      end.to_h
    end
    
    # Memory currently in use
    def used
      @total - @free
    end
    
    # Memory as percentages
    def percs
      freep = "#{((@free / @total) * 100).round 2}%"
      usedp = "#{((used / @total) * 100).round 2}%"
      {'freep' => freep, 'usedp' => usedp}
    end
  end
  
  # Class for the DIMMs, to store
  # instance data and operations
  class Dimm
    # Instance hash
    attr_reader :data
    
    # Constructor
    def initialize(data)
      @data = map_fields(data)
    end
    
    # Map data for each DIMM
    def map_fields data
      Generics.rm_unhashable(data).map do |row|
        Generics.fields(row)
      end.to_h
    end
    
    # Return the RAM speeds
    # (DDR rated and actual).
    # The DDR-rated is what most
    # people will want to know.
    def speed
      idx = ['speed', 'configured_memory_speed']
      {idx[0] => @data[idx[0]], idx[1] => @data[idx[1]]}
    end
    
    # Return the DDR type -- 'ddr3', 'ddr4'
    def type
      @data['type']
    end
    
    # For those interested, return the
    # RAM chip's part number for lookups
    def part_number
      @data['part_number']
    end
    
    # Return a hash of the minimum,
    # maximum, and current voltages
    # for the RAM chip
    def voltage
      idx = ['configured_voltage', 'minimum_voltage', 'maximum_voltage']
      {idx[0] => @data[idx[0]], idx[1] => @data[idx[1]], idx[2] => @data[idx[2]]}
    end
    
    # Return the memory ranks
    # on the chip
    def rank
      @data['rank']
    end
  end
end