# lib/sysmon_rb/cpu.rb
require './gen.rb'

# Functionality for reading data
# about the system's CPU[s]
module Cpu
  # Store unchanging processor
  # data -- number of processors
  # as Chip class objects
  @@cpus = Hash.new
  
  # Load up each CPU
  def self.init
    self.read
  end
  
  # Read in the CPU cores
  def self.read
    File.read("/proc/cpuinfo").split(/^\s*$/)
    .map do |segment|
      Generics.rm_unhashable(segment).map do |row|
        Generics.fields(row)
      end.to_h
    end.map do |core|
      pid = core['physical_id']
      @@cpus[pid] ||= Chip.new core
      @@cpus[pid].add core
    end
    true
  end
  def self.update() self.read() end
  
  # Number of CPUs in system
  def self.count
    @@cpus.length
  end
  
  # Get a specific chip
  def self.chip(key) @@cpus.fetch(key, nil) end
  
  # Chip class to store individual
  # Chip objects and associated
  # access methods
  class Chip
    # Hash object for each chip
    attr_reader :chip
    
    # Create a chip from the first core added
    def initialize init_core
      @chip = {
        'id' => init_core['physical_id'],
        'cores' => init_core['cpu_cores'],
        'threads' => init_core['siblings'],
        'processors' => Hash.new
      }
      add init_core
    end
    
    # Add a core to the chip
    def add(core)
      if @chip['id'] == core['physical_id'] then
        ident = 'apicid'
        cid = core[ident]
        @chip['processors'][cid] = core
      end
    end
    
    # Get a specific core
    def get_core(apicid)
      @chip['processors'].fetch(apicid, false)
    end
    
    # Get the socket/ID
    def id() @chip['id'].to_i end
    alias :socket :id
    
    # Get the core count
    def cores() @chip['cores'].to_i end
    
    # Get the thread count
    def threads() @chip['threads'].to_i end
      
    # Get the core speeds
    def speed_raw
      processors.map do |_i, item|
        item['cpu_mhz'].to_f
      end
    end
    
    # Get the average CPU speed
    def speed() speed_raw.sum.fdiv(threads).round(2) end
    
    # Return each core/thread
    def processors() @chip['processors'] end
  end
end