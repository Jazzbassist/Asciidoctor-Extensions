#!/bin/ruby
require 'json'
ARGV.each do|path|
  raise ArgumentError, "Argument is not a path" unless File.file? path
  jsonfile=File.open path
  hash=JSON.load jsonfile
  prettyfile=File.open %(prettyjson #{path.gsub("/", "sl")}), 'w'
  prettyfile.write JSON.pretty_generate hash
  prettyfile.close
  jsonfile.close
end
