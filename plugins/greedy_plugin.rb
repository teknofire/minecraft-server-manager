class GreedyPlugin < MinecraftBase
	def test(user, *h)
		say('Testing i say!')
	end

	def give(user, *h)
    opts = h.first
		cmd("give #{user} #{opts[0]}\n" * opts[1].to_i)
	end
	
	def gimme(user, *h)
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
		}, {
			:id => 50,
			:count => 64
		}, {
			:id => 46,
			:count => 384
		}, {
			:id => 333,
			:count => 1
		}]
		say("Giving #{user} stuff")
		stuff.each do |item|
			give(user, item[:id], item[:count])
			sleep(0.1)
		end
	end
end
