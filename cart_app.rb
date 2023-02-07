require_relative 'lib/cart'
require_relative 'lib/cart_service'
require_relative 'lib/catalog_service'
require_relative 'lib/discount_service'
require_relative 'lib/display_service'

class CartApp
  def launch_app = event_loop

  private

  MENU = [
    [:show_products,  'Show available products'],
    [:add_item,       'Add item to your cart'],
    [:remove_item,    'Remove item from your cart'],
    [:show_cart,      'Show your cart'],
    [:empty_cart,     'Empty your shopping cart'],
    [:show_discounts, 'Show available discounts'],
    [:exit,           'Exit the shop']
  ]

  def initialize
    @cart      = Cart.new
    @catalog   = CatalogService.load_products
    @discounts = DiscountService.load_discounts
  end

  def event_loop
    loop do
      puts
      puts '-------------------------------------------------'
      show_menu
      puts
      print 'Please select a menu item: '
      menu_selection = gets.chomp

      unless menu_selection.to_i.between?(1, MENU.length)
        puts
        puts "Please choose a number between 1 and #{MENU.length}."
        next
      end

      puts

      case MENU[menu_selection.to_i - 1][0]
        when :show_products
          puts 'Available Products'
          puts DisplayService.catalog_to_s(@catalog)
        when :add_item
          sku = get_product_sku_input
          if sku
            @cart = CartService.add_item(cart: @cart, sku: sku)
            puts
            puts '================================================='
            show_cart
          end
        when :remove_item
          sku = get_product_sku_input
          if sku
            @cart = CartService.remove_item(cart: @cart, sku: sku)
            puts
            puts '================================================='
            show_cart
          end
        when :show_cart
          puts '================================================='
          show_cart
        when :empty_cart
          @cart = Cart.new
          puts 'Your cart is now empty.'
        when :show_discounts
          puts 'Discounts'
          puts DisplayService.discounts_to_s(@discounts)
        when :exit
          break
      end
    end

    puts 'Thank you.  Please come again.'
    0 # POSIX-happy return value
  end

  def get_product_sku_input
    skus = @catalog.keys
    print "Please enter a product code from #{skus.join(', ')}: "
    sku = gets.chomp&.upcase
    if skus.include?(sku)
      sku
    else
      puts 'Product not found.'
      nil
    end
  end


  def show_menu
    puts '::: Commands :::'
    puts MENU.map.with_index(1) { |item, i| "#{i}. #{item[1]}" }.join("\n")
  end

  def show_cart
    puts 'Your shopping cart'
    puts DisplayService.cart_to_s(@cart)
    show_cart_total
    puts ' (Note: total includes any applied discounts)'
  end

  def show_cart_total = puts "> Total: #{Util.euro_formatted_currency(CartService.cart_total(@cart))} <"
end

# =======================================================================

CartApp.new.launch_app if __FILE__ == $PROGRAM_NAME
