#!/usr/bin/env ruby

require 'fileutils'
require "open-uri"

log_file = ARGV[0]
unless log_file
  puts "    Usage: ./export.rb autopage.log"
  exit
end

HOST = "http://fine.ap.teacup.com"

log = File.open(log_file, "r:cp932:utf-8").read

FileUtils.mkdir_p 'images'
images = log.scan %r{<img\ssrc="(/\S+/timg/\S+.jpg)"[^>]*>}
images.flatten.each do |image_path|
  image_path
  original_image_path = image_path.gsub('timg', 'img').gsub('middle_', '')

  [image_path, original_image_path].each do |path|
    FileUtils.mkdir_p "images#{File.dirname(path)}"
    File.open("images#{path}", 'wb') { |f| f.write(open("#{HOST}#{path}").read) }
    puts "saved: #{path}"
    sleep 1
  end
end
