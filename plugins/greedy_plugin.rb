class GreedyPlugin < MinecraftBase
	def test(user, *opts)
		say('Testing i say!')
	end

	def give(user, *opts)
    item = opts.shift
    count = opts.shift.to_i
    count = 1 if count.nil? or count < 1
    if count > 128
      say("Max of 128 items per request")
      count = 128
    end

  	cmd("give #{user} #{id(item)}\n" * count)
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
    kit(user, 'tools')
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
  alias_method :t, :tons

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
  def id(name)
    @blocks ||= YAML.load_file(File.join(BASE_DIR, 'config/mc_block_nameid.yml'))
    @items ||= YAML.load_file(File.join(BASE_DIR, 'config/mc_item_nameid.yml'))

    if @blocks.include? name
      return @blocks[name]
    elsif @items.include? name
      return @items[name]
    else
      return name
    end
  end

  def load_kits
    return YAML.load_file(File.join(BASE_DIR, 'config/kits.yml')) 
  end

  def givestuff(user, stuff)
		say("Giving #{user} stuff")
		stuff.each do |item|
			give(user, item[:id], item[:count])
			sleep(0.1)
		end
  end
end
