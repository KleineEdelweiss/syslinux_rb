# lib/syslinux/cpu.rb
require './gen.rb'

# Functionality for reading data
# about the system's CPU[s]
module Cpu
  # Store unchanging processor
  # data -- number of processors
  # as Chip class objects
  @@cpus = []
  
  # Load up each CPU
  def self.init
    
  end
  
  # Number of CPUs in system
  def self.count
    @@cpus.length
  end
  
  # Load up a raw count of
  # cores and threads
  def self.raw_ct
    raw = File.read("/proc/cpuinfo").split(/^\s*$/)
    last = raw.length
    puts "Read in: #{last}"
    cores = raw.map do |segment|
      Generics.rm_unhashable(segment).map do |row|
        Generics.fields(row)
      end.to_h
    end
    
    chips = Hash.new
    cores.map do |core|
      pid = core['physical_id']
      if chips.include?(pid) then
        chips[pid]['processors'].push(core)
      else
        chips[pid] = {
          'cores' => core['cpu_cores'],
          'threads' => core['siblings'],
          'processors' => []
        }
        chips[pid]['processors'].push(core)
      end
    end
    
    chips.map do |id, chip|
      puts "Chip #{id} has #{chips[id]['cores']} cores and #{chips[id]['threads']} threads"
    end
  end
  
  # Chip class to store individual
  # Chip objects and associated
  # access methods
  class Chip
    
  end
end