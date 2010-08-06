#!/usr/bin/env ruby

require 'rubygems'
require 'active_support'
require 'open3'
require 'yaml'
require 'system_cmds.rb'

PLUGIN_DIR = File.join(Dir.pwd, 'plugins')
CONFIG = YAML.load_file('minecraft.yml')

cmd = "java -Xmx1024M -Xms1024M -jar #{CONFIG['server_jar']} nogui"

def get_cmd(line)
	if m = line.match(/<(\w+)>\s#(\w+)\s*(.*)/)
		marray = m.to_a
		matched = marray.shift
		cmd = { :user => marray.shift, :cmd => marray.shift.to_sym }
		cmd[:opts] = marray.shift.split(' ').compact

		return cmd
	else
		false
	end
end

puts "Starting minecraft server"
Dir.chdir(CONFIG['server_path']) do
  Open3.popen3(cmd) do |stdin,stdout,stderr| 
    ready = false
    while true 
      if select([stderr],nil,nil, 5)
        output = stderr.gets
        if output.match(/\[INFO\] Done!/)
          puts "Server ready"
          break
        else
          puts output
        end
      else
        puts "Nothing to do"
      end
    end

  	begin
  		sys = SystemCmds.new(stdin)
    	puts "Waiting for users"
    	while true
    	  if io = select([stderr], nil, nil, 5)
     	  	line = stderr.gets
		  		puts line

  				output = get_cmd(line)
  				sys.process(output[:cmd], output[:user], output[:opts]) if output
      	else
        	puts "Nothing happening"
      	end
		  end
    rescue Exception => e
      puts "An exception occured"
      puts e
    ensure
      puts "Stopping server"
      sys.process('stop', 'console')
    end
  end
end
