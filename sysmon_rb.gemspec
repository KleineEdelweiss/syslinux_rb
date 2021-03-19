# frozen_string_literal: true
require_relative "lib/sysmon_rb/version.rb"

Gem::Specification.new do |spec|
  spec.name = "sysmon_rb"
  spec.version = SysMon::VERSION
  spec.summary = "Access Linux system information in Ruby"
  spec.description = <<~DESC
    Ruby module to provide access to Linux system information.
    Makes use of /proc/ and /sys/ and their subdirectories.
    This gem can be used on its own or in part of a monitor server
    for real-time updates. It is loosely based off of Python's
    `psutil` library.
    
    + Some of the operations require `root` access.
  DESC
  spec.authors = ["Edelweiss"]
  
  spec.homepage = "https://github.com/KleineEdelweiss/sysmon_rb"
  spec.licenses = ["LGPL-3.0"]
  spec.metadata = {
    "homepage_uri"        => spec.homepage,
    "source_code_uri"     => "https://github.com/KleineEdelweiss/sysmon_rb",
    #"documentation_uri"   => "",
    #"changelog_uri"       => "https://github.com/KleineEdelweiss/sysmon_rb/blob/master/CHANGELOG.md",
    "bug_tracker_uri"     => "https://github.com/KleineEdelweiss/sysmon_rb/issues"
  }
  
  spec.files = Dir.glob("lib/**/*")
  
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.rdoc_options += [
    "--title", "SysMon RB -- Linux Ruby System Info",
    "--main", "README.md",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]
  
  spec.required_ruby_version = ">= 2.7.0"
end