class GreedyPlugin < MinecraftBase
	def test(user, *opts)
		say('Testing i say!')
	end

  def what(user, *opts)
    if id(opts.first) != opts.first
      say("#{opts.first} is #{id(opts.first)}")
    else
      say("I don't know what #{opts.first} is")
    end
  end

	def give(user, *opts)
    item = opts.shift
    count = opts.shift.to_i
    count = 1 if count.nil? or count < 1
    if count > max(item)
      say("Max for specified item is #{max(item)}")
      count = max(item)
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
  def blocks
    @blocks ||= YAML.load_file(File.join(BASE_DIR, 'config/blocks.yml'))
    @blocks
  end
  def items
    @items ||= YAML.load_file(File.join(BASE_DIR, 'config/items.yml'))
    @items
  end
  
  def get(name)
    if i = get_from_hash(name, blocks)
      return i
    elsif i = get_from_hash(name, items)
      return i
    else
      nil
    end 
  end

  def get_from_hash(name, hash)
    return hash[name] if hash.key? name 
    i = hash.select { |k,v| v['id'].to_s == name }
    return i.empty? ? false : i.first[1]
  end

  def id(name)
    i = get(name)
    return i.nil? ? name : i['id']
  end

  def max(name)
    i = get(name)
    return i.nil? ? 128 : i['max']
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
