class MinecraftBase
	def initialize(stdin, stdout, stderr)
		@stdin = stdin
    @stdout = stdout
    @stderr = stderr
	end

	protected
  def admin?(user) 
    $CONFIG['admins'].include? user
  end

  def permission_denied
		say("You do not have permission to do that")
	end
	
  def say(text)
    cmd("say #{text}")
  end

  def cmd(text)
    puts text
    @stdin.puts(text)
    read
  end

  def read(timeout=5)
    output = @stderr.gets if select([@stderr], nil, nil, timeout)
    puts output
    unless output.nil?
      return output.match(/\[INFO\] (.*)/)[1]
    else
      return false
    end
  end
end

class SystemCmds < MinecraftBase
	def initialize(stdin, stdout, stderr)
    puts "Init"
		@stdin = stdin
    @stdout = stdout
    @stderr = stderr

		load_plugins	
	end	

  def decode(line)
    return false if line.nil?

    if m = line.match(/<(\w+)>\s#(\w+)\s*(.*)/)
      marray = m.to_a
      matched = marray.shift
      cmd = { :user => marray.shift, :cmd => marray.shift.to_sym }
      cmd[:opts] = marray.shift.split(' ').compact
      return cmd
    elsif m = line.match(/\[INFO\] (\w+) \[([\/\d\.]+):\d+\] logged in/)
      marray = m.to_a
      matched = marray.shift
      cmd = { :user => marray.shift, :cmd => 'login' }
      cmd[:opts] = marray.shift
      return cmd
    else
      false
    end
  end

	def process(line)
    output = decode(line)
    return unless output

    begin
  		if self.respond_to? output[:cmd]
  			self.send(output[:cmd], output[:user], *output[:opts])
  		else
  			@plugins.each do |plugin|
          if plugin.respond_to? output[:cmd]
			      plugin.send(output[:cmd], output[:user], *output[:opts]) 
          end
			  end
      end
    rescue Exception => e
      say("Exception occured while executing command")
      puts "Exception: #{e}"
      puts "Params: #{output.inspect}"
      puts e.backtrace
		end
	end

	def reload(user, *opts)
		if $CONFIG['admins'].include? user
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

	def load_plugins
    puts "Loading Plugins"

		@plugins = []
		Dir.entries(PLUGIN_DIR).each do |plugin|
			next if plugin[0] == ?.
			f = File.join(PLUGIN_DIR, plugin)

      puts "Requiring #{f}"
      require f 

      klass = Kernel.const_get(File.basename(f, '.rb').classify)
      puts "Found #{klass}"
      
 
			@plugins << klass.new(@stdin, @stdout, @stderr)
		end
	end
end
