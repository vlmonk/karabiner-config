class Rules
  def initialize(name)
    @name = name
    @set = []
  end

  def as_json
    {
      description: @name,
      manipulators: @set
    }
  end

  def <<(item)
    @set << item.merge(type: 'basic')
  end
end