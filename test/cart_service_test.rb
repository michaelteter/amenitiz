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

  def test_cart_line_to_s
    p = @catalog.values.first
    qty = 2
    line_s = CartService.cart_line_to_s(p, qty)
    assert line_s.include?(p.sku)
    assert line_s.include?(p.name)
    assert line_s.include?(qty.to_s)
    assert line_s.include?(Util.formatted_currency(p.price))
    assert line_s.include?(Util.formatted_currency(CartService.cart_line_total(p, qty)))
  end
end
