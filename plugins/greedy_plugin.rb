class GreedyPlugin < MinecraftBase
	def test(user, *h)
		say('Testing i say!')
	end

	def give(user, *h)
    opts = h.first
    id = opts.shift
    count = opts.shift
    count = 1 if count.nil?

		cmd("give #{user} #{id}\n" * count.to_i)
	end

  def tools(user, *h)
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

  def tnt(user, *h)
    say("Happy exploding")
    give(user, [45, 384])
  end
	
	def gimme(user, *h)
		stuff = [{
			:id => 50,
			:count => 64
		}]
    givestuff(user, stuff)
    say("Have you tried asking for #tools or #tnt?")
	end

  protected

  def givestuff(user, stuff)
		say("Giving #{user} stuff")
		stuff.each do |item|
			give(user, [item[:id], item[:count]])
			sleep(0.1)
		end
  end
end
