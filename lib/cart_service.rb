require_relative './catalog_service'
require_relative './discount_service'
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
      discounted_line_total = DiscountService.discounted_line_total(product: catalog[sku], qty: qty, discounts: nil)
      standard_line_total = catalog[sku].price * qty
      total += discounted_line_total || standard_line_total
    end

    total
  end

  def cart_line_total(product, qty)
    product.price * qty
  end


end

