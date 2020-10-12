module XrdConfig
  def config
    @config || {}
  end

  def config=(v)
    @config = v
  end
end