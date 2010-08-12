class SystemPlugin < MinecraftBase
  def initalize(stdin, stdout, stderr)
    super(stdin,stdout,stderr)
  end

  def stop(user, *opts)
    if admin? user
      say("Server is stopping in 5 seconds")
      sleep(5)
      cmd('stop')
    else
      permission_denied
    end
  end

  def list(user, *opts)
    say cmd('list')
  end

  def login(user, *opts)
    op(user, user)
  end
  
  def op(user, *opts)
    if admin? user
      say cmd("op #{opts.first}")
    end
  end

  def deop(user, *opts)
    if admin? user
      say cmd("deop #{opts.first}")
   end
  end
end
