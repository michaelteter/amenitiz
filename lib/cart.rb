class Cart
  attr_reader :items

  def initialize(items={})
    @items = items
  end
end
