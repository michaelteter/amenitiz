require_relative './catalog_service'
require_relative './util'

module CartService
  extend self

  def add_item(cart:, sku:, qty: 1)
    # TODO: ensure sku is valid
    current_qty = cart.items[sku] || 0
    Cart.new(cart.items.merge(sku => current_qty + qty))
  end

  def remove_item(cart:, sku:, qty: 1)
    new_qty = (cart.items[sku] || 0) - qty

    if new_qty > 0
      Cart.new(cart.items.merge(sku => new_qty))
    else
      Cart.new(Util.hash_without_key(cart.items, sku))
    end
  end

  def cart_total(cart)
    total = 0
    catalog = CatalogService.load_products
    cart.items.each do |sku, qty|
      total += catalog[sku].price * qty
    end

    total
  end

  def cart_line_total(product, qty)
    product.price * qty
  end

  def cart_line_to_s(product, qty)
    "#{product.sku}: #{product.name} | #{qty} X #{Util.formatted_currency(product.price)} = " +
      Util.euro_formatted_currency(cart_line_total(product, qty))
  end

  def cart_to_s(cart)
    catalog = CatalogService.load_products
    cart.items.map do |sku, qty|
      cart_line_to_s(catalog[sku], qty)
    end.join("\n")
  end
end

