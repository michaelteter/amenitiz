require_relative './util'

class Discount
  attr_reader :code, :description, :product_sku, :rule_name, :rule_params

  def initialize(args)
    args.each { |k,v| instance_variable_set("@#{k}", v) unless v.nil? }
  end

  def realized_description
    Util.substitute_string_template_values(template: self.description,
                                           data:     self.rule_params)

  end

  def to_s
    "#{self.code}: #{realized_description}"
  end
end
