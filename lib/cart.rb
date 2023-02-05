class Cart
  attr_reader :items

  def initialize(args={})
    args.each { |k,v| instance_variable_set("@#{k}", v) unless v.nil? }
    @items = {} if @items.nil?
  end
end
