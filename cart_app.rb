require_relative 'lib/product'
require_relative 'lib/catalog_service'
require_relative 'lib/discount_service'

module CartApp
  extend self

  def launch_app
    catalog = CatalogService.load_products
    puts 'Catalog'
    catalog.each { |_sku, product| puts product }

    puts

    discounts = DiscountService.load_discounts
    puts 'Discounts'
    discounts.each { |_code, discount| puts discount }

    0
  end
end

CartApp.launch_app if __FILE__ == $PROGRAM_NAME
