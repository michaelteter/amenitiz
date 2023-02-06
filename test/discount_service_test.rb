require "minitest/autorun"
require_relative "../lib/cart"
require_relative "../lib/catalog_service"
require_relative "../lib/discount_service"

class TestDiscountService < Minitest::Test
  def setup
    @catalog = CatalogService.load_products
    @discounts = DiscountService.load_discounts
    @sample_cart = Cart.new('GR1' => 2, 'SR1' => 5, 'CF1' => 10)

    @product = Product.new(sku: 'FOO', name: 'Foo d', price: 1)
    @discount = Discount.new(code:        'FOO-N-for-M',
                             product_sku: 'FOO',
                             description: 'Buy {{buy_count}}, and get {{free_count}} more free!',
                             rule_name:   'BUY_N_GET_M_FREE',
                             rule_params: { 'buy_count' => 5, 'free_count' => 2 })
  end

  def test_load_discounts
    assert @discounts.length > 0
    @discounts.each do |_code, discount|
      assert discount.code.is_a?(String)
    end
  end

  def test_apply_buy_n_get_m_free
    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 0)
    assert_equal total, 0

    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 1)
    assert_equal total, 1 * @product.price

    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 5)
    assert_equal total, 5 * @product.price

    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 6)
    assert_equal total, 5 * @product.price

    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 7)
    assert_equal total, 5 * @product.price

    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 8)
    assert_equal total, 6 * @product.price

    total = DiscountService.apply_buy_n_get_m_free(discount: @discount, product: @product, qty: 16)
    assert_equal total, 12 * @product.price
  end

  def test_apply_rule
    total = DiscountService.apply_rule(discount: @discount, product: @product, qty: 16)
    assert_equal total, 12 * @product.price

    # Test against non-existent rule
    discount = Discount.new(code:        'BOGUS',
                            product_sku: 'FOO',
                            description: '...',
                            rule_name:   'NOT_IMPLEMENTED_YET',
                            rule_params: { 'buy_count' => 5, 'free_count' => 2 })
    total = DiscountService.apply_rule(discount: discount, product: @product, qty: 16)
    assert_nil total
  end

  def test_discounted_line_total
    discounts = { @discount.code => @discount }

    total = DiscountService.discounted_line_total(product: @product, qty: 16, discounts: discounts)
    assert_equal total, 12 * @product.price

    # Simulate not finding a matching discount for this product.
    # Since there's no discount that applies, we get nil back.
    total = DiscountService.discounted_line_total(product: @product, qty: 16, discounts: {})
    assert_nil total

    # In pursuit of coverage... let DiscountService load the discounts; but our test
    #   product 'FOO' refers to a test discount code which does not exist in the default
    #   data.
    total = DiscountService.discounted_line_total(product: @product, qty: 16)
    assert_nil total
  end
end
