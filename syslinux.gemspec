# frozen_string_literal: true
require_relative "lib/syslinux/version.rb"

Gem::Specification.new do |spec|
  spec.name = "syslinux"
  spec.version = Syslinux::VERSION
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
  
  spec.homepage = "https://github.com/KleineEdelweiss/syslinux_rb"
  spec.licenses = ["LGPL-3.0"]
  spec.metadata = {
    "homepage_uri"        => spec.homepage,
    "source_code_uri"     => "https://github.com/KleineEdelweiss/syslinux_rb",
    #"documentation_uri"   => "",
    #"changelog_uri"       => "https://github.com/KleineEdelweiss/syslinux_rb/blob/master/CHANGELOG.md",
    "bug_tracker_uri"     => "https://github.com/KleineEdelweiss/syslinux_rb/issues"
  }
  
  spec.files = Dir.glob("lib/**/*")
  
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.rdoc_options += [
    "--title", "Syslinux -- Linux System Info",
    "--main", "README.md",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]
  
  spec.required_ruby_version = ">= 2.7.0"
end