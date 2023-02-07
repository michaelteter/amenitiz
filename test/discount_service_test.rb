require "minitest/autorun"
require_relative "../lib/cart"
require_relative "../lib/catalog_service"
require_relative "../lib/discount_service"

class TestDiscountService < Minitest::Test
  def setup
    @catalog = CatalogService.load_products
    @discounts = DiscountService.load_discounts
    @sample_cart = Cart.new('GR1' => 2, 'SR1' => 5, 'CF1' => 10)

    @product = Product.new(sku: 'FOO', name: 'Foo d', price: 3.11)
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

  def test_apply_minimum_qty_all_discounted
    discount = Discount.new(code:        'FOO_MINIMUM_QTY_ALL_DISCOUNTED',
                            product_sku: 'FOO',
                            description: 'Buy {{min_qty}}, and get all of this item for {{price_ratio}} of the normal price',
                            rule_name:   'MINIMUM_QTY_ALL_DISCOUNTED',
                            rule_params: { 'min_qty' => 3, 'price_ratio' => '1/2' })
    total = DiscountService.apply_minimum_qty_all_discounted(discount: discount, product: @product, qty: 0)
    assert_equal total, 0

    total = DiscountService.apply_minimum_qty_all_discounted(discount: discount, product: @product, qty: 1)
    assert_equal total, @product.price * 1

    total = DiscountService.apply_minimum_qty_all_discounted(discount: discount, product: @product, qty: 2)
    assert_equal total, @product.price * 2

    total = DiscountService.apply_minimum_qty_all_discounted(discount: discount, product: @product, qty: 3)
    assert_equal total, @product.price * 3 / 2

    total = DiscountService.apply_minimum_qty_all_discounted(discount: discount, product: @product, qty: 4)
    assert_equal total, @product.price * 4 / 2
  end

  def test_apply_minimum_qty_all_at_new_price
    discount = Discount.new(code:        'FOO_MINIMUM_QTY_ALL_AT_NEW_PRICE',
                            product_sku: 'FOO',
                            description: 'Buy {{min_qty}}, and get all of this item for the new low price of {{price}}',
                            rule_name:   'MINIMUM_QTY_ALL_AT_NEW_PRICE',
                            rule_params: { 'min_qty' => 5, 'price' => 2.50 })
    total = DiscountService.apply_minimum_qty_all_at_new_price(discount: discount, product: @product, qty: 0)
    assert_equal total, 0

    total = DiscountService.apply_minimum_qty_all_at_new_price(discount: discount, product: @product, qty: 1)
    assert_equal total, @product.price

    total = DiscountService.apply_minimum_qty_all_at_new_price(discount: discount, product: @product, qty: 5)
    assert_equal total, 5 * discount.rule_params['price']

    total = DiscountService.apply_minimum_qty_all_at_new_price(discount: discount, product: @product, qty: 6)
    assert_equal total, 6 * discount.rule_params['price']
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
    discounts = { @discount.product_sku => @discount }

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
