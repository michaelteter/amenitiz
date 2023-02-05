require "minitest/autorun"
require_relative "../lib/cart"
require_relative "../lib/cart_service.rb"

class TestCartService < Minitest::Test
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
  end
end
