require 'yaml'
require_relative './discount'

module DiscountService
  extend self

  DEFAULT_DISCOUNTS = 'discounts.yaml'

  def build_discount_from_data(discount_data)
    # Given a discount as defined in a YAML file object,
    #   build a proper Discount object.
    Discount.new(discount_data)
  rescue StandardError => e
    puts "Error building discount from data: #{e}"
    nil
  end

  def load_discounts(source=DEFAULT_DISCOUNTS)
    filepath = File.join(File.dirname(__FILE__), '..', 'assets', source)

    data = YAML.load_file(filepath)

    # Build a discount catalog from the raw data
    discounts = {}
    data.each do |discount_data|
      d = build_discount_from_data(discount_data)
      discounts[d.code] = d
    end

    discounts
  end

  def apply_buy_n_get_m_free(discount:, product:, qty:)
    n = discount.rule_params['buy_count']
    m = discount.rule_params['free_count']

    # TODO: get another pair of eyes to review this; there is probably a
    #   simpler formula that doesn't require a conditional
    pay_qty = if qty <= (n+m)
      [qty, n].min
    else
      full_discount_sets = (qty / (n+m))
      full_discount_qty = full_discount_sets * (n+m)
      remaining_qty = (qty - full_discount_qty) % n
      full_discount_sets * n + remaining_qty
    end

    pay_qty * product.price
  end

  def apply_rule(discount:, product:, qty:)
    fn = 'apply_' + discount.rule_name.downcase
    return unless self.method_defined?(fn)

    self.send(fn, discount: discount, product: product, qty: qty)
  end

  def discounted_line_total(product:, qty:, discounts: nil)
    discount = (discounts || load_discounts[product.sku])&.values&.first
    return if discount.nil? # Let the caller calculate the normal total

    apply_rule(discount: discount, product: product, qty: qty)
  end
end
