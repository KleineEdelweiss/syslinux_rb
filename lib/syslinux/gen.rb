# lib/syslinux/gen.rb

# Generic functions for the whole
# library to use
module Generics
  # Check if program is run
  # by `root` user
  def self.root
    `id -u`.strip.to_i == 0
  end
  
  # Do not include unsplittable fields
  # for a row hash
  def self.rm_unhashable(data)
    data.split(/$/).reject! do |item|
      item.length == 0 or not item.match(/:/)
    end
  end
  
  # Split a known set of 2-field
  # row data into indexed fields
  def self.fields(row)
    key, val = row.split(':')
    k = key.strip.downcase.gsub(/[\s-]+/, '_')
    v = val.strip.downcase
    [k, v]
  end
  
  # Remove suffixes
  def self.parse_nums(s)
    s.gsub(/\D+/, '')
  end
end