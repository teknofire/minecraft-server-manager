class MinecraftBase
	def initialize(input)
		@input = input
	end

	protected

  def say(text)
    cmd("say #{text}")
  end

  def cmd(text)
    @input.puts(text)
  end
end

class SystemCmds < MinecraftBase
	def initialize(input)
    @admin = %w{ console teknofire b1sh0p }
		@input = input
		load_plugins	
	end	

	def process(cmd, user, *h)
		if self.respond_to? cmd
			self.send(cmd, user, *h)
		else
			@plugins.each do |plugin|
				plugin.send(cmd, user, *h) if plugin.respond_to? cmd
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
		Dir.entries('plugins').each do |plugin|
			next if plugin[0].chr == '.'
			load plugin
			@plugins << Kernel.const_get(plugin.gsub('.rb', '').classify).new(@input)
		end
	end
end
