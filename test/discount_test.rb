require "minitest/autorun"
require_relative "../lib/discount.rb"

class TestDiscount < Minitest::Test
  def setup
    @d = Discount.new(code:        'GR1-N-for-M',
                      description: 'buy {{buy_count}} get {{free_count}} free for green tea',
                      product_sku: 'GR1',
                      rule_name:   'BUY_N_GET_M_FREE',
                      rule_params: {'buy_count' => 1, 'free_count' => 1})
  end

  def test_define_new_discount
    assert_equal @d.code, 'GR1-N-for-M'
  end

  def test_realize_description
    assert_equal @d.realized_description, 'buy 1 get 1 free for green tea'
  end
end

