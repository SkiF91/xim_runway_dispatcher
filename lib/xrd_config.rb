module XrdConfig
  def config
    defined?(@@config) ? @@config : nil
  end

  def config=(v)
    @@config = v
  end
end