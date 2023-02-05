require "minitest/autorun"
require_relative "../lib/product"

class TestProduct < Minitest::Test
  def setup
    @p = Product.new(sku: 'GR1', name: 'Green Tea', price: 3.11)
  end

  def test_can_define_new_product
    assert_equal @p.sku, 'GR1'
    assert_equal @p.name, 'Green Tea'
    assert_equal @p.price, 3.11
  end
end

