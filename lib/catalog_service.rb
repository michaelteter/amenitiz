require 'csv'

module CatalogService
  extend self

  DEFAULT_PRODUCT_CATALOG = 'products.csv'

  def build_product_from_raw_data(raw_product)
    # Given a "raw" product as defined in a CSV file row,
    #   build a proper Product object.  Perform any
    #   type conversions as necessary.
    sku, name, price = raw_product.map(&:strip)
    Product.new(sku: sku, name: name, price: Float(price))

  rescue StandardError => e
    puts "Error building product from raw data: #{e}"
    nil
  end

  def load_products(source=DEFAULT_PRODUCT_CATALOG)
    filepath = File.join(File.dirname(__FILE__), '..', 'assets', source)

    # Read the CSV data, ignoring the header and any blank lines
    raw_data = CSV.read(filepath)&.[](1..-1).reject(&:empty?) || []

    # Build a product catalog from the raw data
    catalog = {}
    raw_data.each do |raw_product|
      p = build_product_from_raw_data(raw_product)
      catalog[p.sku] = p
    end

    catalog
  end

  def to_a(catalog)
    [['SKU', 'Name', 'Price']] +
      catalog.map { |_sku, product| [product.sku, product.name, product.price] }
  end
end
