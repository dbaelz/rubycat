#!/usr/bin/env ruby

# CC0 - Public domain
# http://creativecommons.org/publicdomain/zero/1.0/

require 'smart_colored/extend'

loglevel = {"V/" => {:name => "VERBOSE", :color => "white"},
            "D/" => {:name => "DEBUG", :color => "blue"},
            "I/" => {:name => "INFO", :color => "green"},
            "W/" => {:name => "WARNING", :color => "yellow"},
            "E/" => {:name => "ERROR", :color => "red", :format => "inverse"},
            "F/" => {:name => "FATAL", :color => "magenta"},
            "S/" => {:name => "SILENT", :color => "cyan"}}

begin
  IO.popen("adb logcat") do |log|
    while line = log.gets

      loglevel.each_pair do |key, value| 
        if line.start_with?(key)
          prio = (value[:name]).bold.inverse
          color = value[:color]
          output = "#{prio}\t#{line[2..-1]}".send(color)

          value.has_key?(:format) ? (puts output.send(value[:format])) : (puts output)
        end
      end
    end  
  end
rescue Interrupt
  puts "-- END RUBYCAT --".magenta.bold.inverse
rescue Exception => e
  puts e
end
