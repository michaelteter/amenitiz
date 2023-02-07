module DisplayService
  extend self

  def product_to_s(product)
    "#{product.sku}: #{product.name} = #{'%.2f' % product.price} €"
  end

  def catalog_to_s(catalog=nil)
    catalog ||= CatalogService.load_products
    catalog.map { |_sku, product| product_to_s(product) }
  end

  def cart_line_to_s(product, qty)
    "#{product.sku}: #{product.name} | #{qty} X #{Util.formatted_currency(product.price)} = " +
      Util.euro_formatted_currency(CartService.cart_line_total(product, qty))
  end

  def cart_to_s(cart, catalog=nil)
    catalog ||= CatalogService.load_products
    cart.items.map do |sku, qty|
      cart_line_to_s(catalog[sku], qty)
    end.join("\n")
  end

  def discount_to_s(discount)
    discount.realized_description
  end

  def discounts_to_s(discounts)
    discounts.map { |_product_sku, discount| discount.realized_description }.join("\n")
  end
end
