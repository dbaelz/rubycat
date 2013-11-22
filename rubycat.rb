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
  IO.popen("adb logcat -v long") do |log|
    color = "white"
    while line = log.gets

      if line.start_with?("[")
        loglevel.each_pair do |key, value| 
          if line.include?(key)
            prio = (value[:name]).bold.inverse
            color = value[:color]            
            header = "#{prio}\t#{line}".send(color)

            value.has_key?(:format) ? (puts header.send(value[:format])) : (puts header)
          end
        end
      else
        output = "\t#{line}".send(color)
        puts output
      end      
    end  
  end
rescue Interrupt
  puts "-- END RUBYCAT --".magenta.bold.inverse
rescue Exception => e
  puts e
end