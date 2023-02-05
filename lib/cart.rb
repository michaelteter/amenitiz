class Cart
  attr_reader :items

  def initialize(args={})
    args.each { |k,v| instance_variable_set("@#{k}", v) unless v.nil? }
    @items = {} if @items.nil?
  end

  def to_s
    @items.map { |sku, qty| "#{sku}: #{qty}" }.join("\n")
  end
end
