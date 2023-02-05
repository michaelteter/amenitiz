require "minitest/autorun"
require_relative "../lib/discount_service.rb"

class TestDiscountService < Minitest::Test
  def setup
    @discounts = DiscountService.load_discounts
  end

  def test_load_discounts
    assert @discounts.length > 0
    @discounts.each do |_code, discount|
      assert discount.code.is_a?(String)
    end
  end
end
