class SystemPlugin < MinecraftBase
  def initalize(stdin, stdout, stderr)
    super(stdin,stdout,stderr)
  end

  def stop(user, *opts)
    if @admin.include? user
      say("Server is stopping in 5 seconds")
      sleep(5)
      cmd('stop')
    else
      permission_denied
    end
  end

  def list(user, *opts)
    cmd('list')
    say(read)
  end
end
