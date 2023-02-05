require_relative 'lib/cart'
require_relative 'lib/cart_service'
require_relative 'lib/catalog_service'
require_relative 'lib/discount_service'
require_relative 'lib/product'

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

    puts

    cart = Cart.new
    puts 'Cart'
    cart = CartService.add_item(cart: cart, sku: catalog.keys[0], qty: 3)
    cart = CartService.remove_item(cart: cart, sku: catalog.keys[0], qty: 2)
    cart = CartService.add_item(cart: cart, sku: catalog.keys[1], qty: 1)
    cart = CartService.add_item(cart: cart, sku: catalog.keys[1], qty: 1)
    puts cart

    0
  end
end

CartApp.launch_app if __FILE__ == $PROGRAM_NAME
