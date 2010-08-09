#!/usr/bin/env ruby

require 'rubygems'
require 'active_support'
require 'open3'
require 'yaml'
require 'system_cmds.rb'

BASE_DIR = Dir.pwd
PLUGIN_DIR = File.join(BASE_DIR, 'plugins')

if File.exists? 'minecraft.yml'
  config_file = 'minecraft.yml'
elsif File.exists? 'config/minecraft.yml'
  config_file = 'config/minecraft.yml'
else
  puts "Unable to find minecraft.yml config file please copy the 'config/minecraft.yml.example' file to 'config/minecraft.yml' and update it with your settings"
  exit
end

CONFIG = YAML.load_file(config_file)
Xmx = CONFIG['Xmx'] || '1024M'
Xms = CONFIG['Xms'] || '1024M'

cmd = "java -Xmx#{Xmx} -Xms#{Xms} -jar #{CONFIG['server_jar']} nogui"

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
  		sys = SystemCmds.new(stdin, stdout, stderr)
    	puts "Waiting for users"
    	while true
    	  if outputs = select([stdout,stderr], nil, nil, 5)
          outputs.first.each do |io|
     	  	  line = io.gets
		  		  puts line

  				  #get_cmd(line)
  				  sys.process(line)
            #output[:cmd], output[:user], output[:opts]) if output
					end
      	else
        	#puts "Nothing happening"
      	end
		  end
    ensure
      puts "Stopping server"
      begin
        sys.process('stop', 'console')
      rescue => e
      end
    end
  end
end
