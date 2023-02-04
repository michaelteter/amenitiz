require_relative 'lib/product'
require_relative 'lib/catalog_service'

module CartApp
  extend self

  def launch_app
    catalog = CatalogService.load_products
    puts 'Catalog'
    pp CatalogService.to_a(catalog)
    0
  end
end

CartApp.launch_app if __FILE__ == $PROGRAM_NAME
