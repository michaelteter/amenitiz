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
end
