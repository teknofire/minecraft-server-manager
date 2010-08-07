class GreedyPlugin < MinecraftBase
	def test(user, *opts)
		say('Testing i say!')
	end

	def give(user, *opts)
    id = opts.shift
    count = opts.shift
    count = 1 if count.nil?

		cmd("give #{user} #{id}\n" * count.to_i)
	end

  def kit(user, *opts)
    kit = load_kits[opts.first]
    if kit.nil? 
      say("Could not find the #{opts.first} kit")
      return
    end

    kit.each do |item|
      give(user, *item)
    end
  end

  def kits(user, *opts)
    say("Available kits: #{load_kits.keys.join(', ')}")  
  end

  def tools(user, *opts)
 		stuff = [{
			:id => 276,
			:count => 1
		}, {
			:id => 277,
			:count => 1
		}, {
			:id => 278,
			:count => 1
		}, {
			:id => 279,
			:count => 1
		}]
    givestuff(user, stuff)
  end

  def tnt(user, *opts)
    say("Happy exploding")
    give(user, 46, 128)
  end

  def boat(user, *opts)
    give(user, 333, 1)
  end

  def tons(user, *opts)
    give(user, opts.first , 128)
  end

	def gimme(user, *opts)
		stuff = [{
			:id => 50,
			:count => 64
		}, {
      :id => 333,
      :count => 1
    }]
    givestuff(user, stuff)
    say("Have you tried asking for #tools or #tnt?")
	end

  protected

  def load_kits
    return YAML.load_file(File.join(BASE_DIR, 'kits.yml')) 
  end

  def givestuff(user, stuff)
		say("Giving #{user} stuff")
		stuff.each do |item|
			give(user, item[:id], item[:count])
			sleep(0.1)
		end
  end
end
