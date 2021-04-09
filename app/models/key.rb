class Key
  attr_reader :name

  def self.all(environment, node)
    facts = node.facts(environment: environment)
    HieraData.new(environment.name).all_keys(facts)
      .map { |name| new(environment, node, name) }
  end

  def initialize(environment, node, name)
    @environment = environment
    @node = node
    @name = name
  end

  def hierarchies
    facts = @node.facts(environment: @environment)
    @hierarchies ||= hiera_data.search_key(facts, name)
  end

  def save_value(path, value)
    value = YAML.load(value)
    hiera_data.write_key(path, name, value)
  end

  def remove_value(path)
    hiera_data.remove_key(path, name)
  end

  def ==(other)
    other.is_a?(Key) && name == other.name
  end

  def to_param
    name
  end

  def to_s
    name
  end

  private

  def hiera_data
    @hiera_data ||= HieraData.new(@environment.name)
  end
end
