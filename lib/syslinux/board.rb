# lib/syslinux/board.rb

# Functionality for reading data
# about the system's motherboard
module Mobo
  BASEDIR = "/sys/devices/virtual/dmi/id"
  
  # Class to store instances of
  # and individual motherboard
  class Board
    # BIOS, board, and vendor
    # are hashes of their relative data
    attr_reader :bios, :board, :vendor
    
    # Constructor
    def initialize
      load BASEDIR
    end
    
    private
    # Load in the data from the files.
    # 
    # As the motherboard will not change 
    # during operation, it is not necessary
    # to update it after instantiation
    def load(dir)
      loadm dir
      loadb dir
      loadv dir
    end
    
    # board_name, product_name,
    # product_version, board_serial
    def loadm(dir)
      @board = {
        'name' => File.read("#{dir}/board_name").strip,
        'serial' => File.read("#{dir}/board_serial").strip,
        'product' => File.read("#{dir}/product_name").strip,
        'version' => File.read("#{dir}/product_version").strip
      }
    end
    
    # bios_version, bios_date
    def loadb(dir)
      @bios = {
        'version' => File.read("#{dir}/bios_version").strip, 
        'date' => File.read("#{dir}/bios_date").strip
      }
    end
    
    # board_vendor, bios_vendor
    def loadv(dir)
      @vendor = {
        'board' => File.read("#{dir}/board_vendor").strip, 
        'bios' => File.read("#{dir}/bios_vendor").strip
      }
    end
  end
end