class MinecraftBase
	def initialize(input)
		@input = input
	end

	protected

  def say(text)
    cmd("say #{text}")
  end

  def cmd(text)
    puts text
    @input.puts(text)
  end
end

class SystemCmds < MinecraftBase
	def initialize(input)
    @admin = %w{ console teknofire b1sh0p }
		@input = input
		load_plugins	
	end	

  def decode(line)
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

	def process(line)
    output = decode(line)
    return unless output

		if self.respond_to? output[:cmd]
			self.send(output[:cmd], output[:user], *output[:opts])
		else
			@plugins.each do |plugin|
        begin
          if plugin.respond_to? output[:cmd]
			      plugin.send(output[:cmd], output[:user], *output[:opts]) 
          end
        rescue => e
          puts "Exception: #{output.inspect}"
          puts e
        end
			end
		end
	end

	def stop(user, *h)
    if @admin.include? user
      say("Server is stopping in 5 seconds")
      sleep(5)
      cmd('stop')
    else
			permission_denied
    end
	end
	
	def reload(user, *h)
		if @admin.include? user
			say("Reloading plugins")
			@plugins.each do |plugin|
				begin
					Object.instance_eval(:remove_const, plugin.class.to_s)
				rescue
				end
			end
			load_plugins
		else
			permission_denied
		end	
	end

	protected
	def permission_denied
		say("You do not have permission to do that")
	end
	
	def load_plugins
		@plugins = []
		Dir.entries(PLUGIN_DIR).each do |plugin|
			next if plugin[0].chr == '.'
			load File.join(PLUGIN_DIR, plugin)
			@plugins << Kernel.const_get(plugin.gsub('.rb', '').classify).new(@input)
		end
	end
end
