require "minitest/autorun"
require_relative "../lib/cart"
require_relative "../lib/cart_service"
require_relative "../lib/catalog_service"

class TestCartService < Minitest::Test
  def setup
    @catalog = CatalogService.load_products
  end

  def test_add_item
    cart = CartService.add_item(cart: Cart.new, sku: 'GR1', qty: 1)
    assert_equal cart.items, { 'GR1' => 1 }

    cart = CartService.add_item(cart: cart, sku: 'SR1', qty: 2)
    assert_equal cart.items, { 'GR1' => 1, 'SR1' => 2 }
  end

  def test_empty_cart_remove_item
    cart = CartService.remove_item(cart: Cart.new, sku: 'GR1', qty: 1)
    assert_equal cart.items, {}
  end

  def test_cart_remove_item
    cart = CartService.add_item(cart: Cart.new, sku: 'GR1', qty: 1)
    updated_cart = CartService.remove_item(cart: cart, sku: 'GR1')
    refute_equal cart.items, updated_cart.items
    assert_nil updated_cart.items['GR1']

    cart = CartService.add_item(cart: Cart.new, sku: 'GR1', qty: 5)
    updated_cart = CartService.remove_item(cart: cart, sku: 'GR1', qty: 4)
    refute_equal cart.items, updated_cart.items
    assert_equal updated_cart.items['GR1'], 1
  end

  def test_cart_total
    cart = CartService.add_item(cart: Cart.new, sku: 'GR1', qty: 1)
    test_total = @catalog['GR1'].price
    assert_equal test_total, CartService.cart_total(cart)
  end

  def test_cart_line_total
    p = @catalog.values.first
    calculated_total = CartService.cart_line_total(p, 2)
    manual_total = p.price * 2
    assert_equal calculated_total, manual_total
  end

  def test_cart_total
    # **Test data**
    # | Basket | Total price expected |
    # |--|--|
    # | GR1,GR1 |  3.11€ |
    # | SR1,SR1,GR1,SR1 |  16.61€ |
    # | GR1,CF1,SR1,CF1,CF1 |  30.57€ |

    cart = CartService.add_item(cart: Cart.new, sku: 'GR1', qty: 2)
    assert_equal 3.11, CartService.cart_total(cart)

    cart = CartService.add_item(cart: Cart.new, sku: 'SR1', qty: 3)
    cart = CartService.add_item(cart: cart, sku: 'GR1', qty: 1)
    assert_equal 16.61, CartService.cart_total(cart)

    cart = CartService.add_item(cart: Cart.new, sku: 'GR1', qty: 1)
    cart = CartService.add_item(cart: cart, sku: 'CF1', qty: 3)
    cart = CartService.add_item(cart: cart, sku: 'SR1', qty: 1)
    assert_equal 30.57, CartService.cart_total(cart)
  end
end
