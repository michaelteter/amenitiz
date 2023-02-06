require "minitest/autorun"
require_relative "../lib/cart"

class TestCart < Minitest::Test
  def test_new_empty_cart
    cart = Cart.new
    assert_equal cart.items, {}
  end

  def test_new_filled_cart
    cart = Cart.new('GR1' => 1)
    assert_equal cart.items, { 'GR1' => 1 }
  end
end

