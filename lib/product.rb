class Product
  attr_reader :sku, :name, :price

  def initialize(args)
    args.each { |k,v| instance_variable_set("@#{k}", v) unless v.nil? }
  end
end
