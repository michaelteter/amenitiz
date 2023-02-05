require_relative './util'

module CartService
  extend self

  def add_item(cart:, sku:, qty: 1)
    # TODO: ensure sku is valid
    current_qty = cart.items[sku] || 0
    Cart.new(items: cart.items.merge(sku => current_qty + qty))
  end

  def remove_item(cart:, sku:, qty: 1)
    new_qty = (cart.items[sku] || 0) - qty

    if new_qty > 0
      Cart.new(items: cart.items.merge(sku => new_qty))
    else
      Cart.new(items: Util.hash_without_key(cart.items, sku))
    end
  end
end
